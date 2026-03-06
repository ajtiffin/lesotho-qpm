function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(36)=(1-params(17))*params(18)+params(17)*y(9);
  y(38)=y(11)*params(41)+x(7);
  y(45)=params(34)*y(18)+x(13);
  y(46)=params(35)*y(19)+x(14);
  y(47)=params(36)*y(20)+(1-params(36))*(y(46)*1.5+y(45)*0.5)+x(15);
  y(51)=y(24)+x(19);
  y(52)=params(40)*y(25)+x(18);
  y(48)=params(37)*y(21)+x(16);
  y(49)=params(38)*y(22)+x(17);
  y(54)=x(8);
  y(50)=y(52)+y(51);
  y(53)=y(46)+y(50)-y(23);
end
