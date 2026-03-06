function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = simul_10pct_oil.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(27, 1);
    residual(1) = (y(21)) - (params(1)*y(1)+params(2)*y(48)+params(3)*y(32)-params(4)*(params(5)*y(24)+(1-params(5))*y(25))+params(6)*y(31)+x(it_, 1));
    residual(2) = (y(22)) - (x(it_, 2)+y(33)+(params(8)-params(9))*y(41)+(params(10)-params(11))*y(42)+y(21)*params(7)+x(it_, 8)+params(12)*y(20));
    residual(3) = (y(26)) - (y(37)+x(it_, 4));
    residual(4) = (y(23)) - (y(34)+y(30)+x(it_, 3));
    residual(5) = (y(24)) - (y(23)-y(49));
    residual(6) = (y(25)) - (params(42)*y(2)+y(26)-y(3)-(y(22)-y(33))/4);
    residual(7) = (y(27)) - (params(13)*y(4)-params(14)*y(6)-y(1)*params(15)+params(16)*y(7)+x(it_, 5));
    residual(8) = (y(29)) - ((1-params(17))*params(18)+params(17)*y(5));
    residual(9) = (y(28)) - (y(27)+y(29));
    residual(10) = (y(30)) - (params(19)*(y(29)-y(28))+x(it_, 6));
    residual(11) = (y(31)) - (y(6)*params(41)+x(it_, 7));
    residual(12) = (y(32)) - (y(7)*params(20)+params(21)*y(50)-params(22)*y(35)+params(23)*y(36)+params(24)*y(38)+params(25)*y(45)+x(it_, 9));
    residual(13) = (y(33)) - (params(26)*y(8)+(1-params(26))*y(51)+y(32)*params(27)+params(28)*(y(36)-y(10))+x(it_, 10));
    residual(14) = (y(34)) - (params(29)*y(9)+(1-params(29))*(y(51)*params(30)+y(32)*params(31))+x(it_, 11));
    residual(15) = (y(35)) - (y(34)-y(51));
    residual(16) = (y(37)) - (params(33)*y(11)+(1-params(33))*y(52)-(y(34)-y(40))/4+x(it_, 12));
    residual(17) = (y(36)) - (params(42)*y(10)+y(37)-y(11)-(y(33)-y(39))/4);
    residual(18) = (y(38)) - (params(34)*y(12)+x(it_, 13));
    residual(19) = (y(39)) - (params(35)*y(13)+x(it_, 14));
    residual(20) = (y(40)) - (params(36)*y(14)+(1-params(36))*(y(39)*1.5+y(38)*0.5)+x(it_, 15));
    residual(21) = (y(43)) - (y(45)+y(44));
    residual(22) = (y(44)) - (y(18)+x(it_, 19));
    residual(23) = (y(45)) - (params(40)*y(19)+x(it_, 18));
    residual(24) = (y(46)) - (y(39)+y(43)-y(17));
    residual(25) = (y(41)) - (params(37)*y(15)+x(it_, 16));
    residual(26) = (y(42)) - (params(38)*y(16)+x(it_, 17));
    residual(27) = (y(47)) - (x(it_, 8));

end
