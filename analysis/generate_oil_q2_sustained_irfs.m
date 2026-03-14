% Generate IRF charts: 10% oil shock, sustained 4Q, starting Q2 (unanticipated)
% Superposition of shifted base IRFs; Q2 start handled by shifting periods to [2,3,4,5]
addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');

% Load stoch_simul results
load('../simul_oil_q2_sustained/Output/simul_oil_q2_sustained_results.mat');

T = 20;
quarters = 1:T;

% Base IRF (response to eps_oil = 0.10)
base_irf = @(varname) oo_.irfs.([varname '_eps_oil']);

% Sustained 10% oil for Q2-Q5 with rho_oil=0.80:
%   eps = {0, 0.10, 0.02, 0.02, 0.02}
% Weights relative to base (eps=0.10): {1.0, 0.2, 0.2, 0.2}
% Shifted to start at Q2: periods = [2, 3, 4, 5]
shock_weights = [1.0, 0.2, 0.2, 0.2];
shock_periods = [2, 3, 4, 5];

% Superimpose shifted IRFs
function result = superimpose(base, weights, periods, T)
    result = zeros(1, T);
    for k = 1:length(weights)
        shift = periods(k) - 1;
        for t = 1:T
            src = t - shift;
            if src >= 1 && src <= length(base)
                result(t) = result(t) + weights(k) * base(src);
            end
        end
    end
end

% Build superimposed IRFs (scale to pp)
vars_to_plot = {'poil_gap', 'pfood_gap', 'pi_oil', 'pi_food', ...
                'pi_zaf', 'i_zaf', 'y_zaf', 'r_zaf', 'z_zaf', ...
                'pi_lso', 'y_lso', 'z_lso', 'i_lso', 'r_lso', ...
                'res_gap_lso', 'prem_lso'};

for v = 1:length(vars_to_plot)
    b = base_irf(vars_to_plot{v});
    s = superimpose(b, shock_weights, shock_periods, T) * 100;
    eval([vars_to_plot{v} ' = s;']);
end

res_gap = res_gap_lso;
prem    = prem_lso;

% Colors
c1     = [0.20 0.40 0.70];  % blue
c2     = [0.80 0.35 0.20];  % rust
c3     = [0.30 0.65 0.30];  % green
c4     = [0.55 0.35 0.65];  % purple
c_grey = [0.45 0.45 0.45];

figdir = 'figures/';

% =========================================================================
% FIGURE 1: Shock — oil and food price paths
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

print(fig1, [figdir 'irf_oil_q2_prices.png'], '-dpng', '-r200');
close(fig1);

% =========================================================================
% FIGURE 2: South Africa transmission (primary focus)
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

print(fig2, [figdir 'irf_oil_q2_sa.png'], '-dpng', '-r200');
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

print(fig3, [figdir 'irf_oil_q2_lesotho.png'], '-dpng', '-r200');
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

print(fig4, [figdir 'irf_oil_q2_reserves.png'], '-dpng', '-r200');
close(fig4);

% =========================================================================
% FIGURE 5: Lesotho Inflation Decomposition
% =========================================================================
fig5 = figure('visible', 'off', 'position', [100 100 600 400]);

pi_zaf_contrib  = pi_zaf;
oil_diff_contrib  = (0.08 - 0.05) * pi_oil;
food_diff_contrib = (0.35 - 0.20) * pi_food;
output_contrib    = 0.25 * y_lso;

area_data = [pi_zaf_contrib; oil_diff_contrib; food_diff_contrib; output_contrib]';
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
xlim([0.5 T+0.5]); grid on;

print(fig5, [figdir 'irf_oil_q2_decomposition.png'], '-dpng', '-r200');
close(fig5);

% =========================================================================
% Print key IRF values to console
% =========================================================================
fprintf('\n=== Oil Shock: 10%% sustained Q2-Q5, unanticipated (V4 recalibrated) ===\n');
fprintf('eps_oil: Q1=0, Q2=0.10, Q3=0.02, Q4=0.02, Q5=0.02 (rho_oil=0.80)\n\n');

qs = [1 2 3 4 5 6 8 12 16];

fprintf('--- Commodity Prices ---\n');
fprintf('%-4s  %-8s %-8s %-10s %-10s\n', 'Qtr', 'poil_gap', 'pi_oil', 'pfood_gap', 'pi_food');
for q = qs
  fprintf('Q%-3d  %+8.3f %+8.3f %+10.3f %+10.3f\n', q, poil_gap(q), pi_oil(q), pfood_gap(q), pi_food(q));
end

fprintf('\n--- South Africa ---\n');
fprintf('%-4s  %-8s %-8s %-8s %-8s %-8s\n', 'Qtr', 'pi_zaf', 'y_zaf', 'i_zaf', 'r_zaf', 'z_zaf');
for q = qs
  fprintf('Q%-3d  %+8.3f %+8.3f %+8.3f %+8.3f %+8.3f\n', q, pi_zaf(q), y_zaf(q), i_zaf(q), r_zaf(q), z_zaf(q));
end

fprintf('\n--- Lesotho ---\n');
fprintf('%-4s  %-8s %-8s %-8s %-8s %-8s %-8s\n', 'Qtr', 'pi_lso', 'y_lso', 'i_lso', 'r_lso', 'z_lso', 'res_gap');
for q = qs
  fprintf('Q%-3d  %+8.3f %+8.3f %+8.3f %+8.3f %+8.3f %+8.4f\n', q, pi_lso(q), y_lso(q), i_lso(q), r_lso(q), z_lso(q), res_gap(q));
end

fprintf('\n--- Peak Responses ---\n');
fprintf('%-16s | %8s | %s\n', 'Variable', 'Peak (pp)', 'Quarter');
fprintf('%-16s | %8s | %s\n', repmat('-',1,16), repmat('-',1,8), repmat('-',1,7));
vnames = {'poil_gap','pi_oil','pfood_gap','pi_food','pi_zaf','i_zaf','y_zaf','r_zaf','z_zaf','pi_lso','y_lso','z_lso','res_gap','prem'};
vdata  = {poil_gap, pi_oil, pfood_gap, pi_food, pi_zaf, i_zaf, y_zaf, r_zaf, z_zaf, pi_lso, y_lso, z_lso, res_gap, prem};
for v = 1:length(vnames)
    [~, pk] = max(abs(vdata{v}));
    fprintf('%-16s | %+8.3f  | Q%d\n', vnames{v}, vdata{v}(pk), pk);
end

fprintf('\nCharts saved to %s\n', figdir);
