function [y, T, residual, g1] = static_11(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(1, 1);
  residual(1)=(y(17))-(y(17)*params(31)+y(17)*(1-params(31))-(y(14)-y(20))/4+x(12));
if nargout > 3
    g1_v = NaN(0, 1);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 1, 1);
end
end
