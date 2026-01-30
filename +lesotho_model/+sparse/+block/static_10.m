function [y, T, residual, g1] = static_10(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(8, 1);
  residual(1)=(y(8))-(y(7)+y(9));
  residual(2)=(y(10))-(params(18)*(y(9)-y(8))+x(6));
  residual(3)=(y(2))-(x(2)+y(13)+(params(8)-params(9))*y(21)+(params(10)-params(11))*y(22)+y(1)*params(7)+x(8)+params(12)*y(23));
  residual(4)=(y(7))-(y(7)*params(13)-y(11)*params(14)-y(5)*params(15)+x(5));
  residual(5)=(y(1))-(y(1)*params(1)+y(1)*params(2)+params(3)*y(12)-params(4)*(params(5)*y(4)+(1-params(5))*y(5))+params(6)*y(11)+x(1));
  residual(6)=(y(3))-(y(14)+y(10)+x(3));
  residual(7)=(y(4))-(y(3)-y(2));
  residual(8)=(y(5))-(y(5)*params(38)-(y(2)-y(13))/4);
if nargout > 3
    g1_v = NaN(18, 1);
g1_v(1)=1;
g1_v(2)=params(18);
g1_v(3)=1;
g1_v(4)=(-1);
g1_v(5)=1;
g1_v(6)=1;
g1_v(7)=0.25;
g1_v(8)=(-1);
g1_v(9)=1-params(13);
g1_v(10)=(-params(7));
g1_v(11)=1-(params(1)+params(2));
g1_v(12)=1;
g1_v(13)=(-1);
g1_v(14)=params(4)*params(5);
g1_v(15)=1;
g1_v(16)=params(15);
g1_v(17)=params(4)*(1-params(5));
g1_v(18)=1-params(38);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 8, 8);
end
end
