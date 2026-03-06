function [y, T, residual, g1] = static_9(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(5, 1);
  residual(1)=(y(12))-(y(12)*params(19)+y(12)*params(20)-params(21)*y(15)+params(22)*y(16)+params(23)*y(18)+x(9));
  residual(2)=(y(13))-(y(13)*params(24)+y(13)*(1-params(24))+y(12)*params(25)+x(10));
  residual(3)=(y(14))-(y(14)*params(27)+(1-params(27))*(y(13)*params(28)+y(12)*params(29))+x(11));
  residual(4)=(y(15))-(y(14)-y(13));
  residual(5)=(y(16))-(params(38)*y(16)-(y(13)-y(19))/4);
if nargout > 3
    g1_v = NaN(12, 1);
g1_v(1)=(-params(22));
g1_v(2)=1-params(38);
g1_v(3)=1-(params(19)+params(20));
g1_v(4)=(-params(25));
g1_v(5)=(-((1-params(27))*params(29)));
g1_v(6)=1-params(27);
g1_v(7)=(-1);
g1_v(8)=params(21);
g1_v(9)=1;
g1_v(10)=(-((1-params(27))*params(28)));
g1_v(11)=1;
g1_v(12)=0.25;
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 5, 5);
end
end
