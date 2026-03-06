% Sensitivity Analysis for Lesotho QPM
% Tests key parameters and saves results

addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
cd('/Users/andrewtiffin/Projects/lesotho');

% Load base file
fid = fopen('lesotho_model.mod', 'r');
base_content = fread(fid, '*char')';
fclose(fid);

% Results storage
results = struct();

%% Test 1: alpha_3 (SA spillover)
values = [0.20, 0.25, 0.30, 0.35, 0.40];
results.alpha_3 = [];

fprintf('\n=== Testing alpha_3 ===\n');
for i = 1:length(values)
    content = regexprep(base_content, 'alpha_3\s*=\s*[\d.]+', sprintf('alpha_3     = %.2f', values(i)));
    fid = fopen('lesotho_model.mod', 'w');
    fprintf(fid, '%s', content);
    fclose(fid);

    dynare('lesotho_model.mod', 'noclearall');
    load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');

    r.value = values(i);
    r.sa_peak = max(oo_.irfs.y_lso_eps_y_zaf);
    r.glob_peak = max(oo_.irfs.y_lso_eps_y_row);
    r.ratio = r.sa_peak / r.glob_peak;
    r.sa_q40 = oo_.irfs.y_lso_eps_y_zaf(40);
    r.glob_q40 = oo_.irfs.y_lso_eps_y_row(40);
    r.sa_q40_res = oo_.irfs.res_lso_eps_y_zaf(40);
    r.glob_q40_res = oo_.irfs.res_lso_eps_y_row(40);

    results.alpha_3 = [results.alpha_3, r];
    fprintf('alpha_3=%.2f: SA_peak=%.3f, Ratio=%.2fx, SA_Q40=%.3f\n', values(i), r.sa_peak, r.ratio, r.sa_q40);
end

%% Test 2: delta_res (reserve persistence)
values = [0.80, 0.85, 0.90, 0.95, 0.98];
results.delta_res = [];

fprintf('\n=== Testing delta_res ===\n');
for i = 1:length(values)
    content = regexprep(base_content, 'delta_res\s*=\s*[\d.]+', sprintf('delta_res   = %.2f', values(i)));
    fid = fopen('lesotho_model.mod', 'w');
    fprintf(fid, '%s', content);
    fclose(fid);

    dynare('lesotho_model.mod', 'noclearall');
    load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');

    r.value = values(i);
    r.sa_peak = max(oo_.irfs.y_lso_eps_y_zaf);
    r.glob_peak = max(oo_.irfs.y_lso_eps_y_row);
    r.ratio = r.sa_peak / r.glob_peak;
    r.sa_q40 = oo_.irfs.y_lso_eps_y_zaf(40);
    r.glob_q40 = oo_.irfs.y_lso_eps_y_row(40);
    r.sa_q40_res = oo_.irfs.res_lso_eps_y_zaf(40);
    r.glob_q40_res = oo_.irfs.res_lso_eps_y_row(40);

    results.delta_res = [results.delta_res, r];
    fprintf('delta_res=%.2f: SA_peak=%.3f, Ratio=%.2fx, SA_Q40=%.3f\n', values(i), r.sa_peak, r.ratio, r.sa_q40);
end

%% Test 3: theta_prem (premium sensitivity)
values = [0.20, 0.30, 0.35, 0.40, 0.50];
results.theta_prem = [];

fprintf('\n=== Testing theta_prem ===\n');
for i = 1:length(values)
    content = regexprep(base_content, 'theta_prem\s*=\s*[\d.]+', sprintf('theta_prem  = %.2f', values(i)));
    fid = fopen('lesotho_model.mod', 'w');
    fprintf(fid, '%s', content);
    fclose(fid);

    dynare('lesotho_model.mod', 'noclearall');
    load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');

    r.value = values(i);
    r.sa_peak = max(oo_.irfs.y_lso_eps_y_zaf);
    r.glob_peak = max(oo_.irfs.y_lso_eps_y_row);
    r.ratio = r.sa_peak / r.glob_peak;
    r.sa_q40 = oo_.irfs.y_lso_eps_y_zaf(40);
    r.glob_q40 = oo_.irfs.y_lso_eps_y_row(40);
    r.sa_q40_res = oo_.irfs.res_lso_eps_y_zaf(40);
    r.glob_q40_res = oo_.irfs.res_lso_eps_y_row(40);

    results.theta_prem = [results.theta_prem, r];
    fprintf('theta_prem=%.2f: SA_peak=%.3f, Ratio=%.2fx, SA_Q40=%.3f\n', values(i), r.sa_peak, r.ratio, r.sa_q40);
end

%% Test 4: gamma_1 (SA output persistence)
values = [0.40, 0.50, 0.55, 0.60, 0.70];
results.gamma_1 = [];

fprintf('\n=== Testing gamma_1 ===\n');
for i = 1:length(values)
    content = regexprep(base_content, 'gamma_1\s*=\s*[\d.]+', sprintf('gamma_1     = %.2f', values(i)));
    fid = fopen('lesotho_model.mod', 'w');
    fprintf(fid, '%s', content);
    fclose(fid);

    dynare('lesotho_model.mod', 'noclearall');
    load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');

    r.value = values(i);
    r.sa_peak = max(oo_.irfs.y_lso_eps_y_zaf);
    r.glob_peak = max(oo_.irfs.y_lso_eps_y_row);
    r.ratio = r.sa_peak / r.glob_peak;
    r.sa_q40 = oo_.irfs.y_lso_eps_y_zaf(40);
    r.glob_q40 = oo_.irfs.y_lso_eps_y_row(40);
    r.sa_q40_res = oo_.irfs.res_lso_eps_y_zaf(40);
    r.glob_q40_res = oo_.irfs.res_lso_eps_y_row(40);

    results.gamma_1 = [results.gamma_1, r];
    fprintf('gamma_1=%.2f: SA_peak=%.3f, Ratio=%.2fx, SA_Q40=%.3f\n', values(i), r.sa_peak, r.ratio, r.sa_q40);
end

%% Restore original
fid = fopen('lesotho_model.mod', 'w');
fprintf(fid, '%s', base_content);
fclose(fid);

%% Save results
save('/Users/andrewtiffin/Projects/lesotho/analysis/sensitivity_results.mat', 'results');
fprintf('\n=== Results saved to sensitivity_results.mat ===\n');
