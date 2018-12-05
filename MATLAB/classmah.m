function [RidX,RidY] = classmah(K,X,Y,ns,nt)
% [RidX,RidY] = classmah(K,X,Y,ns,nt,nv)
% Mahalanobis distance classifier (MAH), that is, QDF+Identity
%
% Output
% RidX  - Recognition id of the training samples.
% RidY  - Recognition id of the test samples.
%
% Input 
% K  - Eigenvalues components (column vector).
% X  - Matrix of training set, whose each row represents a training sample.
% Y  - Matrix of testing set, whose each row represents a testing sample.
% ns - Number of distinct subjects (groups) readen.
% nt - Number of training samples of each class.
%
% Carlos Thomaz, DoC-IC/London, 18/feb/2004.

%-------------------------------------------------------------------------------

g = 0;
nx = size(X,1);
ny = size(Y,1);

Mg = meang(X,ns,nt);

for i = 1 : nx
     dm= inf;
     x = X(i,:);
     for j = 1 : ns
          m = Mg(j,:);
          d = distmah(K,x,m);
          if (d < dm), dm=d; g=j; end
     end
     RidX(i,:) = g;
end

for i = 1 : ny
     dm= inf;
     y = Y(i,:);
     for j = 1 : ns
          m = Mg(j,:);
          d = distmah(K,y,m);
          if (d < dm), dm=d; g=j; end
     end
     RidY(i,:) = g;
end

%-------------------------------------------------------------------------------
