% Run and display results from 5pp commodity price shock simulation
addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
dynare simul_5pp_commodity.mod noclearall;

fprintf('\n=== 5pp Global Commodity Price Shock Results ===\n\n');

% Display peak responses for key Lesotho variables
fprintf('Lesotho Peak Responses (percentage points):\n');
fprintf('  Output gap (y_lso):          %+.4f at period %d\n', max(abs(oo_.endo_simul(1,:))), find(abs(oo_.endo_simul(1,:))==max(abs(oo_.endo_simul(1,:)))));
fprintf('  Inflation (pi_lso):          %+.4f at period %d\n', max(oo_.endo_simul(2,:)), find(oo_.endo_simul(2,:)==max(oo_.endo_simul(2,:))));
fprintf('  Interest rate (i_lso):       %+.4f at period %d\n', max(oo_.endo_simul(3,:)), find(oo_.endo_simul(3,:)==max(oo_.endo_simul(3,:))));
fprintf('  REER (z_lso):                %+.4f at period %d\n', max(abs(oo_.endo_simul(5,:))), find(abs(oo_.endo_simul(5,:))==max(abs(oo_.endo_simul(5,:)))));
fprintf('  Reserves gap (res_gap_lso):  %+.4f at period %d\n', min(oo_.endo_simul(7,:)), find(oo_.endo_simul(7,:)==min(oo_.endo_simul(7,:))));
fprintf('  Risk premium (prem_lso):     %+.4f at period %d\n', max(oo_.endo_simul(10,:)), find(oo_.endo_simul(10,:)==max(oo_.endo_simul(10,:))));

fprintf('\nSouth Africa Peak Responses:\n');
fprintf('  Output gap (y_zaf):          %+.4f at period %d\n', max(abs(oo_.endo_simul(12,:))), find(abs(oo_.endo_simul(12,:))==max(abs(oo_.endo_simul(12,:)))));
fprintf('  Inflation (pi_zaf):          %+.4f at period %d\n', max(oo_.endo_simul(13,:)), find(oo_.endo_simul(13,:)==max(oo_.endo_simul(13,:))));

fprintf('\nCommodity Variables:\n');
fprintf('  Real commodity price (rcom): %+.4f at period %d\n', max(oo_.endo_simul(23,:)), find(oo_.endo_simul(23,:)==max(oo_.endo_simul(23,:))));
fprintf('  Commodity inflation (pi_com):%+.4f at period %d\n', max(oo_.endo_simul(26,:)), find(oo_.endo_simul(26,:)==max(oo_.endo_simul(26,:))));

fprintf('\nFirst 8 quarters impulse responses:\n');
fprintf('\nQuarter | y_lso  | pi_lso | i_lso  | z_lso  | res_gap | y_zaf  | pi_zaf | rcom   |\n');
fprintf('--------|--------|--------|--------|--------|---------|--------|--------|--------|\n');
for t = 1:8
    fprintf('   %2d   | %+.4f | %+.4f | %+.4f | %+.4f | %+.4f  | %+.4f | %+.4f | %+.4f |\n', ...
        t, oo_.endo_simul(1,t), oo_.endo_simul(2,t), oo_.endo_simul(3,t), ...
        oo_.endo_simul(5,t), oo_.endo_simul(7,t), oo_.endo_simul(12,t), ...
        oo_.endo_simul(13,t), oo_.endo_simul(23,t));
end

fprintf('\n');
