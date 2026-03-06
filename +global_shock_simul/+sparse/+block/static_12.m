function [y, T, residual, g1] = static_12(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(5, 1);
  residual(1)=(y(13))-(y(13)*params(26)+y(13)*(1-params(26))+y(12)*params(27)+x(10));
  residual(2)=(y(14))-(y(14)*params(29)+(1-params(29))*(y(13)*params(30)+y(12)*params(31))+x(11));
  residual(3)=(y(15))-(y(14)-y(13));
  residual(4)=(y(16))-(params(42)*y(16)-(y(13)-y(19))/4);
  residual(5)=(y(12))-(y(12)*params(20)+y(12)*params(21)-params(22)*y(15)+params(23)*y(16)+params(24)*y(18)+params(25)*y(25)+x(9));
if nargout > 3
    g1_v = NaN(12, 1);
g1_v(1)=(-params(27));
g1_v(2)=(-((1-params(29))*params(31)));
g1_v(3)=1-(params(20)+params(21));
g1_v(4)=1-params(29);
g1_v(5)=(-1);
g1_v(6)=1;
g1_v(7)=params(22);
g1_v(8)=(-((1-params(29))*params(30)));
g1_v(9)=1;
g1_v(10)=0.25;
g1_v(11)=1-params(42);
g1_v(12)=(-params(23));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 5, 5);
end
end
