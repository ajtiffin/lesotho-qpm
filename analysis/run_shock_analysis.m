% Shock Analysis Script for Lesotho QPM Model
% Analyzes two scenarios:
% 1. Global demand increase (US output shock)
% 2. South African activity pickup (gold price boom)

addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');

% Change to model directory
cd('/Users/andrewtiffin/Projects/lesotho');

% Run the model
dynare lesotho_model.mod noclearall;

% Load results
load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');

% Extract IRFs for key shocks
shocks = {'eps_y_row', 'eps_y_zaf'};
variables = {'y_lso', 'pi_lso', 'i_lso', 'r_lso', 'z_lso', 'res_lso', 'prem_lso', ...
             'y_zaf', 'pi_zaf', 'i_zaf', 'res_gap_lso', 'g_lso'};

% Create structure to store IRF data
irf_data = struct();

for i = 1:length(shocks)
    shock_name = shocks{i};
    irf_data.(shock_name) = struct();

    for j = 1:length(variables)
        var_name = variables{j};
        irf_field = [var_name '_' shock_name];

        if isfield(oo_.irfs, irf_field)
            irf_data.(shock_name).(var_name) = oo_.irfs.(irf_field);
        else
            irf_data.(shock_name).(var_name) = zeros(1, 40);
        end
    end
end

% Save IRF data
save('/Users/andrewtiffin/Projects/lesotho/analysis/irf_data.mat', 'irf_data');

% Generate CSV files using dlmwrite
time = (1:40)';

% Header for CSV files
header = 'Quarter,y_lso,pi_lso,i_lso,r_lso,z_lso,res_lso,prem_lso,y_zaf,pi_zaf,i_zaf\n';

% Global demand shock (eps_y_row)
row_data = [time, ...
    irf_data.eps_y_row.y_lso', ...
    irf_data.eps_y_row.pi_lso', ...
    irf_data.eps_y_row.i_lso', ...
    irf_data.eps_y_row.r_lso', ...
    irf_data.eps_y_row.z_lso', ...
    irf_data.eps_y_row.res_lso', ...
    irf_data.eps_y_row.prem_lso', ...
    irf_data.eps_y_row.y_zaf', ...
    irf_data.eps_y_row.pi_zaf', ...
    irf_data.eps_y_row.i_zaf'];

fid = fopen('/Users/andrewtiffin/Projects/lesotho/analysis/global_demand_shock.csv', 'w');
fprintf(fid, 'Quarter,y_lso,pi_lso,i_lso,r_lso,z_lso,res_lso,prem_lso,y_zaf,pi_zaf,i_zaf\n');
fclose(fid);
dlmwrite('/Users/andrewtiffin/Projects/lesotho/analysis/global_demand_shock.csv', row_data, '-append');

% SA activity shock (eps_y_zaf)
zaf_data = [time, ...
    irf_data.eps_y_zaf.y_lso', ...
    irf_data.eps_y_zaf.pi_lso', ...
    irf_data.eps_y_zaf.i_lso', ...
    irf_data.eps_y_zaf.r_lso', ...
    irf_data.eps_y_zaf.z_lso', ...
    irf_data.eps_y_zaf.res_lso', ...
    irf_data.eps_y_zaf.prem_lso', ...
    irf_data.eps_y_zaf.y_zaf', ...
    irf_data.eps_y_zaf.pi_zaf', ...
    irf_data.eps_y_zaf.i_zaf'];

fid = fopen('/Users/andrewtiffin/Projects/lesotho/analysis/sa_activity_shock.csv', 'w');
fprintf(fid, 'Quarter,y_lso,pi_lso,i_lso,r_lso,z_lso,res_lso,prem_lso,y_zaf,pi_zaf,i_zaf\n');
fclose(fid);
dlmwrite('/Users/andrewtiffin/Projects/lesotho/analysis/sa_activity_shock.csv', zaf_data, '-append');

fprintf('IRF data saved successfully.\n');

% Print summary statistics
fprintf('\n=== GLOBAL DEMAND SHOCK (US Output) ===\n');
fprintf('Peak y_lso: %.3f (Q%d)\n', max(irf_data.eps_y_row.y_lso), ...
    find(irf_data.eps_y_row.y_lso == max(irf_data.eps_y_row.y_lso), 1));
fprintf('Peak pi_lso: %.3f (Q%d)\n', max(irf_data.eps_y_row.pi_lso), ...
    find(irf_data.eps_y_row.pi_lso == max(irf_data.eps_y_row.pi_lso), 1));
fprintf('Peak i_lso: %.3f (Q%d)\n', max(irf_data.eps_y_row.i_lso), ...
    find(irf_data.eps_y_row.i_lso == max(irf_data.eps_y_row.i_lso), 1));

fprintf('\n=== SA ACTIVITY SHOCK (Gold Boom) ===\n');
fprintf('Peak y_lso: %.3f (Q%d)\n', max(irf_data.eps_y_zaf.y_lso), ...
    find(irf_data.eps_y_zaf.y_lso == max(irf_data.eps_y_zaf.y_lso), 1));
fprintf('Peak pi_lso: %.3f (Q%d)\n', max(irf_data.eps_y_zaf.pi_lso), ...
    find(irf_data.eps_y_zaf.pi_lso == max(irf_data.eps_y_zaf.pi_lso), 1));
fprintf('Peak i_lso: %.3f (Q%d)\n', max(irf_data.eps_y_zaf.i_lso), ...
    find(irf_data.eps_y_zaf.i_lso == max(irf_data.eps_y_zaf.i_lso), 1));
