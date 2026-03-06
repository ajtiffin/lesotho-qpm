% Generate IRF charts for V4 Model Specification Report
% 5 shocks: oil, food, fiscal, global demand, SARB tightening
% Each shock: 4-panel Lesotho IRF (pi_lso, y_lso, z_lso, i_lso)
% Plus: summary comparison chart overlaying key responses

addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');

T = 20;
quarters = 1:T;
figdir = 'figures/';

% Colors
c1 = [0.20 0.40 0.70];  % blue
c2 = [0.80 0.35 0.20];  % rust
c3 = [0.30 0.65 0.30];  % green
c4 = [0.55 0.35 0.65];  % purple
c5 = [0.85 0.60 0.10];  % gold

% =========================================================================
% Load all 5 simulation results
% =========================================================================
shocks = struct();

% 1. Oil price shock (10%)
load('../simul_10pct_oil_v4/Output/simul_10pct_oil_v4_results.mat');
shocks.oil.pi_lso = oo_.irfs.pi_lso_eps_oil * 100;
shocks.oil.y_lso  = oo_.irfs.y_lso_eps_oil * 100;
shocks.oil.z_lso  = oo_.irfs.z_lso_eps_oil * 100;
shocks.oil.i_lso  = oo_.irfs.i_lso_eps_oil * 100;
shocks.oil.r_lso  = oo_.irfs.r_lso_eps_oil * 100;
shocks.oil.pi_zaf = oo_.irfs.pi_zaf_eps_oil * 100;
shocks.oil.y_zaf  = oo_.irfs.y_zaf_eps_oil * 100;
shocks.oil.i_zaf  = oo_.irfs.i_zaf_eps_oil * 100;
shocks.oil.res_gap_lso = oo_.irfs.res_gap_lso_eps_oil * 100;
shocks.oil.prem_lso = oo_.irfs.prem_lso_eps_oil * 100;
shocks.oil.poil_gap = oo_.irfs.poil_gap_eps_oil * 100;
shocks.oil.pfood_gap = oo_.irfs.pfood_gap_eps_oil * 100;
shocks.oil.pi_oil = oo_.irfs.pi_oil_eps_oil * 100;
shocks.oil.pi_food = oo_.irfs.pi_food_eps_oil * 100;

% 2. Food price shock (10%)
load('../simul_v4_food/Output/simul_v4_food_results.mat');
shocks.food.pi_lso = oo_.irfs.pi_lso_eps_food * 100;
shocks.food.y_lso  = oo_.irfs.y_lso_eps_food * 100;
shocks.food.z_lso  = oo_.irfs.z_lso_eps_food * 100;
shocks.food.i_lso  = oo_.irfs.i_lso_eps_food * 100;
shocks.food.r_lso  = oo_.irfs.r_lso_eps_food * 100;
shocks.food.pi_zaf = oo_.irfs.pi_zaf_eps_food * 100;
shocks.food.y_zaf  = oo_.irfs.y_zaf_eps_food * 100;
shocks.food.i_zaf  = oo_.irfs.i_zaf_eps_food * 100;
shocks.food.res_gap_lso = oo_.irfs.res_gap_lso_eps_food * 100;
shocks.food.prem_lso = oo_.irfs.prem_lso_eps_food * 100;
shocks.food.pfood_gap = oo_.irfs.pfood_gap_eps_food * 100;
shocks.food.pi_food = oo_.irfs.pi_food_eps_food * 100;

% 3. Fiscal shock (1% GDP)
load('../simul_v4_fiscal/Output/simul_v4_fiscal_results.mat');
shocks.fiscal.pi_lso = oo_.irfs.pi_lso_eps_g_lso * 100;
shocks.fiscal.y_lso  = oo_.irfs.y_lso_eps_g_lso * 100;
shocks.fiscal.z_lso  = oo_.irfs.z_lso_eps_g_lso * 100;
shocks.fiscal.i_lso  = oo_.irfs.i_lso_eps_g_lso * 100;
shocks.fiscal.r_lso  = oo_.irfs.r_lso_eps_g_lso * 100;
shocks.fiscal.pi_zaf = oo_.irfs.pi_zaf_eps_g_lso * 100;
shocks.fiscal.y_zaf  = oo_.irfs.y_zaf_eps_g_lso * 100;
shocks.fiscal.i_zaf  = oo_.irfs.i_zaf_eps_g_lso * 100;
shocks.fiscal.res_gap_lso = oo_.irfs.res_gap_lso_eps_g_lso * 100;
shocks.fiscal.prem_lso = oo_.irfs.prem_lso_eps_g_lso * 100;
shocks.fiscal.g_lso = oo_.irfs.g_lso_eps_g_lso * 100;

% 4. Global demand shock (1pp US output gap)
load('../simul_v4_global_demand/Output/simul_v4_global_demand_results.mat');
shocks.global.pi_lso = oo_.irfs.pi_lso_eps_y_row * 100;
shocks.global.y_lso  = oo_.irfs.y_lso_eps_y_row * 100;
shocks.global.z_lso  = oo_.irfs.z_lso_eps_y_row * 100;
shocks.global.i_lso  = oo_.irfs.i_lso_eps_y_row * 100;
shocks.global.r_lso  = oo_.irfs.r_lso_eps_y_row * 100;
shocks.global.pi_zaf = oo_.irfs.pi_zaf_eps_y_row * 100;
shocks.global.y_zaf  = oo_.irfs.y_zaf_eps_y_row * 100;
shocks.global.i_zaf  = oo_.irfs.i_zaf_eps_y_row * 100;
shocks.global.y_row  = oo_.irfs.y_row_eps_y_row * 100;
shocks.global.res_gap_lso = oo_.irfs.res_gap_lso_eps_y_row * 100;
shocks.global.prem_lso = oo_.irfs.prem_lso_eps_y_row * 100;

% 5. SARB tightening (25bp)
load('../simul_v4_sarb/Output/simul_v4_sarb_results.mat');
shocks.sarb.pi_lso = oo_.irfs.pi_lso_eps_i_zaf * 100;
shocks.sarb.y_lso  = oo_.irfs.y_lso_eps_i_zaf * 100;
shocks.sarb.z_lso  = oo_.irfs.z_lso_eps_i_zaf * 100;
shocks.sarb.i_lso  = oo_.irfs.i_lso_eps_i_zaf * 100;
shocks.sarb.r_lso  = oo_.irfs.r_lso_eps_i_zaf * 100;
shocks.sarb.pi_zaf = oo_.irfs.pi_zaf_eps_i_zaf * 100;
shocks.sarb.y_zaf  = oo_.irfs.y_zaf_eps_i_zaf * 100;
shocks.sarb.i_zaf  = oo_.irfs.i_zaf_eps_i_zaf * 100;
shocks.sarb.res_gap_lso = oo_.irfs.res_gap_lso_eps_i_zaf * 100;
shocks.sarb.prem_lso = oo_.irfs.prem_lso_eps_i_zaf * 100;

% =========================================================================
% Helper function
% =========================================================================
function plot_irf(quarters, data, color, T, ttl, ylab)
    plot(quarters, data, '-', 'color', color, 'linewidth', 2); hold on;
    plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
    title(ttl, 'fontsize', 10);
    xlabel('Quarters'); ylabel(ylab);
    xlim([1 T]); grid on;
end

% =========================================================================
% FIGURE 1: Oil Price Shock — Lesotho IRFs
% =========================================================================
fig = figure('visible', 'off', 'position', [100 100 700 600]);
subplot(2,2,1);
plot_irf(quarters, shocks.oil.pi_lso, c1, T, 'Inflation (\pi^{LSO})', 'pp');
subplot(2,2,2);
plot_irf(quarters, shocks.oil.y_lso, c2, T, 'Output Gap (\hat{y}^{LSO})', 'pp');
subplot(2,2,3);
plot_irf(quarters, shocks.oil.z_lso, c3, T, 'REER Gap (z^{LSO})', 'pp');
subplot(2,2,4);
plot_irf(quarters, shocks.oil.i_lso, c4, T, 'Nominal Rate (i^{LSO})', 'pp');
% sgtitle not available in Octave — use annotation
annotation('textbox', [0.3 0.95 0.4 0.05], 'String', '10% Oil Price Shock - Lesotho Responses', ...
    'fontsize', 12, 'fontweight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');
print(fig, [figdir 'irf_v4_spec_oil.png'], '-dpng', '-r200');
close(fig);

% =========================================================================
% FIGURE 2: Food Price Shock — Lesotho IRFs
% =========================================================================
fig = figure('visible', 'off', 'position', [100 100 700 600]);
subplot(2,2,1);
plot_irf(quarters, shocks.food.pi_lso, c1, T, 'Inflation (\pi^{LSO})', 'pp');
subplot(2,2,2);
plot_irf(quarters, shocks.food.y_lso, c2, T, 'Output Gap (\hat{y}^{LSO})', 'pp');
subplot(2,2,3);
plot_irf(quarters, shocks.food.z_lso, c3, T, 'REER Gap (z^{LSO})', 'pp');
subplot(2,2,4);
plot_irf(quarters, shocks.food.i_lso, c4, T, 'Nominal Rate (i^{LSO})', 'pp');
annotation('textbox', [0.3 0.95 0.4 0.05], 'String', '10% Food Price Shock - Lesotho Responses', ...
    'fontsize', 12, 'fontweight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');
print(fig, [figdir 'irf_v4_spec_food.png'], '-dpng', '-r200');
close(fig);

% =========================================================================
% FIGURE 3: Fiscal Expansion — Lesotho IRFs
% =========================================================================
fig = figure('visible', 'off', 'position', [100 100 700 600]);
subplot(2,2,1);
plot_irf(quarters, shocks.fiscal.pi_lso, c1, T, 'Inflation (\pi^{LSO})', 'pp');
subplot(2,2,2);
plot_irf(quarters, shocks.fiscal.y_lso, c2, T, 'Output Gap (\hat{y}^{LSO})', 'pp');
subplot(2,2,3);
plot_irf(quarters, shocks.fiscal.z_lso, c3, T, 'REER Gap (z^{LSO})', 'pp');
subplot(2,2,4);
plot_irf(quarters, shocks.fiscal.i_lso, c4, T, 'Nominal Rate (i^{LSO})', 'pp');
annotation('textbox', [0.3 0.95 0.4 0.05], 'String', '1% GDP Fiscal Expansion - Lesotho Responses', ...
    'fontsize', 12, 'fontweight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');
print(fig, [figdir 'irf_v4_spec_fiscal.png'], '-dpng', '-r200');
close(fig);

% =========================================================================
% FIGURE 4: Global Demand Shock — Lesotho IRFs
% =========================================================================
fig = figure('visible', 'off', 'position', [100 100 700 600]);
subplot(2,2,1);
plot_irf(quarters, shocks.global.pi_lso, c1, T, 'Inflation (\pi^{LSO})', 'pp');
subplot(2,2,2);
plot_irf(quarters, shocks.global.y_lso, c2, T, 'Output Gap (\hat{y}^{LSO})', 'pp');
subplot(2,2,3);
plot_irf(quarters, shocks.global.z_lso, c3, T, 'REER Gap (z^{LSO})', 'pp');
subplot(2,2,4);
plot_irf(quarters, shocks.global.i_lso, c4, T, 'Nominal Rate (i^{LSO})', 'pp');
annotation('textbox', [0.3 0.95 0.4 0.05], 'String', '1pp US Output Gap Shock - Lesotho Responses', ...
    'fontsize', 12, 'fontweight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');
print(fig, [figdir 'irf_v4_spec_global.png'], '-dpng', '-r200');
close(fig);

% =========================================================================
% FIGURE 5: SARB Tightening — Lesotho IRFs
% =========================================================================
fig = figure('visible', 'off', 'position', [100 100 700 600]);
subplot(2,2,1);
plot_irf(quarters, shocks.sarb.pi_lso, c1, T, 'Inflation (\pi^{LSO})', 'pp');
subplot(2,2,2);
plot_irf(quarters, shocks.sarb.y_lso, c2, T, 'Output Gap (\hat{y}^{LSO})', 'pp');
subplot(2,2,3);
plot_irf(quarters, shocks.sarb.z_lso, c3, T, 'REER Gap (z^{LSO})', 'pp');
subplot(2,2,4);
plot_irf(quarters, shocks.sarb.i_lso, c4, T, 'Nominal Rate (i^{LSO})', 'pp');
annotation('textbox', [0.3 0.95 0.4 0.05], 'String', '25bp SARB Rate Hike - Lesotho Responses', ...
    'fontsize', 12, 'fontweight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');
print(fig, [figdir 'irf_v4_spec_sarb.png'], '-dpng', '-r200');
close(fig);

% =========================================================================
% FIGURE 6: Summary Comparison — Inflation
% =========================================================================
fig = figure('visible', 'off', 'position', [100 100 700 500]);
subplot(1,2,1);
plot(quarters, shocks.oil.pi_lso, '-', 'color', c1, 'linewidth', 2); hold on;
plot(quarters, shocks.food.pi_lso, '-', 'color', c2, 'linewidth', 2);
plot(quarters, shocks.fiscal.pi_lso, '-', 'color', c3, 'linewidth', 2);
plot(quarters, shocks.global.pi_lso, '-', 'color', c4, 'linewidth', 2);
plot(quarters, shocks.sarb.pi_lso, '-', 'color', c5, 'linewidth', 2);
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho Inflation (\pi^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;
legend('Oil +10%', 'Food +10%', 'Fiscal +1%GDP', 'US demand +1pp', 'SARB +25bp', ...
    'location', 'northeast', 'fontsize', 7);

subplot(1,2,2);
plot(quarters, shocks.oil.y_lso, '-', 'color', c1, 'linewidth', 2); hold on;
plot(quarters, shocks.food.y_lso, '-', 'color', c2, 'linewidth', 2);
plot(quarters, shocks.fiscal.y_lso, '-', 'color', c3, 'linewidth', 2);
plot(quarters, shocks.global.y_lso, '-', 'color', c4, 'linewidth', 2);
plot(quarters, shocks.sarb.y_lso, '-', 'color', c5, 'linewidth', 2);
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho Output Gap (\hat{y}^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

annotation('textbox', [0.25 0.95 0.5 0.05], 'String', 'Comparison: All Shocks - Lesotho Key Variables', ...
    'fontsize', 12, 'fontweight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');
print(fig, [figdir 'irf_v4_spec_comparison.png'], '-dpng', '-r200');
close(fig);

% =========================================================================
% Print IRF tables for the report
% =========================================================================
shock_names = {'oil', 'food', 'fiscal', 'global', 'sarb'};
shock_labels = {'Oil +10%', 'Food +10%', 'Fiscal +1%GDP', 'US Demand +1pp', 'SARB +25bp'};
qs = [1 2 3 4 5 6 8 10 12 16 20];

for s = 1:length(shock_names)
    sn = shock_names{s};
    fprintf('\n=== %s ===\n', shock_labels{s});
    fprintf('Q    pi_lso  y_lso   z_lso   i_lso   r_lso   pi_zaf  y_zaf   res_gap prem\n');
    fprintf('---- ------- ------- ------- ------- ------- ------- ------- ------- -------\n');
    d = shocks.(sn);
    for q = qs
        fprintf('Q%-3d %+7.3f %+7.3f %+7.3f %+7.3f %+7.3f %+7.3f %+7.3f %+7.4f %+7.4f\n', ...
            q, d.pi_lso(q), d.y_lso(q), d.z_lso(q), d.i_lso(q), d.r_lso(q), ...
            d.pi_zaf(q), d.y_zaf(q), d.res_gap_lso(q), d.prem_lso(q));
    end
end

fprintf('\nAll IRF charts saved to %s\n', figdir);
