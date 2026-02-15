// =====================================================================
// [COUNTRY] [MODEL_TYPE] Model
// Based on: [LITERATURE_REFERENCE]
// Author: [AUTHOR]
// Date: [DATE]
// =====================================================================
//
// MODEL OVERVIEW:
// - Type: [QPM/FPAS/DSGE/New Keynesian]
// - Structure: [Small open economy/Multi-country/Currency union]
// - Key features:
//   * [Feature 1]
//   * [Feature 2]
//   * [Feature 3]
//
// USAGE:
//   dynare country_model.mod
//   dynare country_model.mod noclearall  (keep workspace)
//
// OUTPUT:
// - IRFs saved to: model/Output/
// - Graphs saved to: model/graphs/
//
// =====================================================================

// -------------------------------------------------------------------------
// VARIABLES
// -------------------------------------------------------------------------

var
    // DOMESTIC VARIABLES
    y           // Output gap (% deviation from SS)
    pi          // Inflation (annualized %)
    i           // Nominal interest rate (annualized %)
    r           // Real interest rate (annualized %)
    z           // Real exchange rate gap (%)
    s           // Nominal exchange rate (level)

    // FOREIGN VARIABLES (if applicable)
    y_f         // Foreign output gap
    pi_f        // Foreign inflation
    i_f         // Foreign interest rate

    // AUXILIARY
    eps_y_aux   // Auxiliary for shock (if needed)
    ;

varexo
    eps_y       // Output shock
    eps_pi      // Inflation shock
    eps_i       // Interest rate shock
    eps_f       // Foreign shock (if applicable)
    ;

// -------------------------------------------------------------------------
// PARAMETERS
// -------------------------------------------------------------------------

parameters
    // IS CURVE
    alpha_1     // Own persistence
    alpha_2     // Forward-looking
    alpha_3     // Foreign spillover
    alpha_4     // Monetary conditions
    alpha_5     // Interest rate vs REER weight
    alpha_6     // Fiscal multiplier

    // PHILLIPS CURVE
    beta_1      // Output gap effect
    beta_2      // Inflation expectations

    // POLICY RULE
    phi_i       // Interest smoothing
    phi_pi      // Inflation response
    phi_y       // Output response
    pi_target   // Inflation target

    // SHOCK PERSISTENCE
    rho_y       // Output shock persistence
    rho_pi      // Inflation shock persistence
    rho_i       // Interest shock persistence
    ;

// -------------------------------------------------------------------------
// PARAMETER VALUES
// -------------------------------------------------------------------------
// Sources: [Add literature sources for each parameter]

// IS curve
alpha_1 = 0.50;     // Persistence (literature: 0.3-0.7)
alpha_2 = 0.10;     // Forward-looking
alpha_3 = 0.30;     // Spillover (calibrate to match IRFs)
alpha_4 = 0.45;     // Monetary conditions effect
alpha_5 = 0.50;     // Weight on interest rate
alpha_6 = 0.30;     // Fiscal multiplier

// Phillips curve
beta_1 = 0.25;      // Output gap effect
beta_2 = 0.50;      // Inflation expectations weight

// Taylor rule
phi_i = 0.75;       // Smoothing (central banks: 0.5-0.9)
phi_pi = 1.50;      // Inflation response (Taylor principle > 1)
phi_y = 0.50;       // Output response
pi_target = 0.045;  // Inflation target (4.5% annual)

// Shock persistence
rho_y = 0.70;       // AR(1) coefficient
rho_pi = 0.50;
rho_i = 0.60;

// -------------------------------------------------------------------------
// MODEL EQUATIONS
// -------------------------------------------------------------------------

model(linear);

    // =====================================================================
    // 1. IS CURVE (Aggregate Demand)
    // =====================================================================
    // Output depends on: lagged output, expected output, foreign output,
    // monetary conditions (real rate + REER), fiscal policy

    y = alpha_1*y(-1)
      + alpha_2*y(+1)
      + alpha_3*y_f
      - alpha_4*(alpha_5*r + (1-alpha_5)*z)
      + eps_y;

    // =====================================================================
    // 2. PHILLIPS CURVE (Aggregate Supply)
    // =====================================================================
    // Inflation depends on: expected inflation, output gap, supply shocks

    pi = beta_1*pi(+1)
       + beta_2*y
       + eps_pi;

    // =====================================================================
    // 3. TAYLOR RULE (Monetary Policy)
    // =====================================================================
    // Interest rate responds to: lagged rate, expected inflation, output gap

    i = phi_i*i(-1)
      + (1-phi_i)*(pi_target + phi_pi*(pi(+1)-pi_target) + phi_y*y)
      + eps_i;

    // =====================================================================
    // 4. REAL RATE DEFINITION
    // =====================================================================
    r = i - pi(+1);

    // =====================================================================
    // 5. REAL EXCHANGE RATE (Uncovered Interest Parity)
    // =====================================================================
    // z = s + p_f - p (approximated here)

    z = z(+1) + (i - i_f);

    // =====================================================================
    // 6. NOMINAL EXCHANGE RATE
    // =====================================================================
    s = s(-1) + pi - pi_f + (z - z(-1));

    // =====================================================================
    // 7. FOREIGN BLOCK (AR processes)
    // =====================================================================
    y_f = rho_y*y_f(-1) + eps_f;
    pi_f = rho_pi*pi_f(-1);  // Simplified
    i_f = rho_i*i_f(-1);

end;

// -------------------------------------------------------------------------
// STEADY STATE
// -------------------------------------------------------------------------
// All variables in log-deviations, so steady state is zero

steady_state_model;
    y = 0;
    pi = pi_target;
    i = pi_target;
    r = pi_target;
    z = 0;
    s = 0;
    y_f = 0;
    pi_f = pi_target;
    i_f = pi_target;
end;

// -------------------------------------------------------------------------
// SHOCKS
// -------------------------------------------------------------------------

shocks;
    var eps_y = 0.01^2;     // 1% std dev
    var eps_pi = 0.005^2;   // 0.5% std dev
    var eps_i = 0.002^2;    // 0.25% std dev
    var eps_f = 0.01^2;     // 1% std dev
end;

// -------------------------------------------------------------------------
// SIMULATION OPTIONS
// -------------------------------------------------------------------------

stoch_simul(order=1,              // Linear approximation
           irf=40,                // IRF length (quarters)
           periods=0,             // No simulation (only IRFs)
           noprint,               // Suppress output
           nograph,               // No automatic graphs
           drop=0,                // No burn-in
           conditional_variance_decomposition=[1,4,8,16,40])  // Horizon
           y pi i r z s y_f pi_f i_f;

// -------------------------------------------------------------------------
// CHECKS
// -------------------------------------------------------------------------

check;  // Check BK conditions

// -------------------------------------------------------------------------
// END OF FILE
// -------------------------------------------------------------------------
