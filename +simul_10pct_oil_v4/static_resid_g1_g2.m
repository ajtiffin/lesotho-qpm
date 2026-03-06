function [residual, g1, g2] = static_resid_g1_g2(T, y, x, params, T_flag)
% function [residual, g1, g2] = static_resid_g1_g2(T, y, x, params, T_flag)
%
% Wrapper function automatically created by Dynare
%

    if T_flag
        T = simul_10pct_oil_v4.static_g2_tt(T, y, x, params);
    end
    [residual, g1] = simul_10pct_oil_v4.static_resid_g1(T, y, x, params, false);
    g2       = simul_10pct_oil_v4.static_g2(T, y, x, params, false);

end
