function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(6, 1);
  residual(1)=(y(38))-(y(37)-y(59));
  residual(2)=(y(37))-(params(27)*y(14)+(1-params(27))*(y(59)*params(28)+y(35)*params(29))+x(11));
  residual(3)=(y(39))-(params(38)*y(16)+y(40)-y(17)-(y(36)-y(42))/4);
  residual(4)=(y(35))-(params(19)*y(12)+params(20)*y(58)-params(21)*y(38)+params(22)*y(39)+params(23)*y(41)+x(9));
  residual(5)=(y(36))-(params(24)*y(13)+(1-params(24))*y(59)+y(35)*params(25)+params(26)*(y(39)-y(16))+x(10));
  residual(6)=(y(40))-(params(31)*y(17)+(1-params(31))*y(63)-(y(37)-y(43))/4+x(12));
if nargout > 3
    g1_v = NaN(27, 1);
g1_v(1)=(-params(27));
g1_v(2)=(-params(38));
g1_v(3)=params(26);
g1_v(4)=(-params(19));
g1_v(5)=(-params(24));
g1_v(6)=1;
g1_v(7)=(-params(31));
g1_v(8)=1;
g1_v(9)=params(21);
g1_v(10)=(-1);
g1_v(11)=1;
g1_v(12)=0.25;
g1_v(13)=1;
g1_v(14)=(-params(22));
g1_v(15)=(-params(26));
g1_v(16)=(-((1-params(27))*params(29)));
g1_v(17)=1;
g1_v(18)=(-params(25));
g1_v(19)=0.25;
g1_v(20)=1;
g1_v(21)=(-1);
g1_v(22)=1;
g1_v(23)=(-params(20));
g1_v(24)=1;
g1_v(25)=(-((1-params(27))*params(28)));
g1_v(26)=(-(1-params(24)));
g1_v(27)=(-(1-params(31)));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 6, 18);
end
end
