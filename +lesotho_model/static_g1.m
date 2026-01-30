function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
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
%   g1
%

if T_flag
    T = lesotho_model.static_g1_tt(T, y, x, params);
end
g1 = zeros(23, 23);
g1(1,1)=1-(params(1)+params(2));
g1(1,4)=params(4)*params(5);
g1(1,5)=params(4)*(1-params(5));
g1(1,11)=(-params(6));
g1(1,12)=(-params(3));
g1(2,1)=(-params(7));
g1(2,2)=1;
g1(2,13)=(-1);
g1(2,21)=(-(params(8)-params(9)));
g1(2,22)=(-(params(10)-params(11)));
g1(2,23)=(-params(12));
g1(3,6)=1;
g1(3,17)=(-1);
g1(4,3)=1;
g1(4,10)=(-1);
g1(4,14)=(-1);
g1(5,2)=1;
g1(5,3)=(-1);
g1(5,4)=1;
g1(6,2)=0.25;
g1(6,5)=1-params(38);
g1(6,13)=(-0.25);
g1(7,5)=params(15);
g1(7,7)=1-params(13);
g1(7,11)=params(14);
g1(8,9)=1-params(16);
g1(9,7)=(-1);
g1(9,8)=1;
g1(9,9)=(-1);
g1(10,8)=params(18);
g1(10,9)=(-params(18));
g1(10,10)=1;
g1(11,11)=1-params(37);
g1(12,12)=1-(params(19)+params(20));
g1(12,15)=params(21);
g1(12,16)=(-params(22));
g1(12,18)=(-params(23));
g1(13,12)=(-params(25));
g1(14,12)=(-((1-params(27))*params(29)));
g1(14,13)=(-((1-params(27))*params(28)));
g1(14,14)=1-params(27);
g1(15,13)=1;
g1(15,14)=(-1);
g1(15,15)=1;
g1(16,14)=0.25;
g1(16,20)=(-0.25);
g1(17,13)=0.25;
g1(17,16)=1-params(38);
g1(17,19)=(-0.25);
g1(18,18)=1-params(32);
g1(19,19)=1-params(33);
g1(20,18)=(-((1-params(34))*0.5));
g1(20,19)=(-((1-params(34))*1.5));
g1(20,20)=1-params(34);
g1(21,21)=1-params(35);
g1(22,22)=1-params(36);
g1(23,23)=1;

end
