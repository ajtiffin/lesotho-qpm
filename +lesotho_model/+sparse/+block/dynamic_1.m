function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(32)=params(16)*y(9);
  y(34)=params(37)*y(11)+x(7);
  y(41)=params(32)*y(18)+x(13);
  y(42)=params(33)*y(19)+x(14);
  y(43)=params(34)*y(20)+(1-params(34))*(y(42)*1.5+y(41)*0.5)+x(15);
  y(44)=params(35)*y(21)+x(16);
  y(45)=params(36)*y(22)+x(17);
  y(46)=x(8);
end
