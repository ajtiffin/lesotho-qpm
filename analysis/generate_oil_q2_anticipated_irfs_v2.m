% Generate IRF charts for anticipated oil shock — independent replication
% Perfect foresight: 10% oil at Q1, sustained Q1-Q4, agents know full path
% Charts show Q0 (steady state) at origin through Q20

addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
load('../simul_oil_q2_anticipated/Output/simul_oil_q2_anticipated_results.mat');

ss = 1; T = 20;
quarters = 0:T;

% Extract all variables (index from M_.endo_names order)
idx = struct('y_lso',1,'pi_lso',2,'i_lso',3,'r_lso',4,'z_lso',5,'s_lso',6, ...
    'res_gap_lso',7,'res_lso',8,'res_bar_lso',9,'prem_lso',10,'g_lso',11, ...
    'y_zaf',12,'pi_zaf',13,'i_zaf',14,'r_zaf',15,'z_zaf',16,'s_zaf',17, ...
    'y_row',18,'pi_row',19,'i_row',20, ...
    'pi_oil',21,'pi_food',22,'poil_gap',23,'pfood_gap',24, ...
    'rcom',25,'rcom_bar',26,'d_rcom',27,'pi_com',28);

% Helper: extract with Q0=0 prepended, in pp
ex = @(i) [0; oo_.endo_simul(i, ss+1:ss+T)' * 100];

y_lso = ex(idx.y_lso); pi_lso = ex(idx.pi_lso); i_lso = ex(idx.i_lso);
r_lso = ex(idx.r_lso); z_lso = ex(idx.z_lso);
res_gap = ex(idx.res_gap_lso); prem = ex(idx.prem_lso);

y_zaf = ex(idx.y_zaf); pi_zaf = ex(idx.pi_zaf); i_zaf = ex(idx.i_zaf);
r_zaf = ex(idx.r_zaf); z_zaf = ex(idx.z_zaf);

pi_oil = ex(idx.pi_oil); pi_food = ex(idx.pi_food);
poil_gap = ex(idx.poil_gap); pfood_gap = ex(idx.pfood_gap);

% Colors
c1 = [0.20 0.40 0.70]; c2 = [0.80 0.35 0.20]; c3 = [0.30 0.65 0.30];
c4 = [0.55 0.35 0.65]; c_grey = [0.45 0.45 0.45];

figdir = 'figures/';

% =========================================================================
% FIGURE 1: Shock paths
% =========================================================================
fig1 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot(quarters, poil_gap, '-', 'color', c1, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Oil Price Level Gap (p^{oil})', 'fontsize', 11);
xlabel('Quarters'); ylabel('% deviation'); xlim([0 T]); grid on;

subplot(2,2,2);
plot(quarters, pfood_gap, '-', 'color', c2, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Food Price Level Gap (p^{food})', 'fontsize', 11);
xlabel('Quarters'); ylabel('% deviation'); xlim([0 T]); grid on;

subplot(2,2,3);
plot(quarters, pi_oil, '-', 'color', c1, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Oil Price Inflation (\pi^{oil})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

subplot(2,2,4);
plot(quarters, pi_food, '-', 'color', c2, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Food Price Inflation (\pi^{food})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

print(fig1, [figdir 'irf_oil_q2_anticipated_prices_v2.png'], '-dpng', '-r200');
close(fig1);

% =========================================================================
% FIGURE 2: South Africa
% =========================================================================
fig2 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot(quarters, pi_zaf, '-', 'color', c1, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('SA Inflation (\pi^{ZAF})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

subplot(2,2,2);
plot(quarters, i_zaf, '-', 'color', c2, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('SA Policy Rate (i^{ZAF})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

subplot(2,2,3);
plot(quarters, y_zaf, '-', 'color', c3, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('SA Output Gap (y^{ZAF})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

subplot(2,2,4);
plot(quarters, r_zaf, '-', 'color', c4, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('SA Real Interest Rate (r^{ZAF})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

print(fig2, [figdir 'irf_oil_q2_anticipated_sa_v2.png'], '-dpng', '-r200');
close(fig2);

% =========================================================================
% FIGURE 3: Lesotho
% =========================================================================
fig3 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot(quarters, pi_lso, '-', 'color', c1, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho Inflation (\pi^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

subplot(2,2,2);
plot(quarters, y_lso, '-', 'color', c2, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho Output Gap (y^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

subplot(2,2,3);
plot(quarters, z_lso, '-', 'color', c3, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho REER Gap (z^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

subplot(2,2,4);
plot(quarters, r_lso, '-', 'color', c4, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho Real Rate (r^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

print(fig3, [figdir 'irf_oil_q2_anticipated_lesotho_v2.png'], '-dpng', '-r200');
close(fig3);

% =========================================================================
% FIGURE 4: Reserves
% =========================================================================
fig4 = figure('visible', 'off', 'position', [100 100 700 300]);

subplot(1,2,1);
plot(quarters, res_gap, '-', 'color', c1, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Reserves Gap', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

subplot(1,2,2);
plot(quarters, prem, '-', 'color', c2, 'linewidth', 2); hold on;
plot([0 T], [0 0], 'k-', 'linewidth', 0.5);
title('Risk Premium', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation'); xlim([0 T]); grid on;

print(fig4, [figdir 'irf_oil_q2_anticipated_reserves_v2.png'], '-dpng', '-r200');
close(fig4);

% =========================================================================
% FIGURE 5: Decomposition
% =========================================================================
fig5 = figure('visible', 'off', 'position', [100 100 600 400]);

pi_zaf_contrib = pi_zaf;
oil_diff_contrib = (0.08 - 0.05) * pi_oil;
food_diff_contrib = (0.35 - 0.20) * pi_food;
output_contrib = 0.25 * y_lso;

area_data = [pi_zaf_contrib, oil_diff_contrib, food_diff_contrib, output_contrib];
bh = bar(quarters, area_data, 'stacked');
set(bh(1), 'FaceColor', c1);
set(bh(2), 'FaceColor', c2);
set(bh(3), 'FaceColor', c3);
set(bh(4), 'FaceColor', c_grey);
hold on;
plot(quarters, pi_lso, 'k-', 'linewidth', 2);
title('Lesotho Inflation Decomposition', 'fontsize', 12);
xlabel('Quarters'); ylabel('pp deviation');
legend('\pi^{ZAF} pass-through', 'Oil CPI differential', 'Food CPI differential', ...
    'Output gap', '\pi^{LSO} (total)', 'location', 'northeast');
xlim([-0.5 T+0.5]); grid on;

print(fig5, [figdir 'irf_oil_q2_anticipated_decomposition_v2.png'], '-dpng', '-r200');
close(fig5);

fprintf('All charts saved to %s\n', figdir);
