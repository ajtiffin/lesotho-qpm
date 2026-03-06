function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(6, 1);
  residual(1)=(y(42))-(y(41)-y(67));
  residual(2)=(y(41))-(params(29)*y(14)+(1-params(29))*(y(67)*params(30)+y(39)*params(31))+x(11));
  residual(3)=(y(43))-(params(42)*y(16)+y(44)-y(17)-(y(40)-y(46))/4);
  residual(4)=(y(40))-(params(26)*y(13)+(1-params(26))*y(67)+y(39)*params(27)+params(28)*(y(43)-y(16))+x(10));
  residual(5)=(y(44))-(params(33)*y(17)+(1-params(33))*y(71)-(y(41)-y(47))/4+x(12));
  residual(6)=(y(39))-(y(12)*params(20)+params(21)*y(66)-params(22)*y(42)+params(23)*y(43)+params(24)*y(45)+params(25)*y(52)+x(9));
if nargout > 3
    g1_v = NaN(27, 1);
g1_v(1)=(-params(29));
g1_v(2)=(-params(42));
g1_v(3)=params(28);
g1_v(4)=(-params(26));
g1_v(5)=1;
g1_v(6)=(-params(33));
g1_v(7)=(-params(20));
g1_v(8)=1;
g1_v(9)=params(22);
g1_v(10)=(-1);
g1_v(11)=1;
g1_v(12)=0.25;
g1_v(13)=1;
g1_v(14)=(-params(28));
g1_v(15)=(-params(23));
g1_v(16)=0.25;
g1_v(17)=1;
g1_v(18)=(-1);
g1_v(19)=1;
g1_v(20)=(-((1-params(29))*params(31)));
g1_v(21)=(-params(27));
g1_v(22)=1;
g1_v(23)=1;
g1_v(24)=(-((1-params(29))*params(30)));
g1_v(25)=(-(1-params(26)));
g1_v(26)=(-(1-params(33)));
g1_v(27)=(-params(21));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 6, 18);
end
end
