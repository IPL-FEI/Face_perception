function d = distMah(K,X,Y)
% distMah(K,X,Y) = sqrt(sum(1/ki*((xi-yi)^2)))
% Mahalanobis distante between vector X and vector Y. This distance takes both
% differences in axis lengths and the correlatedness of axes into account.
%
% K - Eigenvalues components (column vector).
% X - line vector.
% Y - line vector.
%
% Carlos Thomaz, DEE-PUC/RIO, 19/03/1998.

%-------------------------------------------------------------------------------
% Validation
%-------------------------------------------------------------------------------

if (size(X,1) > 1), error('X must be a line vector.'), end
if (size(Y,1) > 1), error('Y must be a line vector.'), end
if (size(X,2) ~= size(Y,2)), error('X and Y must have same # cols.'), end
if (size(K,1) <  size(X,2)), error('K #lins must equal/greater X #cols.'), end

%-------------------------------------------------------------------------------
% Computation
%-------------------------------------------------------------------------------

d = 0;
for i = 1:size(X,2), d = d +((1/K(i,1))*((X(1,i)-Y(1,i))^2)); end
d = sqrt(d);

%-------------------------------------------------------------------------------
