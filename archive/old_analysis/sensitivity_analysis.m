% Sensitivity Analysis for Lesotho QPM Model
% Tests how persistence parameters affect the 6.5x ratio and long-run outcomes

addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
cd('/Users/andrewtiffin/Projects/lesotho');

% Base parameter values
base_params = struct();
base_params.alpha_3 = 0.30;
base_params.delta_res = 0.90;
base_params.f_1 = 0.35;
base_params.theta_prem = 0.35;
base_params.rho_z = 0.80;
base_params.gamma_1 = 0.55;

% Parameter ranges to test
param_ranges = struct();
param_ranges.alpha_3 = [0.20, 0.25, 0.30, 0.35, 0.40];
param_ranges.delta_res = [0.80, 0.85, 0.90, 0.95, 0.98];
param_ranges.f_1 = [0.20, 0.30, 0.35, 0.40, 0.50];
param_ranges.theta_prem = [0.20, 0.30, 0.35, 0.40, 0.50];
param_ranges.rho_z = [0.70, 0.75, 0.80, 0.85, 0.90];
param_ranges.gamma_1 = [0.40, 0.50, 0.55, 0.60, 0.70];

param_names = fieldnames(param_ranges);
results = struct();

% Run base case first
fprintf('Running BASE CASE...\n');
results.base = run_model_with_params(base_params);

% Run sensitivity for each parameter
for i = 1:length(param_names)
    param_name = param_names{i};
    param_values = param_ranges.(param_name);

    fprintf('\nTesting %s...\n', param_name);
    results.(param_name) = struct();

    for j = 1:length(param_values)
        test_params = base_params;
        test_params.(param_name) = param_values(j);

        fprintf('  %s = %.2f\n', param_name, param_values(j));
        results.(param_name).(['v' num2str(j)]) = run_model_with_params(test_params);
    end
end

% Save results
save('/Users/andrewtiffin/Projects/lesotho/analysis/sensitivity_results.mat', 'results', 'base_params', 'param_ranges');

% Display summary
fprintf('\n\n=== SENSITIVITY ANALYSIS SUMMARY ===\n');
fprintf('\nBase Case Results:\n');
fprintf('  SA shock peak y_lso: %.3f\n', results.base.sa_peak_y);
fprintf('  Global shock peak y_lso: %.3f\n', results.base.global_peak_y);
fprintf('  Ratio (SA/Global): %.2fx\n', results.base.ratio);
fprintf('  Global Q40 y_lso: %.3f\n', results.base.global_q40_y);
fprintf('  SA Q40 y_lso: %.3f\n', results.base.sa_q40_y);

% Display sensitivity for each parameter
for i = 1:length(param_names)
    param_name = param_names{i};
    param_values = param_ranges.(param_name);

    fprintf('\n%s Sensitivity:\n', param_name);
    fprintf('  Value\t| Ratio\t| Global Q40\t| SA Q40\n');
    fprintf('  -----------------------------------------------\n');

    for j = 1:length(param_values)
        r = results.(param_name).(['v' num2str(j)]);
        fprintf('  %.2f\t| %.2fx\t| %.3f\t\t| %.3f\n', ...
            param_values(j), r.ratio, r.global_q40_y, r.sa_q40_y);
    end
end

fprintf('\n\nAnalysis complete. Results saved to sensitivity_results.mat\n');

% Helper function
function r = run_model_with_params(params)
    % Create temporary mod file with modified parameters
    fid = fopen('lesotho_model_temp.mod', 'w');

    % Read original file
    orig_fid = fopen('lesotho_model.mod', 'r');
    content = fread(orig_fid, '*char')';
    fclose(orig_fid);

    % Replace parameters
    content = regexprep(content, 'alpha_3\s*=\s*[\d.]+', sprintf('alpha_3 = %.2f', params.alpha_3));
    content = regexprep(content, 'delta_res\s*=\s*[\d.]+', sprintf('delta_res = %.2f', params.delta_res));
    content = regexprep(content, 'f_1\s*=\s*[\d.]+', sprintf('f_1 = %.2f', params.f_1));
    content = regexprep(content, 'theta_prem\s*=\s*[\d.]+', sprintf('theta_prem = %.2f', params.theta_prem));
    content = regexprep(content, 'rho_z\s*=\s*[\d.]+', sprintf('rho_z = %.2f', params.rho_z));
    content = regexprep(content, 'gamma_1\s*=\s*[\d.]+', sprintf('gamma_1 = %.2f', params.gamma_1));

    fprintf(fid, '%s', content);
    fclose(fid);

    % Run dynare
    try
        dynare('lesotho_model_temp.mod', 'noclearall');

        % Extract results
        load('lesotho_model_temp/Output/lesotho_model_temp_results.mat', 'oo_');

        r.sa_peak_y = max(oo_.irfs.y_lso_eps_y_zaf);
        r.global_peak_y = max(oo_.irfs.y_lso_eps_y_row);
        r.ratio = r.sa_peak_y / r.global_peak_y;
        r.sa_q40_y = oo_.irfs.y_lso_eps_y_zaf(40);
        r.global_q40_y = oo_.irfs.y_lso_eps_y_row(40);
        r.sa_q40_res = oo_.irfs.res_lso_eps_y_zaf(40);
        r.global_q40_res = oo_.irfs.res_lso_eps_y_row(40);

    catch ME
        fprintf('Error: %s\n', ME.message);
        r.sa_peak_y = NaN;
        r.global_peak_y = NaN;
        r.ratio = NaN;
        r.sa_q40_y = NaN;
        r.global_q40_y = NaN;
        r.sa_q40_res = NaN;
        r.global_q40_res = NaN;
    end

    % Cleanup
    delete('lesotho_model_temp.mod');
    if exist('lesotho_model_temp', 'dir')
        rmdir('lesotho_model_temp', 's');
    end
end
