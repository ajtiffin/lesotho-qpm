// Simulation: 1pp Global Demand Shock
// Based on lesotho_model_v3.mod

@#include "lesotho_model_v3.mod"

// Override shocks for 1pp global demand shock
// Standard deviation is 0.5, so 1pp = 2 * stderr
shocks;
    var eps_y_row; periods 1; values 2.0;
end;

// Deterministic simulation for 20 periods
simul(periods=20);

// Save results
y_row_global = y_row;
y_zaf_global = y_zaf;
y_lso_global = y_lso;
res_lso_global = res_lso;
prem_lso_global = prem_lso;
pi_lso_global = pi_lso;
i_lso_global = i_lso;
s_zaf_global = s_zaf;
s_lso_global = s_lso;

