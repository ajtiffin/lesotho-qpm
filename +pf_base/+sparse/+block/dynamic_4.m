function [y, T, residual, g1] = dynamic_4(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(5, 1);
  y(37)=y(36)+y(38);
  y(39)=params(19)*(y(38)-y(37))+x(6);
  y(32)=y(43)+y(39)+x(3);
  residual(1)=(y(33))-(y(32)-y(60));
  residual(2)=(y(34))-(params(45)*y(5)+y(35)-y(6)-(y(31)-y(42))/4);
  residual(3)=(y(36))-(params(13)*y(7)-params(14)*y(11)-y(1)*params(15)+params(16)*y(12)+x(5));
  residual(4)=(y(30))-(params(1)*y(1)+params(2)*y(59)+params(3)*y(41)-params(4)*(params(5)*y(33)+(1-params(5))*y(34))+params(6)*y(40)+x(1));
  residual(5)=(y(31))-(x(2)+y(42)+(params(8)-params(9))*y(50)+(params(10)-params(11))*y(51)+y(30)*params(7)+x(8)+params(12)*y(29));
if nargout > 3
    g1_v = NaN(16, 1);
g1_v(1)=(-params(45));
g1_v(2)=(-params(13));
g1_v(3)=params(15);
g1_v(4)=(-params(1));
g1_v(5)=1;
g1_v(6)=params(4)*params(5);
g1_v(7)=1;
g1_v(8)=params(4)*(1-params(5));
g1_v(9)=params(19);
g1_v(10)=1;
g1_v(11)=1;
g1_v(12)=(-params(7));
g1_v(13)=0.25;
g1_v(14)=1;
g1_v(15)=(-params(2));
g1_v(16)=1;
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 5, 15);
end
end
