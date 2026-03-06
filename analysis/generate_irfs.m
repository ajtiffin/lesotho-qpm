% Generate IRF plots for the Lesotho QPM V3 research report
% Runs the model with stoch_simul to get IRFs, then saves publication-quality plots

addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');

% Run the model to get IRFs
cd('/Users/andrewtiffin/Projects/lesotho');
dynare lesotho_model_v3.mod noclearall;

% Set graphics toolkit AFTER dynare runs (it resets things)
graphics_toolkit('gnuplot');

% Extract IRF data from oo_ structure
% Dynare stores IRFs as oo_.irfs.VARNAME_SHOCKNAME

% Settings
horizon = 20;  % Show 20 quarters (5 years)
lw = 1.5;      % line width
fs = 10;       % font size

% Color scheme
c_lso = [0.2 0.4 0.8];    % blue for Lesotho
c_zaf = [0.8 0.2 0.2];    % red for SA
c_row = [0.4 0.7 0.3];    % green for ROW
c_com = [0.8 0.6 0.1];    % gold for commodity
c_res = [0.5 0.3 0.7];    % purple for reserves
c_gray = [0.5 0.5 0.5];   % gray for zero line

quarters = 1:horizon;

outdir = '/Users/andrewtiffin/Projects/lesotho/analysis/figures';
mkdir(outdir);

%% ========================================================================
%% FIGURE 1: SA Demand Shock (eps_y_zaf)
%% ========================================================================
figure('Position', [100 100 900 700], 'Visible', 'off');

subplot(2,3,1);
plot(quarters, oo_.irfs.y_zaf_eps_y_zaf(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('SA Output Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,2);
plot(quarters, oo_.irfs.y_lso_eps_y_zaf(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho Output Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,3);
plot(quarters, oo_.irfs.pi_lso_eps_y_zaf(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.pi_zaf_eps_y_zaf(1:horizon), 'Color', c_zaf, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Inflation', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('Lesotho', 'SA');

subplot(2,3,4);
plot(quarters, oo_.irfs.i_lso_eps_y_zaf(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.i_zaf_eps_y_zaf(1:horizon), 'Color', c_zaf, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Nominal Interest Rate', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('Lesotho', 'SA');

subplot(2,3,5);
plot(quarters, oo_.irfs.res_gap_lso_eps_y_zaf(1:horizon), 'Color', c_res, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Reserves Gap', 'FontSize', fs);
ylabel('months'); xlabel('Quarters');

subplot(2,3,6);
plot(quarters, oo_.irfs.prem_lso_eps_y_zaf(1:horizon), 'Color', c_res, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Risk Premium', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

ha = axes('Position', [0 0 1 1], 'Visible', 'off');
text(0.5, 0.98, 'Impulse Responses to 1 s.d. SA Demand Shock', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Parent', ha);
print(gcf, fullfile(outdir, 'irf_sa_demand.png'), '-dpng', '-r200');
close(gcf);

%% ========================================================================
%% FIGURE 2: Fiscal Shock (eps_g_lso)
%% ========================================================================
figure('Position', [100 100 900 700], 'Visible', 'off');

subplot(2,3,1);
plot(quarters, oo_.irfs.g_lso_eps_g_lso(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Govt Spending', 'FontSize', fs);
ylabel('pp of GDP'); xlabel('Quarters');

subplot(2,3,2);
plot(quarters, oo_.irfs.y_lso_eps_g_lso(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho Output Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,3);
plot(quarters, oo_.irfs.pi_lso_eps_g_lso(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho Inflation', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,4);
plot(quarters, oo_.irfs.res_gap_lso_eps_g_lso(1:horizon), 'Color', c_res, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Reserves Gap', 'FontSize', fs);
ylabel('months'); xlabel('Quarters');

subplot(2,3,5);
plot(quarters, oo_.irfs.prem_lso_eps_g_lso(1:horizon), 'Color', c_res, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Risk Premium', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,6);
plot(quarters, oo_.irfs.i_lso_eps_g_lso(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.r_lso_eps_g_lso(1:horizon), 'Color', c_zaf, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Interest Rates', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('Nominal', 'Real');

ha = axes('Position', [0 0 1 1], 'Visible', 'off');
text(0.5, 0.98, 'Impulse Responses to 1 s.d. Fiscal Expansion', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Parent', ha);
print(gcf, fullfile(outdir, 'irf_fiscal.png'), '-dpng', '-r200');
close(gcf);

%% ========================================================================
%% FIGURE 3: SA Monetary Policy Shock (eps_i_zaf)
%% ========================================================================
figure('Position', [100 100 900 700], 'Visible', 'off');

subplot(2,3,1);
plot(quarters, oo_.irfs.i_zaf_eps_i_zaf(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.i_lso_eps_i_zaf(1:horizon), 'Color', c_lso, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Policy Rates', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('SARB', 'CBL');

subplot(2,3,2);
plot(quarters, oo_.irfs.y_zaf_eps_i_zaf(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.y_lso_eps_i_zaf(1:horizon), 'Color', c_lso, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Output Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('SA', 'Lesotho');

subplot(2,3,3);
plot(quarters, oo_.irfs.pi_zaf_eps_i_zaf(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.pi_lso_eps_i_zaf(1:horizon), 'Color', c_lso, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Inflation', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('SA', 'Lesotho');

subplot(2,3,4);
plot(quarters, oo_.irfs.z_zaf_eps_i_zaf(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.z_lso_eps_i_zaf(1:horizon), 'Color', c_lso, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('REER Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('SA', 'Lesotho');

subplot(2,3,5);
plot(quarters, oo_.irfs.res_gap_lso_eps_i_zaf(1:horizon), 'Color', c_res, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho Reserves Gap', 'FontSize', fs);
ylabel('months'); xlabel('Quarters');

subplot(2,3,6);
plot(quarters, oo_.irfs.prem_lso_eps_i_zaf(1:horizon), 'Color', c_res, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho Risk Premium', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

ha = axes('Position', [0 0 1 1], 'Visible', 'off');
text(0.5, 0.98, 'Impulse Responses to 1 s.d. SARB Monetary Tightening', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Parent', ha);
print(gcf, fullfile(outdir, 'irf_sarb_tightening.png'), '-dpng', '-r200');
close(gcf);

%% ========================================================================
%% FIGURE 4: Food Price Shock (eps_food)
%% ========================================================================
figure('Position', [100 100 900 700], 'Visible', 'off');

subplot(2,3,1);
plot(quarters, oo_.irfs.pi_food_eps_food(1:horizon), 'Color', c_com, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Food Price Inflation', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,2);
plot(quarters, oo_.irfs.pi_lso_eps_food(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.pi_zaf_eps_food(1:horizon), 'Color', c_zaf, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Inflation', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('Lesotho', 'SA');

subplot(2,3,3);
plot(quarters, oo_.irfs.y_lso_eps_food(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho Output Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,4);
plot(quarters, oo_.irfs.r_lso_eps_food(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho Real Rate', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,5);
plot(quarters, oo_.irfs.z_lso_eps_food(1:horizon), 'Color', c_lso, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho REER Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,6);
plot(quarters, oo_.irfs.res_gap_lso_eps_food(1:horizon), 'Color', c_res, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Reserves Gap', 'FontSize', fs);
ylabel('months'); xlabel('Quarters');

ha = axes('Position', [0 0 1 1], 'Visible', 'off');
text(0.5, 0.98, 'Impulse Responses to 1 s.d. Food Price Shock', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Parent', ha);
print(gcf, fullfile(outdir, 'irf_food_price.png'), '-dpng', '-r200');
close(gcf);

%% ========================================================================
%% FIGURE 5: US Demand Shock (eps_y_row)
%% ========================================================================
figure('Position', [100 100 900 700], 'Visible', 'off');

subplot(2,3,1);
plot(quarters, oo_.irfs.y_row_eps_y_row(1:horizon), 'Color', c_row, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('US Output Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');

subplot(2,3,2);
plot(quarters, oo_.irfs.y_zaf_eps_y_row(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.y_lso_eps_y_row(1:horizon), 'Color', c_lso, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Output Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('SA', 'Lesotho');

subplot(2,3,3);
plot(quarters, oo_.irfs.pi_zaf_eps_y_row(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.pi_lso_eps_y_row(1:horizon), 'Color', c_lso, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Inflation', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('SA', 'Lesotho');

subplot(2,3,4);
plot(quarters, oo_.irfs.i_zaf_eps_y_row(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.i_lso_eps_y_row(1:horizon), 'Color', c_lso, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Nominal Interest Rate', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('SA', 'Lesotho');

subplot(2,3,5);
plot(quarters, oo_.irfs.z_zaf_eps_y_row(1:horizon), 'Color', c_zaf, 'LineWidth', lw); hold on;
plot(quarters, oo_.irfs.z_lso_eps_y_row(1:horizon), 'Color', c_lso, 'LineWidth', lw, 'LineStyle', '--');
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('REER Gap', 'FontSize', fs);
ylabel('pp deviation'); xlabel('Quarters');
legend('SA', 'Lesotho');

subplot(2,3,6);
plot(quarters, oo_.irfs.res_gap_lso_eps_y_row(1:horizon), 'Color', c_res, 'LineWidth', lw); hold on;
plot(quarters, zeros(1,horizon), 'Color', c_gray, 'LineStyle', '--');
title('Lesotho Reserves Gap', 'FontSize', fs);
ylabel('months'); xlabel('Quarters');

ha = axes('Position', [0 0 1 1], 'Visible', 'off');
text(0.5, 0.98, 'Impulse Responses to 1 s.d. US Demand Shock', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Parent', ha);
print(gcf, fullfile(outdir, 'irf_us_demand.png'), '-dpng', '-r200');
close(gcf);

fprintf('\n=== All IRF figures saved to %s ===\n', outdir);
