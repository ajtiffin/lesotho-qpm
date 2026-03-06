% Display results from 10% oil price shock simulation - V4 vs V3 comparison
addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');

% Load V4 results
load simul_10pct_oil_v4/Output/simul_10pct_oil_v4_results.mat;
v4 = oo_.endo_simul;

% Load V3 results
load simul_10pct_oil/Output/simul_10pct_oil_results.mat;
v3 = oo_.endo_simul;

% Variable indices (from var declaration order)
% 1:y_lso 2:pi_lso 3:i_lso 4:r_lso 5:z_lso 6:s_lso 7:res_gap_lso
% 8:res_lso 9:res_bar_lso 10:prem_lso 11:g_lso
% 12:y_zaf 13:pi_zaf 14:i_zaf 15:r_zaf 16:z_zaf 17:s_zaf
% 18:y_row 19:pi_row 20:i_row
% 21:pi_oil 22:pi_food 23:rcom 24:rcom_bar 25:d_rcom 26:pi_com

T = 20;  % Show 20 quarters
ss_period = 1;  % Initial steady state is period 1

fprintf('\n============================================================\n');
fprintf('  10%% OIL PRICE SHOCK - V4 vs V3 COMPARISON\n');
fprintf('  V4: Enriched oil/food transmission\n');
fprintf('============================================================\n\n');

fprintf('V4 changes:\n');
fprintf('  - SA Phillips curve: +lambda_4*pi_oil (0.03) + lambda_5*pi_food (0.05)\n');
fprintf('  - Food price eq: +kappa_oil_food*pi_oil (0.05)\n\n');

% Print oil and food price paths
fprintf('--- Oil & Food Price Paths ---\n');
fprintf('\nQuarter | pi_oil (v4) | pi_oil (v3) | pi_food (v4) | pi_food (v3)\n');
fprintf('--------|-------------|-------------|--------------|------------\n');
for t = 1:12
    fprintf('   Q%2d  |   %+.4f    |   %+.4f    |    %+.4f     |    %+.4f\n', ...
        t, v4(21, ss_period+t), v3(21, ss_period+t), ...
        v4(22, ss_period+t), v3(22, ss_period+t));
end

fprintf('\n--- Lesotho: V4 vs V3 (first 16 quarters) ---\n');
fprintf('\nQuarter | y_lso(v4) | y_lso(v3) | pi_lso(v4) | pi_lso(v3) | i_lso(v4) | i_lso(v3) | z_lso(v4) | z_lso(v3)\n');
fprintf('--------|-----------|-----------|------------|------------|-----------|-----------|-----------|----------\n');
for t = 1:16
    fprintf('   Q%2d  |  %+.4f   |  %+.4f   |   %+.4f   |   %+.4f   |  %+.4f   |  %+.4f   |  %+.4f   |  %+.4f\n', ...
        t, v4(1, ss_period+t), v3(1, ss_period+t), ...
        v4(2, ss_period+t), v3(2, ss_period+t), ...
        v4(3, ss_period+t), v3(3, ss_period+t), ...
        v4(5, ss_period+t), v3(5, ss_period+t));
end

fprintf('\n--- South Africa: V4 vs V3 (first 16 quarters) ---\n');
fprintf('\nQuarter | pi_zaf(v4) | pi_zaf(v3) | i_zaf(v4) | i_zaf(v3) | y_zaf(v4) | y_zaf(v3)\n');
fprintf('--------|------------|------------|-----------|-----------|-----------|----------\n');
for t = 1:16
    fprintf('   Q%2d  |   %+.4f   |   %+.4f   |  %+.4f   |  %+.4f   |  %+.4f   |  %+.4f\n', ...
        t, v4(13, ss_period+t), v3(13, ss_period+t), ...
        v4(14, ss_period+t), v3(14, ss_period+t), ...
        v4(12, ss_period+t), v3(12, ss_period+t));
end

fprintf('\n--- Peak Responses: V4 vs V3 ---\n');
sim_v4 = v4(:, ss_period+1:ss_period+T);
sim_v3 = v3(:, ss_period+1:ss_period+T);

fprintf('\nVariable        |  V4 peak  |  V3 peak  |  Ratio (V4/V3)\n');
fprintf('----------------|-----------|-----------|---------------\n');

vars = {'pi_lso', 'y_lso', 'pi_zaf', 'i_zaf', 'pi_food', 'z_lso', 'res_gap', 'prem_lso', 'pi_oil'};
idxs = [2, 1, 13, 14, 22, 5, 7, 10, 21];

for v = 1:length(vars)
    idx = idxs(v);
    [~, pk4] = max(abs(sim_v4(idx,:)));
    [~, pk3] = max(abs(sim_v3(idx,:)));
    val4 = sim_v4(idx, pk4);
    val3 = sim_v3(idx, pk3);
    if abs(val3) > 1e-6
        ratio = val4/val3;
        fprintf('%-15s |  %+.4f  |  %+.4f  |  %.2fx\n', vars{v}, val4, val3, ratio);
    else
        fprintf('%-15s |  %+.4f  |  %+.4f  |  n/a (v3~0)\n', vars{v}, val4, val3);
    end
end

fprintf('\n--- Reserves: V4 vs V3 ---\n');
fprintf('\nQuarter | res_gap(v4) | res_gap(v3) | res_lso(v4) | res_lso(v3)\n');
fprintf('--------|-------------|-------------|-------------|------------\n');
for t = [1 2 4 8 12 16]
    fprintf('   Q%2d  |   %+.4f    |   %+.4f    |    %.4f    |    %.4f\n', ...
        t, v4(7, ss_period+t), v3(7, ss_period+t), ...
        v4(8, ss_period+t), v3(8, ss_period+t));
end

fprintf('\n');
