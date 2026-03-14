% Generate IRF charts for anticipated oil shock
% Perfect foresight simulation: shock hits at Q1, sustained Q1-Q4, agents know full path
% Charts show Q0 (steady state) through Q20 for clean visual presentation

addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');

% Load perfect foresight results
load('../simul_oil_q2_anticipated/Output/simul_oil_q2_anticipated_results.mat');

% Variable indices (from oo_.endo_names):
% 1:y_lso  2:pi_lso  3:i_lso  4:r_lso  5:z_lso  6:s_lso  7:res_gap_lso
% 8:res_lso  9:res_bar_lso  10:prem_lso  11:g_lso
% 12:y_zaf  13:pi_zaf  14:i_zaf  15:r_zaf  16:z_zaf  17:s_zaf
% 18:y_row  19:pi_row  20:i_row
% 21:pi_oil  22:pi_food  23:poil_gap  24:pfood_gap
% 25:rcom  26:rcom_bar  27:d_rcom  28:pi_com

% oo_.endo_simul has dimensions: n_vars x (ss + n_periods)
% ss = 1 (steady state), then periods 1-40
ss = 1;
T = 20;
quarters = 1:T;

% Extract IRFs (deviations from steady state, in pp)
% Perfect foresight: period ss+1 is the first simulation period (Q1)
y_lso = oo_.endo_simul(1, ss+1:ss+T)' * 100;
pi_lso = oo_.endo_simul(2, ss+1:ss+T)' * 100;
i_lso = oo_.endo_simul(3, ss+1:ss+T)' * 100;
r_lso = oo_.endo_simul(4, ss+1:ss+T)' * 100;
z_lso = oo_.endo_simul(5, ss+1:ss+T)' * 100;
s_lso = oo_.endo_simul(6, ss+1:ss+T)' * 100;
res_gap_lso = oo_.endo_simul(7, ss+1:ss+T)' * 100;
res_lso = oo_.endo_simul(8, ss+1:ss+T)' * 100;
res_bar_lso = oo_.endo_simul(9, ss+1:ss+T)' * 100;
prem_lso = oo_.endo_simul(10, ss+1:ss+T)' * 100;
g_lso = oo_.endo_simul(11, ss+1:ss+T)' * 100;

y_zaf = oo_.endo_simul(12, ss+1:ss+T)' * 100;
pi_zaf = oo_.endo_simul(13, ss+1:ss+T)' * 100;
i_zaf = oo_.endo_simul(14, ss+1:ss+T)' * 100;
r_zaf = oo_.endo_simul(15, ss+1:ss+T)' * 100;
z_zaf = oo_.endo_simul(16, ss+1:ss+T)' * 100;
s_zaf = oo_.endo_simul(17, ss+1:ss+T)' * 100;

y_row = oo_.endo_simul(18, ss+1:ss+T)' * 100;
pi_row = oo_.endo_simul(19, ss+1:ss+T)' * 100;
i_row = oo_.endo_simul(20, ss+1:ss+T)' * 100;

pi_oil = oo_.endo_simul(21, ss+1:ss+T)' * 100;
pi_food = oo_.endo_simul(22, ss+1:ss+T)' * 100;
poil_gap = oo_.endo_simul(23, ss+1:ss+T)' * 100;
pfood_gap = oo_.endo_simul(24, ss+1:ss+T)' * 100;

rcom = oo_.endo_simul(25, ss+1:ss+T)' * 100;
rcom_bar = oo_.endo_simul(26, ss+1:ss+T)' * 100;
d_rcom = oo_.endo_simul(27, ss+1:ss+T)' * 100;
pi_com = oo_.endo_simul(28, ss+1:ss+T)' * 100;

% Prepend Q0 = steady state (zero) for clean chart presentation
% Charts will show Q0 at origin, then Q1-Q20 with shock
res_ss = 4.70;  % Steady state reserves level
y_lso = [0; y_lso]; pi_lso = [0; pi_lso]; i_lso = [0; i_lso]; r_lso = [0; r_lso];
z_lso = [0; z_lso]; s_lso = [0; s_lso];
res_gap_lso = [0; res_gap_lso]; res_lso = [res_ss; res_lso]; prem_lso = [0; prem_lso]; g_lso = [0; g_lso];
y_zaf = [0; y_zaf]; pi_zaf = [0; pi_zaf]; i_zaf = [0; i_zaf]; r_zaf = [0; r_zaf];
z_zaf = [0; z_zaf]; s_zaf = [0; s_zaf];
y_row = [0; y_row]; pi_row = [0; pi_row]; i_row = [0; i_row];
pi_oil = [0; pi_oil]; pi_food = [0; pi_food]; poil_gap = [0; poil_gap]; pfood_gap = [0; pfood_gap];
rcom = [0; rcom]; d_rcom = [0; d_rcom]; pi_com = [0; pi_com];

% Update time dimension: now Q0-Q20 (21 periods)
quarters = 0:T;

% Short names
res_gap = res_gap_lso;
prem = prem_lso;

% Colors
c1 = [0.20 0.40 0.70];  % blue
c2 = [0.80 0.35 0.20];  % rust
c3 = [0.30 0.65 0.30];  % green
c4 = [0.55 0.35 0.65];  % purple
c_grey = [0.45 0.45 0.45];

figdir = 'figures/';

% =========================================================================
% FIGURE 1: Shock paths (oil and food price levels and inflation)
% =========================================================================
fig1 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot(quarters, poil_gap, '-', 'color', c1, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Oil Price Level Gap (p^{oil})', 'fontsize', 11);
xlabel('Quarters'); ylabel('% deviation');
xlim([1 T]); grid on;

subplot(2,2,2);
plot(quarters, pfood_gap, '-', 'color', c2, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Food Price Level Gap (p^{food})', 'fontsize', 11);
xlabel('Quarters'); ylabel('% deviation');
xlim([1 T]); grid on;

subplot(2,2,3);
plot(quarters, pi_oil, '-', 'color', c1, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Oil Price Inflation (\pi^{oil})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

subplot(2,2,4);
plot(quarters, pi_food, '-', 'color', c2, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Food Price Inflation (\pi^{food})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

print(fig1, [figdir 'irf_oil_q2_anticipated_prices.png'], '-dpng', '-r200');
close(fig1);

% =========================================================================
% FIGURE 2: South Africa transmission
% =========================================================================
fig2 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot(quarters, pi_zaf, '-', 'color', c1, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('SA Inflation (\pi^{ZAF})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

subplot(2,2,2);
plot(quarters, i_zaf, '-', 'color', c2, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('SA Policy Rate (i^{ZAF})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

subplot(2,2,3);
plot(quarters, y_zaf, '-', 'color', c3, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('SA Output Gap (y^{ZAF})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

subplot(2,2,4);
plot(quarters, r_zaf, '-', 'color', c4, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('SA Real Interest Rate (r^{ZAF})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

print(fig2, [figdir 'irf_oil_q2_anticipated_sa.png'], '-dpng', '-r200');
close(fig2);

% =========================================================================
% FIGURE 3: Lesotho key variables
% =========================================================================
fig3 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot(quarters, pi_lso, '-', 'color', c1, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho Inflation (\pi^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

subplot(2,2,2);
plot(quarters, y_lso, '-', 'color', c2, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho Output Gap (y^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

subplot(2,2,3);
plot(quarters, z_lso, '-', 'color', c3, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho REER Gap (z^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

subplot(2,2,4);
plot(quarters, i_lso, '-', 'color', c4, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Lesotho Nominal Rate (i^{LSO})', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

print(fig3, [figdir 'irf_oil_q2_anticipated_lesotho.png'], '-dpng', '-r200');
close(fig3);

% =========================================================================
% FIGURE 4: Reserves and Risk Premium
% =========================================================================
fig4 = figure('visible', 'off', 'position', [100 100 700 300]);

subplot(1,2,1);
plot(quarters, res_gap, '-', 'color', c1, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Reserves Gap', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

subplot(1,2,2);
plot(quarters, prem, '-', 'color', c2, 'linewidth', 2); hold on;
plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
title('Risk Premium', 'fontsize', 11);
xlabel('Quarters'); ylabel('pp deviation');
xlim([1 T]); grid on;

print(fig4, [figdir 'irf_oil_q2_anticipated_reserves.png'], '-dpng', '-r200');
close(fig4);

% =========================================================================
% FIGURE 5: Lesotho Inflation Decomposition
% =========================================================================
fig5 = figure('visible', 'off', 'position', [100 100 600 400]);

pi_zaf_contrib = pi_zaf;
oil_diff_contrib = (0.08 - 0.05) * pi_oil;
food_diff_contrib = (0.35 - 0.20) * pi_food;
output_contrib = 0.25 * y_lso;

area_data = [pi_zaf_contrib, oil_diff_contrib, food_diff_contrib, output_contrib];
bh = bar(quarters, area_data, 'stacked');
set(bh(1), 'FaceColor', c1);     % SA inflation
set(bh(2), 'FaceColor', c2);     % Oil differential
set(bh(3), 'FaceColor', c3);     % Food differential
set(bh(4), 'FaceColor', c_grey); % Output gap
hold on;
plot(quarters, pi_lso, 'k-', 'linewidth', 2);
title('Lesotho Inflation Decomposition', 'fontsize', 12);
xlabel('Quarters'); ylabel('pp deviation');
legend('\pi^{ZAF} pass-through', 'Oil CPI differential', 'Food CPI differential', ...
    'Output gap', '\pi^{LSO} (total)', 'location', 'northeast');
xlim([0.5 T+0.5]); grid on;

print(fig5, [figdir 'irf_oil_q2_anticipated_decomposition.png'], '-dpng', '-r200');
close(fig5);

% =========================================================================
% Print key IRF values
% =========================================================================
fprintf('\n=== Oil Shock - ANTICIPATED (Perfect Foresight) ===\n');
fprintf('Shock: 10%% at Q1, sustained Q1-Q4, then natural decay\n');
fprintf('Agents know full path at Q1; charts show Q0 (steady state) through Q20\n\nn');

fprintf('--- Oil/Food ---\n');
qs = [0 1 2 3 4 5 7 11 15];
for idx = 2:length(qs)  % Skip Q0 in output
  q = qs(idx);
  fprintf('Q%d: poil_gap=%+.2f pi_oil=%+.2f pfood_gap=%+.3f pi_food=%+.3f\n', ...
      q, poil_gap(q+1), pi_oil(q+1), pfood_gap(q+1), pi_food(q+1));
end

fprintf('\n--- South Africa ---\n');
for idx = 2:length(qs)
  q = qs(idx);
  fprintf('Q%d: pi_zaf=%+.3f y_zaf=%+.3f i_zaf=%+.3f r_zaf=%+.3f\n', ...
      q, pi_zaf(q+1), y_zaf(q+1), i_zaf(q+1), r_zaf(q+1));
end

fprintf('\n--- Lesotho ---\n');
for idx = 2:length(qs)
  q = qs(idx);
  fprintf('Q%d: pi_lso=%+.3f y_lso=%+.3f i_lso=%+.3f r_lso=%+.3f z_lso=%+.3f res=%+.4f prem=%+.4f\n', ...
      q, pi_lso(q+1), y_lso(q+1), i_lso(q+1), r_lso(q+1), z_lso(q+1), res_gap(q+1), prem(q+1));
end

fprintf('\n--- Peak Responses (Q1-Q20) ---\n');
fprintf('Variable        |  Peak (pp)  |  Quarter\n');
fprintf('----------------|-------------|--------\n');
vnames = {'poil_gap', 'pi_oil', 'pfood_gap', 'pi_food', 'pi_zaf', 'i_zaf', 'y_zaf', 'r_zaf', ...
          'pi_lso', 'y_lso', 'i_lso', 'r_lso', 'z_lso', 'res_gap', 'prem'};
vdata = {poil_gap, pi_oil, pfood_gap, pi_food, pi_zaf, i_zaf, y_zaf, r_zaf, ...
         pi_lso, y_lso, i_lso, r_lso, z_lso, res_gap, prem};
for v = 1:length(vnames)
    % Exclude Q0 (index 1) when finding peaks
    [~, pk] = max(abs(vdata{v}(2:end)));
    pk = pk + 1;  % Adjust for Q0 offset
    fprintf('%-15s |  %+.3f     |  Q%d\n', vnames{v}, vdata{v}(pk), pk-1);
end

fprintf('\nIRF charts saved to %s\n', figdir);
