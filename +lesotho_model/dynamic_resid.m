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
    T = lesotho_model.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(23, 1);
    residual(1) = (y(18)) - (params(1)*y(1)+params(2)*y(41)+params(3)*y(29)-params(4)*(params(5)*y(21)+(1-params(5))*y(22))+params(6)*y(28)+x(it_, 1));
    residual(2) = (y(19)) - (x(it_, 2)+y(30)+(params(8)-params(9))*y(38)+(params(10)-params(11))*y(39)+y(18)*params(7)+x(it_, 8)+params(12)*y(17));
    residual(3) = (y(23)) - (y(34)+x(it_, 4));
    residual(4) = (y(20)) - (y(31)+y(27)+x(it_, 3));
    residual(5) = (y(21)) - (y(20)-y(42));
    residual(6) = (y(22)) - (params(38)*y(2)+y(23)-y(3)-(y(19)-y(30))/4);
    residual(7) = (y(24)) - (params(13)*y(4)-y(28)*params(14)-y(22)*params(15)+x(it_, 5));
    residual(8) = (y(26)) - (params(16)*y(5));
    residual(9) = (y(25)) - (y(24)+y(26));
    residual(10) = (y(27)) - (params(18)*(y(26)-y(25))+x(it_, 6));
    residual(11) = (y(28)) - (params(37)*y(6)+x(it_, 7));
    residual(12) = (y(29)) - (params(19)*y(7)+params(20)*y(43)-params(21)*y(32)+params(22)*y(33)+params(23)*y(35)+x(it_, 9));
    residual(13) = (y(30)) - (params(24)*y(8)+(1-params(24))*y(44)+y(29)*params(25)+params(26)*(y(33)-y(10))+x(it_, 10));
    residual(14) = (y(31)) - (params(27)*y(9)+(1-params(27))*(y(44)*params(28)+y(29)*params(29))+x(it_, 11));
    residual(15) = (y(32)) - (y(31)-y(44));
    residual(16) = (y(34)) - (params(31)*y(11)+(1-params(31))*y(45)-(y(31)-y(37))/4+x(it_, 12));
    residual(17) = (y(33)) - (params(38)*y(10)+y(34)-y(11)-(y(30)-y(36))/4);
    residual(18) = (y(35)) - (params(32)*y(12)+x(it_, 13));
    residual(19) = (y(36)) - (params(33)*y(13)+x(it_, 14));
    residual(20) = (y(37)) - (params(34)*y(14)+(1-params(34))*(y(36)*1.5+y(35)*0.5)+x(it_, 15));
    residual(21) = (y(38)) - (params(35)*y(15)+x(it_, 16));
    residual(22) = (y(39)) - (params(36)*y(16)+x(it_, 17));
    residual(23) = (y(40)) - (x(it_, 8));

end
