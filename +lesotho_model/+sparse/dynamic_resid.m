function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = lesotho_model.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(23, 1);
    residual(1) = (y(24)) - (params(1)*y(1)+params(2)*y(47)+params(3)*y(35)-params(4)*(params(5)*y(27)+(1-params(5))*y(28))+params(6)*y(34)+x(1));
    residual(2) = (y(25)) - (x(2)+y(36)+(params(8)-params(9))*y(44)+(params(10)-params(11))*y(45)+y(24)*params(7)+x(8)+params(12)*y(23));
    residual(3) = (y(29)) - (y(40)+x(4));
    residual(4) = (y(26)) - (y(37)+y(33)+x(3));
    residual(5) = (y(27)) - (y(26)-y(48));
    residual(6) = (y(28)) - (params(38)*y(5)+y(29)-y(6)-(y(25)-y(36))/4);
    residual(7) = (y(30)) - (params(13)*y(7)-y(34)*params(14)-y(28)*params(15)+x(5));
    residual(8) = (y(32)) - (params(16)*y(9));
    residual(9) = (y(31)) - (y(30)+y(32));
    residual(10) = (y(33)) - (params(18)*(y(32)-y(31))+x(6));
    residual(11) = (y(34)) - (params(37)*y(11)+x(7));
    residual(12) = (y(35)) - (params(19)*y(12)+params(20)*y(58)-params(21)*y(38)+params(22)*y(39)+params(23)*y(41)+x(9));
    residual(13) = (y(36)) - (params(24)*y(13)+(1-params(24))*y(59)+y(35)*params(25)+params(26)*(y(39)-y(16))+x(10));
    residual(14) = (y(37)) - (params(27)*y(14)+(1-params(27))*(y(59)*params(28)+y(35)*params(29))+x(11));
    residual(15) = (y(38)) - (y(37)-y(59));
    residual(16) = (y(40)) - (params(31)*y(17)+(1-params(31))*y(63)-(y(37)-y(43))/4+x(12));
    residual(17) = (y(39)) - (params(38)*y(16)+y(40)-y(17)-(y(36)-y(42))/4);
    residual(18) = (y(41)) - (params(32)*y(18)+x(13));
    residual(19) = (y(42)) - (params(33)*y(19)+x(14));
    residual(20) = (y(43)) - (params(34)*y(20)+(1-params(34))*(y(42)*1.5+y(41)*0.5)+x(15));
    residual(21) = (y(44)) - (params(35)*y(21)+x(16));
    residual(22) = (y(45)) - (params(36)*y(22)+x(17));
    residual(23) = (y(46)) - (x(8));
end
