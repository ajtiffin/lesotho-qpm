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
    T = simul_10pct_oil.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(27, 71);
g1(1,1)=(-params(1));
g1(1,21)=1;
g1(1,48)=(-params(2));
g1(1,24)=params(4)*params(5);
g1(1,25)=params(4)*(1-params(5));
g1(1,31)=(-params(6));
g1(1,32)=(-params(3));
g1(1,53)=(-1);
g1(2,21)=(-params(7));
g1(2,22)=1;
g1(2,33)=(-1);
g1(2,41)=(-(params(8)-params(9)));
g1(2,42)=(-(params(10)-params(11)));
g1(2,54)=(-1);
g1(2,60)=(-1);
g1(2,20)=(-params(12));
g1(3,26)=1;
g1(3,37)=(-1);
g1(3,56)=(-1);
g1(4,23)=1;
g1(4,30)=(-1);
g1(4,34)=(-1);
g1(4,55)=(-1);
g1(5,49)=1;
g1(5,23)=(-1);
g1(5,24)=1;
g1(6,22)=0.25;
g1(6,2)=(-params(42));
g1(6,25)=1;
g1(6,3)=1;
g1(6,26)=(-1);
g1(6,33)=(-0.25);
g1(7,1)=params(15);
g1(7,4)=(-params(13));
g1(7,27)=1;
g1(7,6)=params(14);
g1(7,7)=(-params(16));
g1(7,57)=(-1);
g1(8,5)=(-params(17));
g1(8,29)=1;
g1(9,27)=(-1);
g1(9,28)=1;
g1(9,29)=(-1);
g1(10,28)=params(19);
g1(10,29)=(-params(19));
g1(10,30)=1;
g1(10,58)=(-1);
g1(11,6)=(-params(41));
g1(11,31)=1;
g1(11,59)=(-1);
g1(12,7)=(-params(20));
g1(12,32)=1;
g1(12,50)=(-params(21));
g1(12,35)=params(22);
g1(12,36)=(-params(23));
g1(12,38)=(-params(24));
g1(12,45)=(-params(25));
g1(12,61)=(-1);
g1(13,32)=(-params(27));
g1(13,8)=(-params(26));
g1(13,33)=1;
g1(13,51)=(-(1-params(26)));
g1(13,10)=params(28);
g1(13,36)=(-params(28));
g1(13,62)=(-1);
g1(14,32)=(-((1-params(29))*params(31)));
g1(14,51)=(-((1-params(29))*params(30)));
g1(14,9)=(-params(29));
g1(14,34)=1;
g1(14,63)=(-1);
g1(15,51)=1;
g1(15,34)=(-1);
g1(15,35)=1;
g1(16,34)=0.25;
g1(16,11)=(-params(33));
g1(16,37)=1;
g1(16,52)=(-(1-params(33)));
g1(16,40)=(-0.25);
g1(16,64)=(-1);
g1(17,33)=0.25;
g1(17,10)=(-params(42));
g1(17,36)=1;
g1(17,11)=1;
g1(17,37)=(-1);
g1(17,39)=(-0.25);
g1(18,12)=(-params(34));
g1(18,38)=1;
g1(18,65)=(-1);
g1(19,13)=(-params(35));
g1(19,39)=1;
g1(19,66)=(-1);
g1(20,38)=(-((1-params(36))*0.5));
g1(20,39)=(-((1-params(36))*1.5));
g1(20,14)=(-params(36));
g1(20,40)=1;
g1(20,67)=(-1);
g1(21,43)=1;
g1(21,44)=(-1);
g1(21,45)=(-1);
g1(22,18)=(-1);
g1(22,44)=1;
g1(22,71)=(-1);
g1(23,19)=(-params(40));
g1(23,45)=1;
g1(23,70)=(-1);
g1(24,39)=(-1);
g1(24,17)=1;
g1(24,43)=(-1);
g1(24,46)=1;
g1(25,15)=(-params(37));
g1(25,41)=1;
g1(25,68)=(-1);
g1(26,16)=(-params(38));
g1(26,42)=1;
g1(26,69)=(-1);
g1(27,60)=(-1);
g1(27,47)=1;

end
