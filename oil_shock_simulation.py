#!/usr/bin/env python3
"""
Lesotho QPM: 10% Oil Price Shock Simulation
============================================
Solves the linear rational expectations model from lesotho_model.mod
using the Blanchard-Kahn (1980) method, then computes impulse response
functions for a 10 percent oil price shock.

Based on: IMF Country Report No. 2023/269
"Modelling the Impact of External Shocks on Lesotho"
"""

import numpy as np
from scipy import linalg
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pandas as pd
import json
import os

# =========================================================================
# PARAMETER CALIBRATION (v2 - Recalibrated to match IMF paper)
# =========================================================================

# Lesotho IS Curve
alpha_1 = 0.50      # Output persistence
alpha_2 = 0.10      # Forward-looking
alpha_3 = 0.40      # South Africa spillover
alpha_4 = 0.45      # Monetary conditions effect
alpha_5 = 0.50      # Weight on interest rate vs REER
alpha_6 = 0.30      # Fiscal multiplier

# Lesotho Phillips Curve
beta_1 = 0.25       # Output gap effect
omega_1_lso = 0.08  # Oil weight in Lesotho CPI
omega_1_zaf = 0.05  # Oil weight in SA CPI
omega_2_lso = 0.35  # Food weight in Lesotho CPI
omega_2_zaf = 0.20  # Food weight in SA CPI
rho_u = 0.50        # Supply shock persistence

# Lesotho Reserves
delta_res = 0.95    # Reserves persistence
f_1 = 0.50          # Fiscal leakage
f_2 = 0.30          # Exchange rate pressure effect
rho_res_bar = 0.90  # Desired reserves AR
res_ss = 4.70       # Steady-state reserves

# Lesotho Risk Premium
theta_prem = 0.50   # Reserves gap effect on premium

# South Africa IS Curve
gamma_1 = 0.55      # Output persistence
gamma_2 = 0.10      # Forward-looking
gamma_3 = 0.25      # Real interest rate effect
gamma_4 = 0.08      # Real exchange rate effect
gamma_5 = 0.10      # Foreign output spillover

# South Africa Phillips Curve
lambda_1 = 0.50     # Backward-looking weight
lambda_2 = 0.30     # Output gap effect
lambda_3 = 0.15     # Exchange rate pass-through

# South Africa Taylor Rule
phi_i = 0.75        # Interest rate smoothing
phi_pi = 1.50       # Inflation response
phi_y = 0.50        # Output gap response
pi_target_zaf = 4.50

# South Africa UIP
sigma_s = 0.50      # Forward-looking weight

# Rest of World
rho_y_row = 0.80
rho_pi_row = 0.50
rho_i_row = 0.75

# Commodity Prices
rho_oil = 0.70      # Oil price persistence
rho_food = 0.60     # Food price persistence

# Fiscal & REER
rho_g = 0.70
rho_z = 0.80

# =========================================================================
# MODEL SOLUTION VIA BLANCHARD-KAHN METHOD
# =========================================================================
#
# The model is linear: A * E_t[x_{t+1}] = B * x_t + C * eps_t
# where x_t contains all endogenous variables.
#
# Variable ordering (23 variables):
# State (backward-looking, 18):
#   0: y_lso(-1)        1: pi_lso(-1)      2: i_lso
#   3: r_lso            4: z_lso            5: s_lso
#   6: res_gap_lso      7: res_lso          8: res_bar_lso
#   9: prem_lso        10: g_lso           11: y_zaf(-1)
#  12: pi_zaf(-1)      13: i_zaf           14: r_zaf
#  15: z_zaf           16: s_zaf           17: y_row
#  18: pi_row          19: i_row           20: pi_oil
#  21: pi_food         22: eps_u_lso(-1)
#
# For the BK method, we rewrite in first-order form.
# We'll use a direct approach: solve the system equation by equation.

# =========================================================================
# ALTERNATIVE: DIRECT SIMULATION VIA ITERATIVE EXPECTATION
# =========================================================================
# Since the model is small and the shock is known, we can solve
# the perfect-foresight path (deterministic simulation) where the
# only shock is the oil price shock at t=0.

def solve_oil_shock(shock_size_pct=10.0, T=40):
    """
    Solve the model for a deterministic oil price shock using
    the stacked-time (perfect foresight) approach.

    A 10% oil price LEVEL increase corresponds to a shock to oil price
    INFLATION (pi_oil). Since pi_oil = rho_oil * pi_oil(-1) + eps_oil,
    and oil price inflation of 10% in the first quarter means eps_oil = 10.0.

    Parameters
    ----------
    shock_size_pct : float
        Size of oil price inflation shock in percentage points.
    T : int
        Number of periods (quarters) to simulate.

    Returns
    -------
    results : dict of arrays
        IRF paths for all endogenous variables.
    """
    # We solve the system of 23 equations period-by-period using
    # the iterative approach: guess future expectations, solve forward,
    # update, repeat until convergence.

    # Initialize all variables at steady state (zeros in gap model)
    vars_names = [
        'y_lso', 'pi_lso', 'i_lso', 'r_lso', 'z_lso', 's_lso',
        'res_gap_lso', 'res_lso', 'res_bar_lso', 'prem_lso', 'g_lso',
        'y_zaf', 'pi_zaf', 'i_zaf', 'r_zaf', 'z_zaf', 's_zaf',
        'y_row', 'pi_row', 'i_row', 'pi_oil', 'pi_food', 'u_lso'
    ]

    # Extended horizon for convergence
    T_ext = T + 60  # Extra periods for terminal condition

    # Storage: index from -1 (lag) to T_ext
    x = {v: np.zeros(T_ext + 2) for v in vars_names}  # index 0 = period -1 (lag)
    # So x[v][t+1] = value at period t (t=0 is impact period)

    # Oil price shock: eps_oil at t=0 = shock_size_pct
    eps_oil = np.zeros(T_ext + 2)
    eps_oil[1] = shock_size_pct  # period 0 shock (index 1 in array)

    # All other shocks are zero

    # Iterative solution: forward iterate to convergence
    for iteration in range(500):
        x_old = {v: x[v].copy() for v in vars_names}

        for t_idx in range(1, T_ext + 1):  # t_idx=1 is period 0
            t = t_idx  # array index

            # ============================================================
            # EXOGENOUS PROCESSES (no expectations needed)
            # ============================================================

            # Oil price inflation: pi_oil_t = rho_oil * pi_oil_{t-1} + eps_oil_t
            x['pi_oil'][t] = rho_oil * x['pi_oil'][t-1] + eps_oil[t]

            # Food price inflation: pi_food_t = rho_food * pi_food_{t-1}
            x['pi_food'][t] = rho_food * x['pi_food'][t-1]

            # US output gap
            x['y_row'][t] = rho_y_row * x['y_row'][t-1]

            # US inflation
            x['pi_row'][t] = rho_pi_row * x['pi_row'][t-1]

            # US interest rate
            x['i_row'][t] = (rho_i_row * x['i_row'][t-1]
                            + (1 - rho_i_row) * (1.5 * x['pi_row'][t]
                            + 0.5 * x['y_row'][t]))

            # ============================================================
            # SOUTH AFRICA MODULE
            # ============================================================

            # Use previous iteration's expectations for forward-looking vars
            # pi_zaf(+1) from previous iteration
            pi_zaf_lead = x_old['pi_zaf'][t+1] if t+1 <= T_ext else 0.0
            y_zaf_lead = x_old['y_zaf'][t+1] if t+1 <= T_ext else 0.0
            s_zaf_lead = x_old['s_zaf'][t+1] if t+1 <= T_ext else 0.0

            # SA Taylor Rule: i_zaf = phi_i * i_zaf(-1) + (1-phi_i)*(phi_pi*pi_zaf(+1) + phi_y*y_zaf)
            x['i_zaf'][t] = (phi_i * x['i_zaf'][t-1]
                            + (1 - phi_i) * (phi_pi * pi_zaf_lead
                            + phi_y * x['y_zaf'][t-1]))  # use lag for stability

            # SA Fisher: r_zaf = i_zaf - pi_zaf(+1)
            x['r_zaf'][t] = x['i_zaf'][t] - pi_zaf_lead

            # SA UIP: s_zaf = sigma_s * s_zaf(-1) + (1-sigma_s)*s_zaf(+1) - (i_zaf - i_row)/4
            x['s_zaf'][t] = (sigma_s * x['s_zaf'][t-1]
                            + (1 - sigma_s) * s_zaf_lead
                            - (x['i_zaf'][t] - x['i_row'][t]) / 4)

            # SA REER: z_zaf = rho_z * z_zaf(-1) + (s_zaf - s_zaf(-1)) - (pi_zaf - pi_row)/4
            x['z_zaf'][t] = (rho_z * x['z_zaf'][t-1]
                            + (x['s_zaf'][t] - x['s_zaf'][t-1])
                            - (x_old['pi_zaf'][t] - x['pi_row'][t]) / 4)

            # SA Phillips Curve: pi_zaf = lambda_1*pi_zaf(-1) + (1-lambda_1)*pi_zaf(+1)
            #                    + lambda_2*y_zaf + lambda_3*(z_zaf - z_zaf(-1))
            x['pi_zaf'][t] = (lambda_1 * x['pi_zaf'][t-1]
                             + (1 - lambda_1) * pi_zaf_lead
                             + lambda_2 * x['y_zaf'][t-1]  # use lag for stability
                             + lambda_3 * (x['z_zaf'][t] - x['z_zaf'][t-1]))

            # SA IS Curve: y_zaf = gamma_1*y_zaf(-1) + gamma_2*y_zaf(+1)
            #             - gamma_3*r_zaf + gamma_4*z_zaf + gamma_5*y_row
            x['y_zaf'][t] = (gamma_1 * x['y_zaf'][t-1]
                            + gamma_2 * y_zaf_lead
                            - gamma_3 * x['r_zaf'][t]
                            + gamma_4 * x['z_zaf'][t]
                            + gamma_5 * x['y_row'][t])

            # Now update Taylor rule and Phillips curve with current y_zaf
            x['i_zaf'][t] = (phi_i * x['i_zaf'][t-1]
                            + (1 - phi_i) * (phi_pi * pi_zaf_lead
                            + phi_y * x['y_zaf'][t]))
            x['r_zaf'][t] = x['i_zaf'][t] - pi_zaf_lead

            x['pi_zaf'][t] = (lambda_1 * x['pi_zaf'][t-1]
                             + (1 - lambda_1) * pi_zaf_lead
                             + lambda_2 * x['y_zaf'][t]
                             + lambda_3 * (x['z_zaf'][t] - x['z_zaf'][t-1]))

            # ============================================================
            # LESOTHO MODULE
            # ============================================================

            y_lso_lead = x_old['y_lso'][t+1] if t+1 <= T_ext else 0.0
            pi_lso_lead = x_old['pi_lso'][t+1] if t+1 <= T_ext else 0.0

            # Government spending (AR process, no shock)
            x['g_lso'][t] = rho_g * x['g_lso'][t-1]

            # Supply shock persistence
            x['u_lso'][t] = 0.0  # no supply shock

            # Exchange rate peg: s_lso = s_zaf
            x['s_lso'][t] = x['s_zaf'][t]

            # Desired reserves (AR to steady state)
            x['res_bar_lso'][t] = rho_res_bar * x['res_bar_lso'][t-1]

            # Reserves gap dynamics
            x['res_gap_lso'][t] = (delta_res * x['res_gap_lso'][t-1]
                                  - f_1 * x['g_lso'][t]
                                  - f_2 * x_old['z_lso'][t])

            # Actual reserves
            x['res_lso'][t] = x['res_gap_lso'][t] + x['res_bar_lso'][t]

            # Risk premium: prem = theta_prem * (res_bar - res) = theta_prem * (-res_gap)
            x['prem_lso'][t] = (theta_prem * (x['res_bar_lso'][t] - x['res_lso'][t]))
            # Note: res_bar - res = res_bar - (res_gap + res_bar) = -res_gap
            # So prem_lso = -theta_prem * res_gap_lso

            # Interest rate: i_lso = i_zaf + prem_lso
            x['i_lso'][t] = x['i_zaf'][t] + x['prem_lso'][t]

            # Lesotho Phillips Curve
            x['pi_lso'][t] = (x['pi_zaf'][t]
                             + (omega_1_lso - omega_1_zaf) * x['pi_oil'][t]
                             + (omega_2_lso - omega_2_zaf) * x['pi_food'][t]
                             + beta_1 * x_old['y_lso'][t])

            # Fisher equation: r_lso = i_lso - pi_lso(+1)
            x['r_lso'][t] = x['i_lso'][t] - pi_lso_lead

            # REER gap
            x['z_lso'][t] = (rho_z * x['z_lso'][t-1]
                            + (x['s_lso'][t] - x['s_lso'][t-1])
                            - (x['pi_lso'][t] - x['pi_zaf'][t]) / 4)

            # IS Curve
            x['y_lso'][t] = (alpha_1 * x['y_lso'][t-1]
                            + alpha_2 * y_lso_lead
                            + alpha_3 * x['y_zaf'][t]
                            - alpha_4 * (alpha_5 * x['r_lso'][t]
                                        + (1 - alpha_5) * x['z_lso'][t])
                            + alpha_6 * x['g_lso'][t])

            # Update Phillips curve with current y_lso
            x['pi_lso'][t] = (x['pi_zaf'][t]
                             + (omega_1_lso - omega_1_zaf) * x['pi_oil'][t]
                             + (omega_2_lso - omega_2_zaf) * x['pi_food'][t]
                             + beta_1 * x['y_lso'][t])

            # Update REER with current inflation
            x['z_lso'][t] = (rho_z * x['z_lso'][t-1]
                            + (x['s_lso'][t] - x['s_lso'][t-1])
                            - (x['pi_lso'][t] - x['pi_zaf'][t]) / 4)

            # Update reserves gap with current z_lso
            x['res_gap_lso'][t] = (delta_res * x['res_gap_lso'][t-1]
                                  - f_1 * x['g_lso'][t]
                                  - f_2 * x['z_lso'][t])
            x['res_lso'][t] = x['res_gap_lso'][t] + x['res_bar_lso'][t]
            x['prem_lso'][t] = theta_prem * (x['res_bar_lso'][t] - x['res_lso'][t])
            x['i_lso'][t] = x['i_zaf'][t] + x['prem_lso'][t]
            x['r_lso'][t] = x['i_lso'][t] - pi_lso_lead

        # Check convergence
        max_diff = max(np.max(np.abs(x[v] - x_old[v])) for v in vars_names)
        if max_diff < 1e-10:
            print(f"Converged after {iteration+1} iterations (max diff: {max_diff:.2e})")
            break
    else:
        print(f"Warning: Did not fully converge after 500 iterations (max diff: {max_diff:.2e})")

    # Extract IRF paths (period 0 to T-1)
    results = {}
    for v in vars_names:
        results[v] = x[v][1:T+1]  # index 1 = period 0

    return results, vars_names


def compute_cumulative_oil_price(pi_oil_path):
    """Convert oil price inflation path to cumulative price level change."""
    # pi_oil is quarterly inflation rate
    # Cumulative price change: P_t/P_0 - 1 = sum of pi_oil up to t (approx for small changes)
    cumulative = np.cumsum(pi_oil_path)
    return cumulative


def create_irf_plots(results, T=40, output_dir='/home/user/lesotho-qpm'):
    """Generate publication-quality IRF plots for the oil shock."""

    quarters = np.arange(T)

    # ===== Figure 1: Main Macroeconomic Variables =====
    fig, axes = plt.subplots(3, 3, figsize=(14, 11))
    fig.suptitle('Impulse Responses to a 10% Oil Price Shock\nLesotho QPM Model',
                 fontsize=14, fontweight='bold', y=0.98)

    plot_specs = [
        ('pi_oil', 'Oil Price Inflation', 'pp', 'tab:red'),
        ('pi_lso', 'Lesotho Inflation', 'pp', 'tab:blue'),
        ('pi_zaf', 'South Africa Inflation', 'pp', 'tab:green'),
        ('y_lso', 'Lesotho Output Gap', 'pp', 'tab:blue'),
        ('y_zaf', 'South Africa Output Gap', 'pp', 'tab:green'),
        ('i_lso', 'Lesotho Interest Rate (CBL)', 'pp', 'tab:blue'),
        ('i_zaf', 'SA Interest Rate (SARB)', 'pp', 'tab:green'),
        ('z_lso', 'Lesotho REER Gap', 'pp', 'tab:purple'),
        ('r_lso', 'Lesotho Real Interest Rate', 'pp', 'tab:orange'),
    ]

    for idx, (var, title, unit, color) in enumerate(plot_specs):
        ax = axes[idx // 3, idx % 3]
        ax.plot(quarters, results[var], color=color, linewidth=2)
        ax.axhline(y=0, color='black', linewidth=0.5, linestyle='-')
        ax.set_title(title, fontsize=11, fontweight='bold')
        ax.set_xlabel('Quarters after shock')
        ax.set_ylabel(f'Deviation ({unit})')
        ax.grid(True, alpha=0.3)
        ax.set_xlim(0, T-1)

    plt.tight_layout(rect=[0, 0, 1, 0.95])
    fig.savefig(os.path.join(output_dir, 'IRF_oil_shock_macro.png'), dpi=200, bbox_inches='tight')
    plt.close()
    print("Saved: IRF_oil_shock_macro.png")

    # ===== Figure 2: Reserves and Risk Premium Channel =====
    fig, axes = plt.subplots(2, 3, figsize=(14, 8))
    fig.suptitle('Oil Shock: Reserves and Risk Premium Channel\nLesotho QPM Model',
                 fontsize=14, fontweight='bold', y=0.98)

    # Cumulative oil price level
    cum_oil = compute_cumulative_oil_price(results['pi_oil'])

    plot_specs2 = [
        (cum_oil, 'Oil Price Level (cumulative)', '%', 'tab:red'),
        ('res_gap_lso', 'Reserves Gap', 'months of imports', 'tab:brown'),
        ('res_lso', 'Total Reserves Deviation', 'months of imports', 'tab:brown'),
        ('prem_lso', 'Risk Premium', 'pp', 'tab:red'),
        ('z_lso', 'Real Exchange Rate Gap', 'pp (+ = depreciation)', 'tab:purple'),
        ('s_lso', 'Nominal Exchange Rate', 'log deviation', 'tab:purple'),
    ]

    for idx, spec in enumerate(plot_specs2):
        ax = axes[idx // 3, idx % 3]
        if isinstance(spec[0], str):
            data = results[spec[0]]
        else:
            data = spec[0]
        ax.plot(quarters, data, color=spec[3], linewidth=2)
        ax.axhline(y=0, color='black', linewidth=0.5, linestyle='-')
        ax.set_title(spec[1], fontsize=11, fontweight='bold')
        ax.set_xlabel('Quarters after shock')
        ax.set_ylabel(f'Deviation ({spec[2]})')
        ax.grid(True, alpha=0.3)
        ax.set_xlim(0, T-1)

    plt.tight_layout(rect=[0, 0, 1, 0.95])
    fig.savefig(os.path.join(output_dir, 'IRF_oil_shock_reserves.png'), dpi=200, bbox_inches='tight')
    plt.close()
    print("Saved: IRF_oil_shock_reserves.png")

    # ===== Figure 3: Inflation Decomposition =====
    fig, ax = plt.subplots(1, 1, figsize=(10, 6))

    # Decompose Lesotho inflation into components
    oil_component = (omega_1_lso - omega_1_zaf) * results['pi_oil']
    food_component = (omega_2_lso - omega_2_zaf) * results['pi_food']
    sa_component = results['pi_zaf']
    demand_component = beta_1 * results['y_lso']

    ax.stackplot(quarters,
                 [np.maximum(oil_component, 0),
                  np.maximum(sa_component, 0),
                  np.maximum(demand_component, 0)],
                 labels=['Oil price differential', 'SA inflation pass-through', 'Domestic demand'],
                 colors=['#d62728', '#2ca02c', '#1f77b4'],
                 alpha=0.7)

    ax.plot(quarters, results['pi_lso'], 'k-', linewidth=2, label='Total Lesotho inflation')
    ax.axhline(y=0, color='black', linewidth=0.5)
    ax.set_title('Lesotho Inflation Decomposition After 10% Oil Price Shock',
                fontsize=13, fontweight='bold')
    ax.set_xlabel('Quarters after shock', fontsize=11)
    ax.set_ylabel('Percentage points', fontsize=11)
    ax.legend(loc='upper right', fontsize=10)
    ax.grid(True, alpha=0.3)
    ax.set_xlim(0, T-1)

    plt.tight_layout()
    fig.savefig(os.path.join(output_dir, 'IRF_oil_shock_decomposition.png'), dpi=200, bbox_inches='tight')
    plt.close()
    print("Saved: IRF_oil_shock_decomposition.png")

    # ===== Figure 4: Lesotho vs South Africa Comparison =====
    fig, axes = plt.subplots(1, 3, figsize=(14, 5))
    fig.suptitle('Oil Shock: Lesotho vs South Africa Comparison',
                 fontsize=14, fontweight='bold', y=1.02)

    # Inflation comparison
    axes[0].plot(quarters, results['pi_lso'], 'b-', linewidth=2, label='Lesotho')
    axes[0].plot(quarters, results['pi_zaf'], 'g--', linewidth=2, label='South Africa')
    axes[0].axhline(y=0, color='black', linewidth=0.5)
    axes[0].set_title('Inflation', fontsize=11, fontweight='bold')
    axes[0].set_xlabel('Quarters')
    axes[0].set_ylabel('pp deviation')
    axes[0].legend()
    axes[0].grid(True, alpha=0.3)

    # Output comparison
    axes[1].plot(quarters, results['y_lso'], 'b-', linewidth=2, label='Lesotho')
    axes[1].plot(quarters, results['y_zaf'], 'g--', linewidth=2, label='South Africa')
    axes[1].axhline(y=0, color='black', linewidth=0.5)
    axes[1].set_title('Output Gap', fontsize=11, fontweight='bold')
    axes[1].set_xlabel('Quarters')
    axes[1].set_ylabel('pp deviation')
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)

    # Interest rate comparison
    axes[2].plot(quarters, results['i_lso'], 'b-', linewidth=2, label='Lesotho (CBL)')
    axes[2].plot(quarters, results['i_zaf'], 'g--', linewidth=2, label='South Africa (SARB)')
    axes[2].axhline(y=0, color='black', linewidth=0.5)
    axes[2].set_title('Policy Interest Rate', fontsize=11, fontweight='bold')
    axes[2].set_xlabel('Quarters')
    axes[2].set_ylabel('pp deviation')
    axes[2].legend()
    axes[2].grid(True, alpha=0.3)

    plt.tight_layout()
    fig.savefig(os.path.join(output_dir, 'IRF_oil_shock_comparison.png'), dpi=200, bbox_inches='tight')
    plt.close()
    print("Saved: IRF_oil_shock_comparison.png")

    return True


def generate_summary_table(results, T=40):
    """Generate summary statistics for the oil shock IRFs."""

    summary = {}

    key_vars = {
        'pi_oil': 'Oil Price Inflation',
        'y_lso': 'Lesotho Output Gap',
        'pi_lso': 'Lesotho Inflation',
        'i_lso': 'Lesotho Interest Rate',
        'r_lso': 'Lesotho Real Rate',
        'z_lso': 'Lesotho REER Gap',
        'res_gap_lso': 'Reserves Gap',
        'prem_lso': 'Risk Premium',
        'y_zaf': 'SA Output Gap',
        'pi_zaf': 'SA Inflation',
        'i_zaf': 'SARB Rate',
    }

    for var, label in key_vars.items():
        path = results[var]
        impact = path[0]
        peak_idx = np.argmax(np.abs(path[:20]))
        peak = path[peak_idx]
        cumulative = np.sum(path[:20])
        yr1_avg = np.mean(path[:4])
        yr2_avg = np.mean(path[4:8])

        summary[label] = {
            'Impact (Q0)': round(impact, 4),
            'Peak': round(peak, 4),
            'Peak Quarter': int(peak_idx),
            'Year 1 Avg': round(yr1_avg, 4),
            'Year 2 Avg': round(yr2_avg, 4),
            'Cumulative (5yr)': round(cumulative, 4),
        }

    return summary


def save_results_json(results, summary, output_dir='/home/user/lesotho-qpm'):
    """Save numerical results for the report."""

    # Convert numpy arrays to lists for JSON serialization
    json_results = {k: v.tolist() for k, v in results.items()}

    output = {
        'shock': '10% oil price shock (eps_oil = 10.0)',
        'model': 'Lesotho QPM v2 (recalibrated)',
        'method': 'Perfect foresight / iterative expectations',
        'horizon': len(next(iter(results.values()))),
        'summary': summary,
        'irf_paths': json_results,
    }

    filepath = os.path.join(output_dir, 'oil_shock_results.json')
    with open(filepath, 'w') as f:
        json.dump(output, f, indent=2)
    print(f"Saved: {filepath}")


# =========================================================================
# MAIN EXECUTION
# =========================================================================

if __name__ == '__main__':
    print("=" * 70)
    print("LESOTHO QPM: 10% OIL PRICE SHOCK SIMULATION")
    print("=" * 70)
    print()

    # Solve the model
    print("Solving model with 10% oil price shock...")
    results, var_names = solve_oil_shock(shock_size_pct=10.0, T=40)

    print()
    print("Key Impact Results:")
    print("-" * 50)
    print(f"  Oil price inflation (impact):   {results['pi_oil'][0]:+.2f} pp")
    print(f"  Lesotho inflation (impact):     {results['pi_lso'][0]:+.2f} pp")
    print(f"  SA inflation (impact):          {results['pi_zaf'][0]:+.2f} pp")
    print(f"  Lesotho output gap (impact):    {results['y_lso'][0]:+.4f} pp")
    print(f"  SA output gap (impact):         {results['y_zaf'][0]:+.4f} pp")
    print(f"  Lesotho REER gap (impact):      {results['z_lso'][0]:+.4f} pp")
    print(f"  Reserves gap (impact):          {results['res_gap_lso'][0]:+.4f} months")
    print(f"  Risk premium (impact):          {results['prem_lso'][0]:+.4f} pp")
    print()

    peak_pi = np.max(results['pi_lso'])
    peak_pi_q = np.argmax(results['pi_lso'])
    trough_y = np.min(results['y_lso'])
    trough_y_q = np.argmin(results['y_lso'])
    print(f"  Lesotho inflation peak:         {peak_pi:+.2f} pp (Q{peak_pi_q})")
    print(f"  Lesotho output trough:          {trough_y:+.4f} pp (Q{trough_y_q})")
    print()

    # Generate plots
    print("Generating IRF plots...")
    create_irf_plots(results, T=40)

    # Generate summary table
    print("Generating summary statistics...")
    summary = generate_summary_table(results)

    # Save results
    save_results_json(results, summary)

    # Print summary table
    print()
    print("=" * 90)
    print("SUMMARY TABLE: 10% Oil Price Shock")
    print("=" * 90)
    df = pd.DataFrame(summary).T
    print(df.to_string())
    print()
    print("Simulation complete.")
