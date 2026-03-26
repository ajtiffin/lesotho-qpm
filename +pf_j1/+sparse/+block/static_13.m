function [y, T, residual, g1] = static_13(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(5, 1);
  residual(1)=(y(15))-(y(14)-y(13));
  residual(2)=(y(12))-(y(12)*params(20)+y(12)*params(21)-params(22)*y(15)+params(23)*y(16)+params(24)*y(18)+params(25)*y(27)+x(9));
  residual(3)=(y(16))-(params(45)*y(16)-(y(13)-y(19))/4);
  residual(4)=(y(13))-(y(13)*params(26)+y(13)*(1-params(26))+y(12)*params(27)+y(21)*params(29)+y(22)*params(30)+x(10));
  residual(5)=(y(14))-(y(14)*params(31)+(1-params(31))*(y(13)*params(32)+y(12)*params(33))+x(11));
if nargout > 3
    g1_v = NaN(12, 1);
g1_v(1)=1;
g1_v(2)=params(22);
g1_v(3)=(-params(23));
g1_v(4)=1-params(45);
g1_v(5)=1;
g1_v(6)=0.25;
g1_v(7)=(-((1-params(31))*params(32)));
g1_v(8)=1-(params(20)+params(21));
g1_v(9)=(-params(27));
g1_v(10)=(-((1-params(31))*params(33)));
g1_v(11)=(-1);
g1_v(12)=1-params(31);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 5, 5);
end
end
