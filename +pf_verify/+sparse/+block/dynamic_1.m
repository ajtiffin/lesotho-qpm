function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(38)=(1-params(17))*params(18)+params(17)*y(9);
  y(40)=y(11)*params(44)+x(7);
  y(47)=params(36)*y(18)+x(13);
  y(48)=params(37)*y(19)+x(14);
  y(49)=params(38)*y(20)+(1-params(38))*(y(48)*1.5+y(47)*0.5)+x(15);
  y(55)=y(26)+x(19);
  y(56)=params(42)*y(27)+x(18);
  y(52)=params(39)*y(23)+x(16);
  y(50)=y(52)-y(23);
  y(53)=params(40)*y(24)+y(52)*params(43)+x(17);
  y(51)=y(53)-y(24);
  y(58)=x(8);
  y(54)=y(56)+y(55);
  y(57)=y(48)+y(54)-y(25);
end
