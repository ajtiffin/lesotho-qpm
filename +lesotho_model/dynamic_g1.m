function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
% function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
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
%   g1
%

if T_flag
    T = lesotho_model.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(23, 62);
g1(1,1)=(-params(1));
g1(1,18)=1;
g1(1,41)=(-params(2));
g1(1,21)=params(4)*params(5);
g1(1,22)=params(4)*(1-params(5));
g1(1,28)=(-params(6));
g1(1,29)=(-params(3));
g1(1,46)=(-1);
g1(2,18)=(-params(7));
g1(2,19)=1;
g1(2,30)=(-1);
g1(2,38)=(-(params(8)-params(9)));
g1(2,39)=(-(params(10)-params(11)));
g1(2,47)=(-1);
g1(2,53)=(-1);
g1(2,17)=(-params(12));
g1(3,23)=1;
g1(3,34)=(-1);
g1(3,49)=(-1);
g1(4,20)=1;
g1(4,27)=(-1);
g1(4,31)=(-1);
g1(4,48)=(-1);
g1(5,42)=1;
g1(5,20)=(-1);
g1(5,21)=1;
g1(6,19)=0.25;
g1(6,2)=(-params(38));
g1(6,22)=1;
g1(6,3)=1;
g1(6,23)=(-1);
g1(6,30)=(-0.25);
g1(7,22)=params(15);
g1(7,4)=(-params(13));
g1(7,24)=1;
g1(7,28)=params(14);
g1(7,50)=(-1);
g1(8,5)=(-params(16));
g1(8,26)=1;
g1(9,24)=(-1);
g1(9,25)=1;
g1(9,26)=(-1);
g1(10,25)=params(18);
g1(10,26)=(-params(18));
g1(10,27)=1;
g1(10,51)=(-1);
g1(11,6)=(-params(37));
g1(11,28)=1;
g1(11,52)=(-1);
g1(12,7)=(-params(19));
g1(12,29)=1;
g1(12,43)=(-params(20));
g1(12,32)=params(21);
g1(12,33)=(-params(22));
g1(12,35)=(-params(23));
g1(12,54)=(-1);
g1(13,29)=(-params(25));
g1(13,8)=(-params(24));
g1(13,30)=1;
g1(13,44)=(-(1-params(24)));
g1(13,10)=params(26);
g1(13,33)=(-params(26));
g1(13,55)=(-1);
g1(14,29)=(-((1-params(27))*params(29)));
g1(14,44)=(-((1-params(27))*params(28)));
g1(14,9)=(-params(27));
g1(14,31)=1;
g1(14,56)=(-1);
g1(15,44)=1;
g1(15,31)=(-1);
g1(15,32)=1;
g1(16,31)=0.25;
g1(16,11)=(-params(31));
g1(16,34)=1;
g1(16,45)=(-(1-params(31)));
g1(16,37)=(-0.25);
g1(16,57)=(-1);
g1(17,30)=0.25;
g1(17,10)=(-params(38));
g1(17,33)=1;
g1(17,11)=1;
g1(17,34)=(-1);
g1(17,36)=(-0.25);
g1(18,12)=(-params(32));
g1(18,35)=1;
g1(18,58)=(-1);
g1(19,13)=(-params(33));
g1(19,36)=1;
g1(19,59)=(-1);
g1(20,35)=(-((1-params(34))*0.5));
g1(20,36)=(-((1-params(34))*1.5));
g1(20,14)=(-params(34));
g1(20,37)=1;
g1(20,60)=(-1);
g1(21,15)=(-params(35));
g1(21,38)=1;
g1(21,61)=(-1);
g1(22,16)=(-params(36));
g1(22,39)=1;
g1(22,62)=(-1);
g1(23,53)=(-1);
g1(23,40)=1;

end
