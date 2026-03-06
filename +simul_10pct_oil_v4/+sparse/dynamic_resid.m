function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = simul_10pct_oil_v4.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(29, 1);
    residual(1) = (y(30)) - (params(1)*y(1)+params(2)*y(59)+params(3)*y(41)-params(4)*(params(5)*y(33)+(1-params(5))*y(34))+params(6)*y(40)+x(1));
    residual(2) = (y(31)) - (x(2)+y(42)+(params(8)-params(9))*y(50)+(params(10)-params(11))*y(51)+y(30)*params(7)+x(8)+params(12)*y(29));
    residual(3) = (y(35)) - (y(46)+x(4));
    residual(4) = (y(32)) - (y(43)+y(39)+x(3));
    residual(5) = (y(33)) - (y(32)-y(60));
    residual(6) = (y(34)) - (params(45)*y(5)+y(35)-y(6)-(y(31)-y(42))/4);
    residual(7) = (y(36)) - (params(13)*y(7)-params(14)*y(11)-y(1)*params(15)+params(16)*y(12)+x(5));
    residual(8) = (y(38)) - ((1-params(17))*params(18)+params(17)*y(9));
    residual(9) = (y(37)) - (y(36)+y(38));
    residual(10) = (y(39)) - (params(19)*(y(38)-y(37))+x(6));
    residual(11) = (y(40)) - (y(11)*params(44)+x(7));
    residual(12) = (y(41)) - (y(12)*params(20)+params(21)*y(70)-params(22)*y(44)+params(23)*y(45)+params(24)*y(47)+params(25)*y(56)+x(9));
    residual(13) = (y(42)) - (params(26)*y(13)+(1-params(26))*y(71)+y(41)*params(27)+params(28)*(y(45)-y(16))+y(50)*params(29)+y(51)*params(30)+x(10));
    residual(14) = (y(43)) - (params(31)*y(14)+(1-params(31))*(y(71)*params(32)+y(41)*params(33))+x(11));
    residual(15) = (y(44)) - (y(43)-y(71));
    residual(16) = (y(46)) - (params(35)*y(17)+(1-params(35))*y(75)-(y(43)-y(49))/4+x(12));
    residual(17) = (y(45)) - (params(45)*y(16)+y(46)-y(17)-(y(42)-y(48))/4);
    residual(18) = (y(47)) - (params(36)*y(18)+x(13));
    residual(19) = (y(48)) - (params(37)*y(19)+x(14));
    residual(20) = (y(49)) - (params(38)*y(20)+(1-params(38))*(y(48)*1.5+y(47)*0.5)+x(15));
    residual(21) = (y(54)) - (y(56)+y(55));
    residual(22) = (y(55)) - (y(26)+x(19));
    residual(23) = (y(56)) - (params(42)*y(27)+x(18));
    residual(24) = (y(57)) - (y(48)+y(54)-y(25));
    residual(25) = (y(52)) - (params(39)*y(23)+x(16));
    residual(26) = (y(50)) - (y(52)-y(23));
    residual(27) = (y(53)) - (params(40)*y(24)+y(52)*params(43)+x(17));
    residual(28) = (y(51)) - (y(53)-y(24));
    residual(29) = (y(58)) - (x(8));
end
