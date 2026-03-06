% Display results from 10% oil price shock simulation
addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
load simul_10pct_oil/Output/simul_10pct_oil_results.mat;

% Variable indices (from var declaration order)
% 1:y_lso 2:pi_lso 3:i_lso 4:r_lso 5:z_lso 6:s_lso 7:res_gap_lso
% 8:res_lso 9:res_bar_lso 10:prem_lso 11:g_lso
% 12:y_zaf 13:pi_zaf 14:i_zaf 15:r_zaf 16:z_zaf 17:s_zaf
% 18:y_row 19:pi_row 20:i_row
% 21:pi_oil 22:pi_food 23:rcom 24:rcom_bar 25:d_rcom 26:pi_com

% Extract simulation period (skip initial steady state)
T = 20;  % Show 20 quarters
ss_period = 1;  % Initial steady state is period 1

fprintf('\n============================================================\n');
fprintf('  10%% OIL PRICE SHOCK - SUSTAINED 4 QUARTERS THEN TAPER\n');
fprintf('============================================================\n\n');

fprintf('Shock design: pi_oil held at 10%% for Q1-Q4, then AR(1) decay at rho=0.70\n\n');

% Print pi_oil path to verify shock design
fprintf('Oil price inflation path (pi_oil):\n');
for t = 1:12
    fprintf('  Q%2d: %+.4f\n', t, oo_.endo_simul(21, ss_period+t));
end

fprintf('\n--- Lesotho Key Variables (first 16 quarters) ---\n');
fprintf('\nQuarter | y_lso   | pi_lso  | i_lso   | r_lso   | z_lso   | res_gap | res_lso | prem_lso\n');
fprintf('--------|---------|---------|---------|---------|---------|---------|---------|--------\n');
for t = 1:16
    fprintf('   Q%2d  | %+.4f  | %+.4f  | %+.4f  | %+.4f  | %+.4f  | %+.4f  | %+.4f  | %+.4f\n', ...
        t, oo_.endo_simul(1, ss_period+t), oo_.endo_simul(2, ss_period+t), ...
        oo_.endo_simul(3, ss_period+t), oo_.endo_simul(4, ss_period+t), ...
        oo_.endo_simul(5, ss_period+t), oo_.endo_simul(7, ss_period+t), ...
        oo_.endo_simul(8, ss_period+t), oo_.endo_simul(10, ss_period+t));
end

fprintf('\n--- South Africa Key Variables (first 16 quarters) ---\n');
fprintf('\nQuarter | y_zaf   | pi_zaf  | i_zaf   | r_zaf   | z_zaf   | s_zaf\n');
fprintf('--------|---------|---------|---------|---------|---------|--------\n');
for t = 1:16
    fprintf('   Q%2d  | %+.4f  | %+.4f  | %+.4f  | %+.4f  | %+.4f  | %+.4f\n', ...
        t, oo_.endo_simul(12, ss_period+t), oo_.endo_simul(13, ss_period+t), ...
        oo_.endo_simul(14, ss_period+t), oo_.endo_simul(15, ss_period+t), ...
        oo_.endo_simul(16, ss_period+t), oo_.endo_simul(17, ss_period+t));
end

fprintf('\n--- Peak Responses ---\n');
sim = oo_.endo_simul(:, ss_period+1:ss_period+T);

% Lesotho
[pk, idx] = max(abs(sim(1,:))); fprintf('y_lso peak:      %+.4f at Q%d\n', sim(1,idx), idx);
[pk, idx] = max(abs(sim(2,:))); fprintf('pi_lso peak:     %+.4f at Q%d\n', sim(2,idx), idx);
[pk, idx] = max(abs(sim(3,:))); fprintf('i_lso peak:      %+.4f at Q%d\n', sim(3,idx), idx);
[pk, idx] = max(abs(sim(5,:))); fprintf('z_lso peak:      %+.4f at Q%d\n', sim(5,idx), idx);
[pk, idx] = max(abs(sim(7,:))); fprintf('res_gap peak:    %+.4f at Q%d\n', sim(7,idx), idx);
[pk, idx] = max(abs(sim(10,:))); fprintf('prem_lso peak:   %+.4f at Q%d\n', sim(10,idx), idx);

% South Africa
[pk, idx] = max(abs(sim(12,:))); fprintf('y_zaf peak:      %+.4f at Q%d\n', sim(12,idx), idx);
[pk, idx] = max(abs(sim(13,:))); fprintf('pi_zaf peak:     %+.4f at Q%d\n', sim(13,idx), idx);
[pk, idx] = max(abs(sim(14,:))); fprintf('i_zaf peak:      %+.4f at Q%d\n', sim(14,idx), idx);

fprintf('\n--- Oil shock variable ---\n');
[pk, idx] = max(abs(sim(21,:))); fprintf('pi_oil peak:     %+.4f at Q%d\n', sim(21,idx), idx);

fprintf('\n');
