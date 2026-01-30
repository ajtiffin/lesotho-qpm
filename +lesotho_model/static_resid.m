function residual = static_resid(T, y, x, params, T_flag)
% function residual = static_resid(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = lesotho_model.static_resid_tt(T, y, x, params);
end
residual = zeros(23, 1);
    residual(1) = (y(1)) - (y(1)*params(1)+y(1)*params(2)+params(3)*y(12)-params(4)*(params(5)*y(4)+(1-params(5))*y(5))+params(6)*y(11)+x(1));
    residual(2) = (y(2)) - (x(2)+y(13)+(params(8)-params(9))*y(21)+(params(10)-params(11))*y(22)+y(1)*params(7)+x(8)+params(12)*y(23));
    residual(3) = (y(6)) - (y(17)+x(4));
    residual(4) = (y(3)) - (y(14)+y(10)+x(3));
    residual(5) = (y(4)) - (y(3)-y(2));
    residual(6) = (y(5)) - (y(5)*params(38)-(y(2)-y(13))/4);
    residual(7) = (y(7)) - (y(7)*params(13)-y(11)*params(14)-y(5)*params(15)+x(5));
    residual(8) = (y(9)) - (y(9)*params(16));
    residual(9) = (y(8)) - (y(7)+y(9));
    residual(10) = (y(10)) - (params(18)*(y(9)-y(8))+x(6));
    residual(11) = (y(11)) - (y(11)*params(37)+x(7));
    residual(12) = (y(12)) - (y(12)*params(19)+y(12)*params(20)-params(21)*y(15)+params(22)*y(16)+params(23)*y(18)+x(9));
    residual(13) = (y(13)) - (y(13)*params(24)+y(13)*(1-params(24))+y(12)*params(25)+x(10));
    residual(14) = (y(14)) - (y(14)*params(27)+(1-params(27))*(y(13)*params(28)+y(12)*params(29))+x(11));
    residual(15) = (y(15)) - (y(14)-y(13));
    residual(16) = (y(17)) - (y(17)*params(31)+y(17)*(1-params(31))-(y(14)-y(20))/4+x(12));
    residual(17) = (y(16)) - (params(38)*y(16)-(y(13)-y(19))/4);
    residual(18) = (y(18)) - (y(18)*params(32)+x(13));
    residual(19) = (y(19)) - (y(19)*params(33)+x(14));
    residual(20) = (y(20)) - (y(20)*params(34)+(1-params(34))*(y(19)*1.5+y(18)*0.5)+x(15));
    residual(21) = (y(21)) - (y(21)*params(35)+x(16));
    residual(22) = (y(22)) - (y(22)*params(36)+x(17));
    residual(23) = (y(23)) - (x(8));

end
