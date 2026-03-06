% Generate IRF charts for delayed oil shock — comparing unanticipated vs anticipated
% Sustained 4-quarter shock starting Q3 (Q3-Q6): poil_gap = +10%
addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');

T = 24;
quarters = 1:T;

% =========================================================================
% UNANTICIPATED: superposition of shifted base IRFs
% =========================================================================
load('../simul_delayed_oil/Output/simul_delayed_oil_results.mat');

base_irf = @(varname) oo_.irfs.([varname '_eps_oil']);

% Delayed sustained shock: Q3-Q6
% eps_oil = {0.10, 0.02, 0.02, 0.02} starting at Q3 (rho_oil=0.80)
shock_weights = [1.0, 0.2, 0.2, 0.2];
shock_periods = [3, 4, 5, 6];  % delayed by 2 quarters

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

vars_to_plot = {'poil_gap', 'pfood_gap', 'pi_oil', 'pi_food', ...
                'pi_zaf', 'i_zaf', 'y_zaf', 'r_zaf', ...
                'pi_lso', 'y_lso', 'z_lso', 'i_lso', 'r_lso', ...
                'res_gap_lso', 'prem_lso'};

% Build unanticipated IRFs (scale to pp)
for v = 1:length(vars_to_plot)
    b = base_irf(vars_to_plot{v});
    s = superimpose(b, shock_weights, shock_periods, T) * 100;
    eval(['u_' vars_to_plot{v} ' = s;']);
end

% =========================================================================
% ANTICIPATED: read from oo_.endo_simul (perfect foresight)
% =========================================================================
load('../simul_delayed_oil_anticipated/Output/simul_delayed_oil_anticipated_results.mat');

% Variable indices in oo_.endo_simul
idx.y_lso=1; idx.pi_lso=2; idx.i_lso=3; idx.r_lso=4; idx.z_lso=5; idx.s_lso=6;
idx.res_gap_lso=7; idx.res_lso=8; idx.res_bar_lso=9; idx.prem_lso=10; idx.g_lso=11;
idx.y_zaf=12; idx.pi_zaf=13; idx.i_zaf=14; idx.r_zaf=15; idx.z_zaf=16; idx.s_zaf=17;
idx.y_row=18; idx.pi_row=19; idx.i_row=20;
idx.pi_oil=21; idx.pi_food=22; idx.poil_gap=23; idx.pfood_gap=24;
idx.rcom=25; idx.rcom_bar=26; idx.d_rcom=27; idx.pi_com=28;

ss = 1;  % steady state is period 1
for v = 1:length(vars_to_plot)
    vn = vars_to_plot{v};
    vi = idx.(vn);
    data = oo_.endo_simul(vi, ss+1:ss+T) * 100;
    eval(['a_' vn ' = data;']);
end

% =========================================================================
% Colors and styles
% =========================================================================
c1 = [0.20 0.40 0.70];  % blue
c2 = [0.80 0.35 0.20];  % rust
c3 = [0.30 0.65 0.30];  % green
c4 = [0.55 0.35 0.65];  % purple
c_grey = [0.45 0.45 0.45];

figdir = 'figures/';

% Helper: plot both regimes on one subplot
function plot_both(quarters, u_data, a_data, color, T, ttl, ylab)
    plot(quarters, u_data, '-', 'color', color, 'linewidth', 2); hold on;
    plot(quarters, a_data, '--', 'color', color, 'linewidth', 2);
    plot([1 T], [0 0], 'k-', 'linewidth', 0.5);
    title(ttl, 'fontsize', 10);
    xlabel('Quarters'); ylabel(ylab);
    xlim([1 T]); grid on;
end

% =========================================================================
% FIGURE 1: Oil and food price paths
% =========================================================================
fig1 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot_both(quarters, u_poil_gap, a_poil_gap, c1, T, 'Oil Price Level Gap (p^{oil})', '% deviation');

subplot(2,2,2);
plot_both(quarters, u_pfood_gap, a_pfood_gap, c2, T, 'Food Price Level Gap (p^{food})', '% deviation');

subplot(2,2,3);
plot_both(quarters, u_pi_oil, a_pi_oil, c1, T, 'Oil Price Inflation (\pi^{oil})', 'pp deviation');

subplot(2,2,4);
plot_both(quarters, u_pi_food, a_pi_food, c2, T, 'Food Price Inflation (\pi^{food})', 'pp deviation');
legend('Unanticipated', 'Anticipated', 'location', 'northeast');

print(fig1, [figdir 'irf_delayed_oil_prices.png'], '-dpng', '-r200');
close(fig1);

% =========================================================================
% FIGURE 2: South Africa
% =========================================================================
fig2 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot_both(quarters, u_pi_zaf, a_pi_zaf, c1, T, 'SA Inflation (\pi^{ZAF})', 'pp deviation');

subplot(2,2,2);
plot_both(quarters, u_i_zaf, a_i_zaf, c2, T, 'SA Policy Rate (i^{ZAF})', 'pp deviation');

subplot(2,2,3);
plot_both(quarters, u_y_zaf, a_y_zaf, c3, T, 'SA Output Gap (y^{ZAF})', 'pp deviation');

subplot(2,2,4);
plot_both(quarters, u_r_zaf, a_r_zaf, c4, T, 'SA Real Interest Rate (r^{ZAF})', 'pp deviation');
legend('Unanticipated', 'Anticipated', 'location', 'northeast');

print(fig2, [figdir 'irf_delayed_oil_sa.png'], '-dpng', '-r200');
close(fig2);

% =========================================================================
% FIGURE 3: Lesotho key variables
% =========================================================================
fig3 = figure('visible', 'off', 'position', [100 100 700 600]);

subplot(2,2,1);
plot_both(quarters, u_pi_lso, a_pi_lso, c1, T, 'Lesotho Inflation (\pi^{LSO})', 'pp deviation');

subplot(2,2,2);
plot_both(quarters, u_y_lso, a_y_lso, c2, T, 'Lesotho Output Gap (y^{LSO})', 'pp deviation');

subplot(2,2,3);
plot_both(quarters, u_z_lso, a_z_lso, c3, T, 'Lesotho REER Gap (z^{LSO})', 'pp deviation');

subplot(2,2,4);
plot_both(quarters, u_i_lso, a_i_lso, c4, T, 'Lesotho Nominal Rate (i^{LSO})', 'pp deviation');
legend('Unanticipated', 'Anticipated', 'location', 'northeast');

print(fig3, [figdir 'irf_delayed_oil_lesotho.png'], '-dpng', '-r200');
close(fig3);

% =========================================================================
% FIGURE 4: Reserves and Risk Premium
% =========================================================================
fig4 = figure('visible', 'off', 'position', [100 100 700 300]);

subplot(1,2,1);
plot_both(quarters, u_res_gap_lso, a_res_gap_lso, c1, T, 'Reserves Gap', 'pp deviation');
legend('Unanticipated', 'Anticipated', 'location', 'southeast');

subplot(1,2,2);
plot_both(quarters, u_prem_lso, a_prem_lso, c2, T, 'Risk Premium', 'pp deviation');

print(fig4, [figdir 'irf_delayed_oil_reserves.png'], '-dpng', '-r200');
close(fig4);

% =========================================================================
% FIGURE 5: Lesotho Inflation Decomposition (unanticipated only)
% =========================================================================
fig5 = figure('visible', 'off', 'position', [100 100 600 400]);

pi_zaf_contrib = u_pi_zaf;
oil_diff_contrib = (0.08 - 0.05) * u_pi_oil;
food_diff_contrib = (0.35 - 0.20) * u_pi_food;
output_contrib = 0.25 * u_y_lso;

area_data = [pi_zaf_contrib; oil_diff_contrib; food_diff_contrib; output_contrib]';
bh = bar(quarters, area_data, 'stacked');
set(bh(1), 'FaceColor', c1);
set(bh(2), 'FaceColor', c2);
set(bh(3), 'FaceColor', c3);
set(bh(4), 'FaceColor', c_grey);
hold on;
plot(quarters, u_pi_lso, 'k-', 'linewidth', 2);
title('Lesotho Inflation Decomposition (Unanticipated)', 'fontsize', 12);
xlabel('Quarters'); ylabel('pp deviation');
legend('\pi^{ZAF} pass-through', 'Oil CPI differential', 'Food CPI differential', ...
    'Output gap', '\pi^{LSO} (total)', 'location', 'northeast');
xlim([0.5 T+0.5]); grid on;

print(fig5, [figdir 'irf_delayed_oil_decomposition.png'], '-dpng', '-r200');
close(fig5);

% =========================================================================
% Print key IRF values
% =========================================================================
fprintf('\n=== Delayed Sustained Oil Shock (Q3-Q6, +10%%) ===\n\n');

qs = [1 2 3 4 5 6 7 8 10 12 16 20];

fprintf('--- UNANTICIPATED ---\n');
fprintf('Q    poil    pi_oil  pi_zaf  y_zaf   pi_lso  y_lso   r_lso   z_lso   res_gap prem\n');
fprintf('---- ------- ------- ------- ------- ------- ------- ------- ------- ------- -------\n');
for q = qs
    fprintf('Q%-3d %+6.2f  %+6.2f  %+6.3f  %+6.3f  %+6.3f  %+6.3f  %+6.3f  %+6.3f  %+6.4f  %+6.4f\n', ...
        q, u_poil_gap(q), u_pi_oil(q), u_pi_zaf(q), u_y_zaf(q), ...
        u_pi_lso(q), u_y_lso(q), u_r_lso(q), u_z_lso(q), u_res_gap_lso(q), u_prem_lso(q));
end

fprintf('\n--- ANTICIPATED ---\n');
fprintf('Q    poil    pi_oil  pi_zaf  y_zaf   pi_lso  y_lso   r_lso   z_lso   res_gap prem\n');
fprintf('---- ------- ------- ------- ------- ------- ------- ------- ------- ------- -------\n');
for q = qs
    fprintf('Q%-3d %+6.2f  %+6.2f  %+6.3f  %+6.3f  %+6.3f  %+6.3f  %+6.3f  %+6.3f  %+6.4f  %+6.4f\n', ...
        q, a_poil_gap(q), a_pi_oil(q), a_pi_zaf(q), a_y_zaf(q), ...
        a_pi_lso(q), a_y_lso(q), a_r_lso(q), a_z_lso(q), a_res_gap_lso(q), a_prem_lso(q));
end

fprintf('\nIRF charts saved to %s\n', figdir);
