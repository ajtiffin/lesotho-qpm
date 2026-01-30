// =========================================================================
// LESOTHO QPM MODEL
// =========================================================================
// Based on: IMF Country Report No. 2023/269
// "Modelling the Impact of External Shocks on Lesotho"
// Prepared by Zviad Zedginidze
//
// Two-country semi-structural New Keynesian model featuring:
// - Lesotho module with currency peg to South African Rand
// - South Africa module (inflation targeting, flexible exchange rate)
// - Foreign exchange reserves dynamics
// - Risk premium channel linking reserves to real economy
// =========================================================================

// -------------------------------------------------------------------------
// VARIABLE DECLARATIONS
// -------------------------------------------------------------------------

var
    // Lesotho variables
    y_lso           // Output gap (% deviation from potential)
    pi_lso          // Inflation (year-over-year)
    i_lso           // Nominal interest rate (CBL policy rate)
    r_lso           // Real interest rate
    z_lso           // Real effective exchange rate gap (+ = depreciation)
    s_lso           // Nominal exchange rate (Loti/USD, log)
    res_gap_lso     // Reserves gap (deviation from desired)
    res_lso         // International reserves (months of imports)
    res_bar_lso     // Desired reserves level
    prem_lso        // Currency risk premium
    g_lso           // Government spending shock (% of GDP)

    // South Africa variables
    y_zaf           // Output gap
    pi_zaf          // Inflation
    i_zaf           // Nominal interest rate (SARB policy rate)
    r_zaf           // Real interest rate
    z_zaf           // Real effective exchange rate gap
    s_zaf           // Nominal exchange rate (Rand/USD, log)

    // Rest of World (US) variables
    y_row           // US output gap
    pi_row          // US inflation
    i_row           // US Fed funds rate

    // Commodity prices
    pi_oil          // Oil price inflation
    pi_food         // Food price inflation
;

varexo
    // Lesotho shocks
    eps_y_lso       // Demand shock
    eps_pi_lso      // Cost-push shock
    eps_i_lso       // Monetary policy shock (deviation from peg)
    eps_s_lso       // Exchange rate shock
    eps_res_lso     // Reserves shock
    eps_prem_lso    // Risk premium shock
    eps_g_lso       // Fiscal shock
    eps_u_lso       // Persistent supply shock

    // South Africa shocks
    eps_y_zaf       // Demand shock
    eps_pi_zaf      // Cost-push shock
    eps_i_zaf       // Monetary policy shock
    eps_s_zaf       // Exchange rate shock

    // Rest of World shocks
    eps_y_row       // US demand shock
    eps_pi_row      // US inflation shock
    eps_i_row       // US monetary policy shock

    // Commodity shocks
    eps_oil         // Oil price shock
    eps_food        // Food price shock
;

parameters
    // =====================================================================
    // LESOTHO IS CURVE PARAMETERS
    // =====================================================================
    alpha_1         // Output persistence (lag)
    alpha_2         // Forward-looking output
    alpha_3         // Spillover from South Africa output gap
    alpha_4         // Monetary conditions effect on output
    alpha_5         // Weight on interest rate in monetary conditions (vs REER)
    alpha_6         // Fiscal multiplier (government spending effect)

    // =====================================================================
    // LESOTHO PHILLIPS CURVE PARAMETERS
    // =====================================================================
    beta_1          // Output gap effect on inflation
    omega_1_lso     // Oil weight in Lesotho CPI
    omega_1_zaf     // Oil weight in South Africa CPI
    omega_2_lso     // Food weight in Lesotho CPI
    omega_2_zaf     // Food weight in South Africa CPI
    rho_u           // Persistence of supply shock

    // =====================================================================
    // LESOTHO RESERVES PARAMETERS
    // =====================================================================
    delta_res       // Reserves persistence
    f_1             // Government spending effect on reserves
    f_2             // Exchange rate pressure effect on reserves
    rho_res_bar     // Desired reserves AR coefficient
    res_ss          // Steady-state reserves (months of imports)

    // =====================================================================
    // LESOTHO RISK PREMIUM PARAMETERS
    // =====================================================================
    theta_prem      // Reserves gap effect on risk premium

    // =====================================================================
    // SOUTH AFRICA IS CURVE PARAMETERS
    // =====================================================================
    gamma_1         // Output persistence (lag)
    gamma_2         // Forward-looking output
    gamma_3         // Real interest rate effect
    gamma_4         // Real exchange rate effect
    gamma_5         // Foreign output spillover

    // =====================================================================
    // SOUTH AFRICA PHILLIPS CURVE PARAMETERS
    // =====================================================================
    lambda_1        // Inflation persistence (backward-looking weight)
    lambda_2        // Output gap effect
    lambda_3        // Exchange rate pass-through

    // =====================================================================
    // SOUTH AFRICA TAYLOR RULE PARAMETERS
    // =====================================================================
    phi_i           // Interest rate smoothing
    phi_pi          // Inflation response
    phi_y           // Output gap response
    pi_target_zaf   // Inflation target (midpoint)

    // =====================================================================
    // SOUTH AFRICA UIP PARAMETERS
    // =====================================================================
    sigma_s         // Forward-looking weight in UIP

    // =====================================================================
    // REST OF WORLD PARAMETERS
    // =====================================================================
    rho_y_row       // US output gap persistence
    rho_pi_row      // US inflation persistence
    rho_i_row       // US interest rate persistence

    // =====================================================================
    // COMMODITY PRICE PARAMETERS
    // =====================================================================
    rho_oil         // Oil price persistence
    rho_food        // Food price persistence

    // =====================================================================
    // FISCAL SHOCK PERSISTENCE
    // =====================================================================
    rho_g           // Government spending shock persistence

    // =====================================================================
    // REAL EXCHANGE RATE PERSISTENCE
    // =====================================================================
    rho_z           // REER gap persistence (PPP mean-reversion)
;

// -------------------------------------------------------------------------
// PARAMETER CALIBRATION (v2 - Recalibrated to match IMF paper IRFs)
// -------------------------------------------------------------------------
// Based on IMF CR/2023/269 Bayesian estimation and calibration
// Adjusted to better replicate Figures 4 and 6 impulse responses

// Lesotho IS Curve (from Figure 3 posterior estimates)
alpha_1     = 0.50;     // Output persistence
alpha_2     = 0.10;     // Forward-looking (small, given limited financial development)
alpha_3     = 0.40;     // South Africa spillover (increased from 0.35 to match IRFs)
alpha_4     = 0.45;     // Monetary conditions effect (increased from 0.30)
alpha_5     = 0.50;     // Weight on interest rate vs REER (posterior ~0.5)
alpha_6     = 0.30;     // Fiscal multiplier (posterior ~0.30, prior 0.3) - UNCHANGED

// Lesotho Phillips Curve
beta_1      = 0.25;     // Output gap effect (increased from 0.10 to match inflation IRFs)
omega_1_lso = 0.08;     // Oil weight in Lesotho CPI (~8%)
omega_1_zaf = 0.05;     // Oil weight in SA CPI (~5%)
omega_2_lso = 0.35;     // Food weight in Lesotho CPI (~35%)
omega_2_zaf = 0.20;     // Food weight in SA CPI (~20%)
rho_u       = 0.50;     // Supply shock persistence

// Lesotho Reserves
delta_res   = 0.95;     // High persistence (near unit root, but < 1 for stationarity)
f_1         = 0.50;     // Fiscal leakage to imports
f_2         = 0.30;     // Exchange rate pressure effect
rho_res_bar = 0.90;     // Desired reserves AR coefficient
res_ss      = 4.70;     // ARA for CCEs target: 4.7 months (March 2023)

// Lesotho Risk Premium
theta_prem  = 0.50;     // Reserves gap effect on premium (posterior ~0.5)

// South Africa IS Curve (strengthened to match paper's SA responses)
gamma_1     = 0.55;     // Output persistence (reduced slightly for faster dynamics)
gamma_2     = 0.10;     // Forward-looking
gamma_3     = 0.25;     // Real interest rate effect (increased from 0.15)
gamma_4     = 0.08;     // Real exchange rate effect (increased from 0.05)
gamma_5     = 0.10;     // Foreign (US) output spillover

// South Africa Phillips Curve (strengthened)
lambda_1    = 0.50;     // Backward-looking weight
lambda_2    = 0.30;     // Output gap effect (increased from 0.25)
lambda_3    = 0.15;     // Exchange rate pass-through (increased from 0.10)

// South Africa Taylor Rule
phi_i       = 0.75;     // Interest rate smoothing
phi_pi      = 1.50;     // Inflation response (Taylor principle)
phi_y       = 0.50;     // Output gap response
pi_target_zaf = 4.50;   // SARB target midpoint (3-6% band)

// South Africa UIP
sigma_s     = 0.50;     // Forward-looking weight

// Rest of World (US)
rho_y_row   = 0.80;     // US output gap persistence
rho_pi_row  = 0.50;     // US inflation persistence
rho_i_row   = 0.75;     // US interest rate persistence

// Commodity Prices
rho_oil     = 0.70;     // Oil price persistence
rho_food    = 0.60;     // Food price persistence

// Fiscal
rho_g       = 0.70;     // Government spending persistence

// Real Exchange Rate
rho_z       = 0.80;     // REER gap persistence (PPP half-life ~3 quarters)

// -------------------------------------------------------------------------
// MODEL EQUATIONS
// -------------------------------------------------------------------------

model(linear);

    // =====================================================================
    // LESOTHO MODULE
    // =====================================================================

    // 1. IS Curve (Aggregate Demand) - Equation 15 in paper
    // Output gap depends on:
    // - Own lag and lead (persistence and forward-looking)
    // - South Africa output gap (trade and remittances channel)
    // - Monetary conditions (real rate and REER)
    // - Government spending (fiscal impulse)
    y_lso = alpha_1 * y_lso(-1)
          + alpha_2 * y_lso(+1)
          + alpha_3 * y_zaf
          - alpha_4 * (alpha_5 * r_lso + (1 - alpha_5) * z_lso)
          + alpha_6 * g_lso
          + eps_y_lso;

    // 2. Phillips Curve (Aggregate Supply) - Equation 16 in paper
    // Lesotho inflation driven by:
    // - South Africa inflation (peg transmits price level)
    // - Differential commodity weights in CPI baskets
    // - Domestic output gap (marginal costs)
    // - Persistent supply shock
    pi_lso = pi_zaf
           + (omega_1_lso - omega_1_zaf) * pi_oil
           + (omega_2_lso - omega_2_zaf) * pi_food
           + beta_1 * y_lso
           + eps_u_lso + rho_u * eps_u_lso(-1)
           + eps_pi_lso;

    // 3. Exchange Rate Peg - Equation 17
    // Loti pegged to Rand at par
    s_lso = s_zaf + eps_s_lso;

    // 4. Interest Rate Rule - Equation 17
    // CBL tracks SARB rate plus risk premium
    i_lso = i_zaf + prem_lso + eps_i_lso;

    // 5. Fisher Equation (Real Interest Rate)
    r_lso = i_lso - pi_lso(+1);

    // 6. Real Effective Exchange Rate Gap
    // REER gap with mean-reversion (PPP holds in long run)
    // + = depreciation = loss of competitiveness
    z_lso = rho_z * z_lso(-1) + (s_lso - s_lso(-1)) - (pi_lso - pi_zaf) / 4;

    // 7. Reserves Gap Dynamics - Equation 18
    // Government spending drains reserves (import leakage)
    // Exchange rate pressure affects reserves
    res_gap_lso = delta_res * res_gap_lso(-1)
                - f_1 * g_lso
                - f_2 * z_lso
                + eps_res_lso;

    // 8. Desired Reserves (AR process to steady state)
    res_bar_lso = rho_res_bar * res_bar_lso(-1);

    // 9. Actual Reserves (identity)
    res_lso = res_gap_lso + res_bar_lso;

    // 11. Currency Risk Premium - Equation 19
    // Premium rises when reserves fall below desired level
    prem_lso = theta_prem * (res_bar_lso - res_lso) + eps_prem_lso;

    // 12. Government Spending Shock (AR process)
    g_lso = rho_g * g_lso(-1) + eps_g_lso;

    // =====================================================================
    // SOUTH AFRICA MODULE (Standard FPAS for Inflation Targeting)
    // =====================================================================

    // 13. IS Curve
    y_zaf = gamma_1 * y_zaf(-1)
          + gamma_2 * y_zaf(+1)
          - gamma_3 * r_zaf
          + gamma_4 * z_zaf
          + gamma_5 * y_row
          + eps_y_zaf;

    // 14. Phillips Curve (Hybrid)
    pi_zaf = lambda_1 * pi_zaf(-1)
           + (1 - lambda_1) * pi_zaf(+1)
           + lambda_2 * y_zaf
           + lambda_3 * (z_zaf - z_zaf(-1))
           + eps_pi_zaf;

    // 15. Taylor Rule
    i_zaf = phi_i * i_zaf(-1)
          + (1 - phi_i) * (phi_pi * pi_zaf(+1) + phi_y * y_zaf)
          + eps_i_zaf;

    // 16. Fisher Equation
    r_zaf = i_zaf - pi_zaf(+1);

    // 17. UIP (Hybrid Forward-Looking)
    s_zaf = sigma_s * s_zaf(-1)
          + (1 - sigma_s) * s_zaf(+1)
          - (i_zaf - i_row - 0) / 4  // No risk premium for simplicity
          + eps_s_zaf;

    // 18. Real Effective Exchange Rate Gap (South Africa)
    // With mean-reversion (PPP holds in long run)
    z_zaf = rho_z * z_zaf(-1) + (s_zaf - s_zaf(-1)) - (pi_zaf - pi_row) / 4;

    // =====================================================================
    // REST OF WORLD (US) MODULE - Exogenous AR Processes
    // =====================================================================

    // 19. US Output Gap
    y_row = rho_y_row * y_row(-1) + eps_y_row;

    // 20. US Inflation
    pi_row = rho_pi_row * pi_row(-1) + eps_pi_row;

    // 21. US Interest Rate (Simple Taylor-type rule)
    i_row = rho_i_row * i_row(-1) + (1 - rho_i_row) * (1.5 * pi_row + 0.5 * y_row) + eps_i_row;

    // =====================================================================
    // COMMODITY PRICES - Exogenous AR Processes
    // =====================================================================

    // 22. Oil Price Inflation
    pi_oil = rho_oil * pi_oil(-1) + eps_oil;

    // 23. Food Price Inflation
    pi_food = rho_food * pi_food(-1) + eps_food;

end;

// -------------------------------------------------------------------------
// STEADY STATE (All gaps = 0)
// -------------------------------------------------------------------------

initval;
    y_lso       = 0;
    pi_lso      = 0;
    i_lso       = 0;
    r_lso       = 0;
    z_lso       = 0;
    s_lso       = 0;
    res_gap_lso = 0;
    res_lso     = 0;
    res_bar_lso = 0;
    prem_lso    = 0;
    g_lso       = 0;

    y_zaf       = 0;
    pi_zaf      = 0;
    i_zaf       = 0;
    r_zaf       = 0;
    z_zaf       = 0;
    s_zaf       = 0;

    y_row       = 0;
    pi_row      = 0;
    i_row       = 0;

    pi_oil      = 0;
    pi_food     = 0;
end;

steady;
check;

// -------------------------------------------------------------------------
// SHOCK VARIANCES
// -------------------------------------------------------------------------

shocks;
    // Lesotho shocks
    var eps_y_lso;      stderr 1.0;
    var eps_pi_lso;     stderr 0.5;
    var eps_i_lso;      stderr 0.25;
    var eps_s_lso;      stderr 0.1;     // Small (peg is credible)
    var eps_res_lso;    stderr 1.0;
    var eps_prem_lso;   stderr 0.5;
    var eps_g_lso;      stderr 1.0;     // 1pp of GDP fiscal shock
    var eps_u_lso;      stderr 1.0;     // Persistent supply shock

    // South Africa shocks
    var eps_y_zaf;      stderr 1.0;
    var eps_pi_zaf;     stderr 0.5;
    var eps_i_zaf;      stderr 0.25;
    var eps_s_zaf;      stderr 1.0;

    // US shocks
    var eps_y_row;      stderr 0.5;
    var eps_pi_row;     stderr 0.25;
    var eps_i_row;      stderr 0.25;

    // Commodity shocks
    var eps_oil;        stderr 5.0;     // Oil is volatile
    var eps_food;       stderr 3.0;     // Food is volatile
end;

// -------------------------------------------------------------------------
// SIMULATION
// -------------------------------------------------------------------------

stoch_simul(order=1, irf=40, periods=200);
