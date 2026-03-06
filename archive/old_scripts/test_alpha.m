addpath('/opt/homebrew/Cellar/dynare/6.5_1/lib/dynare/matlab');
cd('/Users/andrewtiffin/Projects/lesotho');

% Test different alpha_3 values
values = [0.20, 0.30, 0.40];

fid = fopen('lesotho_model.mod', 'r');
base = fread(fid, '*char')';
fclose(fid);

printf('\n=== ALPHA_3 Sensitivity ===\n');

for i = 1:length(values)
    c = regexprep(base, 'alpha_3\s*=\s*[\d.]+', sprintf('alpha_3     = %.2f', values(i)));
    fid = fopen('lesotho_model.mod', 'w');
    fprintf(fid, '%s', c);
    fclose(fid);

    dynare('lesotho_model.mod', 'noclearall');
    load('lesotho_model/Output/lesotho_model_results.mat', 'oo_');

    sa_peak = max(oo_.irfs.y_lso_eps_y_zaf);
    glob_peak = max(oo_.irfs.y_lso_eps_y_row);
    ratio = sa_peak / glob_peak;

    printf('alpha_3=%.2f: SA=%.3f, Global=%.3f, Ratio=%.2fx\n', values(i), sa_peak, glob_peak, ratio);
end

fid = fopen('lesotho_model.mod', 'w');
fprintf(fid, '%s', base);
fclose(fid);
