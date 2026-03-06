// =========================================================================
// LESOTHO QPM MODEL - VERSION 3
// =========================================================================
// Based on: IMF Country Report No. 2023/269
//           SARB Working Paper WP1701 (2017) - Commodity price extension
//           Assessment Report: Balance of Payments modifications (Option B)
//
// Version 3 changes:
// - Replaced REER-reserves channel (-f_2*z_lso) with BOP-based specification
// - Added domestic demand leakage (-f_3*y_lso): imports drain reserves
// - Added SA demand inflow (+f_4*y_zaf): SACU/exports boost reserves
// - Calibrated per assessment: f_3=0.10, f_4=0.05
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
    rcom            // Real commodity price index (terms of trade) - TREND
    rcom_bar        // Trend component of real commodity price
    d_rcom          // Deviation of rcom from trend (gap) - enters IS curve
    pi_com          // Nominal commodity price inflation
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
    eps_com         // Commodity price shock
    eps_rcom_trend  // Trend shock to real commodity price
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
    // LESOTHO RESERVES PARAMETERS (V3 - BOP-based specification)
    // =====================================================================
    delta_res       // Reserves persistence
    f_1             // Government spending effect on reserves (import leakage)
    f_3             // Domestic demand effect on reserves (NEW in v3)
    f_4             // SA demand effect on reserves (NEW in v3)
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
    gamma_6         // Commodity terms of trade effect

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
    rho_com         // Nominal commodity price persistence
    rho_d_rcom      // Persistence of commodity price gap

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
// PARAMETER CALIBRATION (v3 - BOP-based reserves equation)
// -------------------------------------------------------------------------
// Based on IMF CR/2023/269, SARB WP1701, and Assessment Report Option B

// Lesotho IS Curve
alpha_1     = 0.50;     // Output persistence
alpha_2     = 0.10;     // Forward-looking
alpha_3     = 0.30;     // South Africa spillover
alpha_4     = 0.20;     // Monetary conditions effect (ADJUSTED from 0.45 for realistic amplification)
alpha_5     = 0.50;     // Weight on interest rate vs REER
alpha_6     = 0.30;     // Fiscal multiplier

// Lesotho Phillips Curve
beta_1      = 0.25;     // Output gap effect
omega_1_lso = 0.08;     // Oil weight in Lesotho CPI (~8%)
omega_1_zaf = 0.05;     // Oil weight in SA CPI (~5%)
omega_2_lso = 0.35;     // Food weight in Lesotho CPI (~35%)
omega_2_zaf = 0.20;     // Food weight in SA CPI (~20%)
rho_u       = 0.50;     // Supply shock persistence

// Lesotho Reserves (V3 - BOP-based per Assessment Report Option B)
delta_res   = 0.90;     // Reserve persistence
f_1         = 0.35;     // Fiscal leakage to imports (unchanged)
f_3         = 0.10;     // Domestic demand leakage (NEW: 0.10 per assessment)
f_4         = 0.02;     // SA demand/SACU inflow (ADJUSTED: 0.02, weaker SACU effect)
rho_res_bar = 0.90;     // Desired reserves AR coefficient
res_ss      = 4.70;     // ARA for CCEs target: 4.7 months

// Lesotho Risk Premium
theta_prem  = 0.35;     // Reserves gap effect on premium

// South Africa IS Curve
gamma_1     = 0.55;     // Output persistence
gamma_2     = 0.10;     // Forward-looking
gamma_3     = 0.25;     // Real interest rate effect
gamma_4     = 0.08;     // Real exchange rate effect
gamma_5     = 0.10;     // Foreign (US) output spillover
gamma_6     = 0.01;     // Commodity terms of trade effect (SARB: a6 = 0.01)

// South Africa Phillips Curve
lambda_1    = 0.50;     // Backward-looking weight
lambda_2    = 0.30;     // Output gap effect
lambda_3    = 0.15;     // Exchange rate pass-through

// South Africa Taylor Rule
phi_i       = 0.75;     // Interest rate smoothing
phi_pi      = 1.50;     // Inflation response
phi_y       = 0.50;     // Output gap response
pi_target_zaf = 4.50;   // SARB target midpoint

// South Africa UIP
sigma_s     = 0.50;     // Forward-looking weight

// Rest of World (US)
rho_y_row   = 0.80;     // US output gap persistence
rho_pi_row  = 0.50;     // US inflation persistence
rho_i_row   = 0.75;     // US interest rate persistence

// Commodity Prices
rho_oil     = 0.70;     // Oil price persistence
rho_food    = 0.60;     // Food price persistence
rho_com     = 0.70;     // Nominal commodity price persistence
rho_d_rcom  = 0.70;     // Persistence of commodity price gap

// Fiscal
rho_g       = 0.70;     // Government spending persistence

// Real Exchange Rate
rho_z       = 0.80;     // REER gap persistence

// -------------------------------------------------------------------------
// MODEL EQUATIONS
// -------------------------------------------------------------------------

model(linear);

    // =====================================================================
    // LESOTHO MODULE
    // =====================================================================

    // 1. IS Curve (Aggregate Demand)
    y_lso = alpha_1 * y_lso(-1)
          + alpha_2 * y_lso(+1)
          + alpha_3 * y_zaf
          - alpha_4 * (alpha_5 * r_lso + (1 - alpha_5) * z_lso)
          + alpha_6 * g_lso
          + eps_y_lso;

    // 2. Phillips Curve (Aggregate Supply)
    pi_lso = pi_zaf
           + (omega_1_lso - omega_1_zaf) * pi_oil
           + (omega_2_lso - omega_2_zaf) * pi_food
           + beta_1 * y_lso
           + eps_u_lso + rho_u * eps_u_lso(-1)
           + eps_pi_lso;

    // 3. Exchange Rate Peg
    s_lso = s_zaf + eps_s_lso;

    // 4. Interest Rate Rule
    i_lso = i_zaf + prem_lso + eps_i_lso;

    // 5. Fisher Equation (Real Interest Rate)
    r_lso = i_lso - pi_lso(+1);

    // 6. Real Effective Exchange Rate Gap
    z_lso = rho_z * z_lso(-1) + (s_lso - s_lso(-1)) - (pi_lso - pi_zaf) / 4;

    // 7. Reserves Gap Dynamics (V3 - BOP-based specification)
    // Removed: - f_2 * z_lso(-1)  [problematic REER channel]
    // Added: - f_3 * y_lso(-1)    [domestic demand → imports → reserve drain]
    // Added: + f_4 * y_zaf(-1)    [SA demand → SACU/exports → reserve inflow]
    res_gap_lso = delta_res * res_gap_lso(-1)
                - f_1 * g_lso(-1)
                - f_3 * y_lso(-1)
                + f_4 * y_zaf(-1)
                + eps_res_lso;

    // 8. Desired Reserves (AR process to steady state)
    res_bar_lso = (1 - rho_res_bar) * res_ss + rho_res_bar * res_bar_lso(-1);

    // 9. Actual Reserves (identity)
    res_lso = res_gap_lso + res_bar_lso;

    // 10. Currency Risk Premium
    prem_lso = theta_prem * (res_bar_lso - res_lso) + eps_prem_lso;

    // 11. Government Spending Shock (AR process)
    g_lso = rho_g * g_lso(-1) + eps_g_lso;

    // =====================================================================
    // SOUTH AFRICA MODULE
    // =====================================================================

    // 12. IS Curve with Commodity Terms of Trade (SARB WP1701 Eq. 1)
    y_zaf = gamma_1 * y_zaf(-1)
          + gamma_2 * y_zaf(+1)
          - gamma_3 * r_zaf
          + gamma_4 * z_zaf
          + gamma_5 * y_row
          + gamma_6 * d_rcom        // Commodity price GAP (not level)
          + eps_y_zaf;

    // 13. Phillips Curve (Hybrid)
    pi_zaf = lambda_1 * pi_zaf(-1)
           + (1 - lambda_1) * pi_zaf(+1)
           + lambda_2 * y_zaf
           + lambda_3 * (z_zaf - z_zaf(-1))
           + eps_pi_zaf;

    // 14. Taylor Rule
    i_zaf = phi_i * i_zaf(-1)
          + (1 - phi_i) * (phi_pi * pi_zaf(+1) + phi_y * y_zaf)
          + eps_i_zaf;

    // 15. Fisher Equation
    r_zaf = i_zaf - pi_zaf(+1);

    // 16. UIP (Hybrid Forward-Looking)
    s_zaf = sigma_s * s_zaf(-1)
          + (1 - sigma_s) * s_zaf(+1)
          - (i_zaf - i_row) / 4
          + eps_s_zaf;

    // 17. Real Effective Exchange Rate Gap (South Africa)
    z_zaf = rho_z * z_zaf(-1) + (s_zaf - s_zaf(-1)) - (pi_zaf - pi_row) / 4;

    // =====================================================================
    // REST OF WORLD (US) MODULE
    // =====================================================================

    // 18. US Output Gap
    y_row = rho_y_row * y_row(-1) + eps_y_row;

    // 19. US Inflation
    pi_row = rho_pi_row * pi_row(-1) + eps_pi_row;

    // 20. US Interest Rate
    i_row = rho_i_row * i_row(-1) + (1 - rho_i_row) * (1.5 * pi_row + 0.5 * y_row) + eps_i_row;

    // =====================================================================
    // COMMODITY PRICES MODULE
    // =====================================================================

    // 21. Real Commodity Price (Terms of Trade)
    rcom = rcom_bar + d_rcom;

    // 22. Trend Component (Random Walk)
    rcom_bar = rcom_bar(-1) + eps_rcom_trend;

    // 23. Deviation/Gap Component (AR(1))
    d_rcom = rho_d_rcom * d_rcom(-1) + eps_com;

    // 24. Nominal Commodity Price Inflation (implied identity)
    pi_com = pi_row + (rcom - rcom(-1));

    // 25. Oil Price Inflation
    pi_oil = rho_oil * pi_oil(-1) + eps_oil;

    // 26. Food Price Inflation
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
    res_lso     = res_ss;
    res_bar_lso = res_ss;
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
    rcom        = 0;
    rcom_bar    = 0;
    d_rcom      = 0;
    pi_com      = 0;
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
    var eps_s_lso;      stderr 0.1;
    var eps_res_lso;    stderr 1.0;
    var eps_prem_lso;   stderr 0.5;
    var eps_g_lso;      stderr 1.0;
    var eps_u_lso;      stderr 1.0;

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
    var eps_oil;           stderr 3.0;
    var eps_food;          stderr 2.0;
    var eps_com;           stderr 3.0;
    var eps_rcom_trend;    stderr 2.0;
end;

// -------------------------------------------------------------------------
// SIMULATION
// -------------------------------------------------------------------------

