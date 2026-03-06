% Quick sensitivity analysis
addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
cd('/Users/andrewtiffin/Projects/lesotho');

% Test alpha_3 values
alpha_3_values = [0.20, 0.25, 0.30, 0.35, 0.40];

printf('\n=== ALPHA_3 (SA Spillover) SENSITIVITY ===\n');
printf('alpha_3 | SA Peak | Global | Ratio | SA Q40 | Global Q40\n');
printf('---------------------------------------------------------\n');

for i = 1:length(alpha_3_values)
    % Update parameter file
    fid = fopen('lesotho_model.mod', 'r');
    content = fread(fid, '*char')';
    fclose(fid);

    % Replace alpha_3
    content = regexprep(content, 'alpha_3\s*=\s*[\d.]+', sprintf('alpha_3     = %.2f', alpha_3_values(i)));

    fid = fopen('lesotho_model.mod', 'w');
    fprintf(fid, '%s', content);
    fclose(fid);

    % Run model
    eval('dynare lesotho_model.mod noclearall');

    % Extract results
    load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');
    sa_peak = max(oo_.irfs.y_lso_eps_y_zaf);
    glob_peak = max(oo_.irfs.y_lso_eps_y_row);
    ratio = sa_peak / glob_peak;
    sa_q40 = oo_.irfs.y_lso_eps_y_zaf(40);
    glob_q40 = oo_.irfs.y_lso_eps_y_row(40);

    printf('  %.2f   |  %.3f   | %.3f  | %.2fx | %.3f  |   %.3f\n', ...
        alpha_3_values(i), sa_peak, glob_peak, ratio, sa_q40, glob_q40);
end

% Restore backup
copyfile('lesotho_model.mod.backup', 'lesotho_model.mod');
printf('\nRestored original model file.\n');
