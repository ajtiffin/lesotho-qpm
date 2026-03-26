function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(6, 1);
  residual(1)=(y(44))-(y(43)-y(71));
  residual(2)=(y(45))-(params(45)*y(16)+y(46)-y(17)-(y(42)-y(48))/4);
  residual(3)=(y(43))-(params(31)*y(14)+(1-params(31))*(y(71)*params(32)+y(41)*params(33))+x(11));
  residual(4)=(y(46))-(params(35)*y(17)+(1-params(35))*y(75)-(y(43)-y(49))/4+x(12));
  residual(5)=(y(42))-(params(26)*y(13)+(1-params(26))*y(71)+y(41)*params(27)+params(28)*(y(45)-y(16))+y(50)*params(29)+y(51)*params(30)+x(10));
  residual(6)=(y(41))-(y(12)*params(20)+params(21)*y(70)-params(22)*y(44)+params(23)*y(45)+params(24)*y(47)+params(25)*y(56)+x(9));
if nargout > 3
    g1_v = NaN(27, 1);
g1_v(1)=(-params(45));
g1_v(2)=params(28);
g1_v(3)=(-params(31));
g1_v(4)=1;
g1_v(5)=(-params(35));
g1_v(6)=(-params(26));
g1_v(7)=(-params(20));
g1_v(8)=1;
g1_v(9)=params(22);
g1_v(10)=1;
g1_v(11)=(-params(28));
g1_v(12)=(-params(23));
g1_v(13)=(-1);
g1_v(14)=1;
g1_v(15)=0.25;
g1_v(16)=(-1);
g1_v(17)=1;
g1_v(18)=0.25;
g1_v(19)=1;
g1_v(20)=(-((1-params(31))*params(33)));
g1_v(21)=(-params(27));
g1_v(22)=1;
g1_v(23)=(-(1-params(35)));
g1_v(24)=1;
g1_v(25)=(-((1-params(31))*params(32)));
g1_v(26)=(-(1-params(26)));
g1_v(27)=(-params(21));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 6, 18);
end
end
