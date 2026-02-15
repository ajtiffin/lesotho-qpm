% IRF Analysis Script for DSGE Models
% Extracts and compares IRFs from Dynare results

% Configuration
model_name = 'country_model';
shock_names = {'eps_y', 'eps_pi', 'eps_i'};
var_names = {'y', 'pi', 'i', 'r'};

% Load results
load(sprintf('%s/Output/%s_results.mat', model_name, model_name), 'oo_');

% Extract and display peak responses
printf('\n=== PEAK RESPONSES ===\n');
for s = 1:length(shock_names)
    for v = 1:length(var_names)
        irf_name = sprintf('%s_%s', var_names{v}, shock_names{s});
        if isfield(oo_.irfs, irf_name)
            irf = oo_.irfs.(irf_name);
            printf('%s -> %s: peak = %.3f at Q%d\n', shock_names{s}, var_names{v}, max(irf), find(irf == max(irf), 1));
        end
    end
end
