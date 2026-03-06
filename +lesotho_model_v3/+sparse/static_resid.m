function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = lesotho_model_v3.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(27, 1);
    residual(1) = (y(1)) - (y(1)*params(1)+y(1)*params(2)+params(3)*y(12)-params(4)*(params(5)*y(4)+(1-params(5))*y(5))+params(6)*y(11)+x(1));
    residual(2) = (y(2)) - (x(2)+y(13)+(params(8)-params(9))*y(21)+(params(10)-params(11))*y(22)+y(1)*params(7)+x(8)+params(12)*y(27));
    residual(3) = (y(6)) - (y(17)+x(4));
    residual(4) = (y(3)) - (y(14)+y(10)+x(3));
    residual(5) = (y(4)) - (y(3)-y(2));
    residual(6) = (y(5)) - (y(5)*params(42)-(y(2)-y(13))/4);
    residual(7) = (y(7)) - (y(7)*params(13)-y(11)*params(14)-y(1)*params(15)+y(12)*params(16)+x(5));
    residual(8) = (y(9)) - ((1-params(17))*params(18)+y(9)*params(17));
    residual(9) = (y(8)) - (y(7)+y(9));
    residual(10) = (y(10)) - (params(19)*(y(9)-y(8))+x(6));
    residual(11) = (y(11)) - (y(11)*params(41)+x(7));
    residual(12) = (y(12)) - (y(12)*params(20)+y(12)*params(21)-params(22)*y(15)+params(23)*y(16)+params(24)*y(18)+params(25)*y(25)+x(9));
    residual(13) = (y(13)) - (y(13)*params(26)+y(13)*(1-params(26))+y(12)*params(27)+x(10));
    residual(14) = (y(14)) - (y(14)*params(29)+(1-params(29))*(y(13)*params(30)+y(12)*params(31))+x(11));
    residual(15) = (y(15)) - (y(14)-y(13));
    residual(16) = (y(17)) - (y(17)*params(33)+y(17)*(1-params(33))-(y(14)-y(20))/4+x(12));
    residual(17) = (y(16)) - (params(42)*y(16)-(y(13)-y(19))/4);
    residual(18) = (y(18)) - (y(18)*params(34)+x(13));
    residual(19) = (y(19)) - (y(19)*params(35)+x(14));
    residual(20) = (y(20)) - (y(20)*params(36)+(1-params(36))*(y(19)*1.5+y(18)*0.5)+x(15));
    residual(21) = (y(23)) - (y(25)+y(24));
    residual(22) = (y(24)) - (y(24)+x(19));
    residual(23) = (y(25)) - (y(25)*params(40)+x(18));
    residual(24) = (y(26)) - (y(19));
    residual(25) = (y(21)) - (y(21)*params(37)+x(16));
    residual(26) = (y(22)) - (y(22)*params(38)+x(17));
    residual(27) = (y(27)) - (x(8));
end
