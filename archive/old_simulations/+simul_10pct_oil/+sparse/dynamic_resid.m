function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = simul_10pct_oil.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(27, 1);
    residual(1) = (y(28)) - (params(1)*y(1)+params(2)*y(55)+params(3)*y(39)-params(4)*(params(5)*y(31)+(1-params(5))*y(32))+params(6)*y(38)+x(1));
    residual(2) = (y(29)) - (x(2)+y(40)+(params(8)-params(9))*y(48)+(params(10)-params(11))*y(49)+y(28)*params(7)+x(8)+params(12)*y(27));
    residual(3) = (y(33)) - (y(44)+x(4));
    residual(4) = (y(30)) - (y(41)+y(37)+x(3));
    residual(5) = (y(31)) - (y(30)-y(56));
    residual(6) = (y(32)) - (params(42)*y(5)+y(33)-y(6)-(y(29)-y(40))/4);
    residual(7) = (y(34)) - (params(13)*y(7)-params(14)*y(11)-y(1)*params(15)+params(16)*y(12)+x(5));
    residual(8) = (y(36)) - ((1-params(17))*params(18)+params(17)*y(9));
    residual(9) = (y(35)) - (y(34)+y(36));
    residual(10) = (y(37)) - (params(19)*(y(36)-y(35))+x(6));
    residual(11) = (y(38)) - (y(11)*params(41)+x(7));
    residual(12) = (y(39)) - (y(12)*params(20)+params(21)*y(66)-params(22)*y(42)+params(23)*y(43)+params(24)*y(45)+params(25)*y(52)+x(9));
    residual(13) = (y(40)) - (params(26)*y(13)+(1-params(26))*y(67)+y(39)*params(27)+params(28)*(y(43)-y(16))+x(10));
    residual(14) = (y(41)) - (params(29)*y(14)+(1-params(29))*(y(67)*params(30)+y(39)*params(31))+x(11));
    residual(15) = (y(42)) - (y(41)-y(67));
    residual(16) = (y(44)) - (params(33)*y(17)+(1-params(33))*y(71)-(y(41)-y(47))/4+x(12));
    residual(17) = (y(43)) - (params(42)*y(16)+y(44)-y(17)-(y(40)-y(46))/4);
    residual(18) = (y(45)) - (params(34)*y(18)+x(13));
    residual(19) = (y(46)) - (params(35)*y(19)+x(14));
    residual(20) = (y(47)) - (params(36)*y(20)+(1-params(36))*(y(46)*1.5+y(45)*0.5)+x(15));
    residual(21) = (y(50)) - (y(52)+y(51));
    residual(22) = (y(51)) - (y(24)+x(19));
    residual(23) = (y(52)) - (params(40)*y(25)+x(18));
    residual(24) = (y(53)) - (y(46)+y(50)-y(23));
    residual(25) = (y(48)) - (params(37)*y(21)+x(16));
    residual(26) = (y(49)) - (params(38)*y(22)+x(17));
    residual(27) = (y(54)) - (x(8));
end
