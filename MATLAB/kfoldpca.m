function rr = kfoldpca(X1,X2,Y1,Y2,npca)
% rr = kfoldpca(X1,X2,Y1,Y2,npca)
%
% X1 - Training data matrix of sample group 1
% X2 - Training data matrix of sample group 2
% Y1 - Test data matrix of sample group 1
% Y2 - Test data matrix of sample group 2
% npca  - Number of principal components
%
% Carlos Thomaz, SPMMRC/Nottingham,31/05/2012.

%-------------------------------------------------------------------------------
% Variables initialization
%-------------------------------------------------------------------------------

mX1 = size(X1,1);                       % Number of training samples group 1
mX2 = size(X2,1);                       % Number of training samples group 2
mY1 = size(Y1,1);                       % Number of test samples group 1
mY2 = size(Y2,1);                       % Number of test samples group 2

X = [X1;X2];                            % Total training data matrix
Y = [Y1;Y2];                            % Total test data matrix

m = size(X,1);                          % Total number of training samples
n = size(X,2);                          % Dimensionality of the samples
g = 2;                                  % Number of groups

%-------------------------------------------------------------------------------
% Calculating the hyperplanes
%-------------------------------------------------------------------------------

disp(sprintf('m=%d,n=%d,npca=%d,mX1=%d,mX2=%d,mY1=%d,mY2=%d:',...
              m,n,npca,mX1,mX2,mY1,mY2));

disp('Calculating standard PCA...');
M = mean(X);
for i = 1:size(X,1), X(i,:) = X(i,:) - M; end
[P,Kpca,Vpca] = pca(X,n);

disp('Projecting training data matrix on the standard PCA subspace...');
Xpca = X * P;

disp('Calculating the Zhu weights of the principal components...');
wzhu = zhuw(Xpca,g,[mX1 mX2]);

disp('Calculating the MLDA weights of the principal components...');
wmlda = mlda(Xpca,g,[mX1 mX2],g-1);

disp('Calculating the SVM weights of the principal components...');
%Ysvm = [ones(mX1,1);-ones(mX2,1)];
wsvm = ssvm(Xpca,[ones(mX1,1);-ones(mX2,1)]);

%-------------------------------------------------------------------------------
% Reordering the principal components
%-------------------------------------------------------------------------------

[v,izhu] = sort(abs(wzhu));
[v,imlda] = sort(abs(wmlda));
[v,isvm] = sort(abs(wsvm));

izhu = flipud(izhu);
imlda = flipud(imlda);
isvm = flipud(isvm);

Kstd  = Kpca(1:npca);               % most expressive eigenvalues
Kzhu  = Kpca(izhu(1:npca));         % most discriminant eigenvalues (Zhu)
Kmlda = Kpca(imlda(1:npca));        % most discriminant eigenvalues (MLDA)
Ksvm  = Kpca(isvm(1:npca));         % most discriminant eigenvalues (SVM)

Pstd  = P(:,1:npca);                % most expressive components
Pzhu  = P(:,izhu(1:npca));          % most discriminant components (Zhu)
Pmlda = P(:,imlda(1:npca));         % most discriminant components (MLDA)
Psvm  = P(:,isvm(1:npca));          % most discriminant components (SVM)

%-------------------------------------------------------------------------------
% Classifying the test samples
%-------------------------------------------------------------------------------

rr = zeros(1,4);
Rid = zeros((mY1+mY2),5);
Rid(:,1) = [ones(mY1,1);2.*ones(mY2,1)];

Xpca = X * Pstd;
Ypca = (Y - ones(size(Y,1),1)*M) * Pstd;
[RidX,RidY] = classmah(Kstd,Xpca,Ypca,g,[mX1 mX2]);
Rid(:,2) = RidY;

Xpca = X * Pzhu;
Ypca = (Y - ones(size(Y,1),1)*M) * Pzhu;
[RidX,RidY] = classmah(Kzhu,Xpca,Ypca,g,[mX1 mX2]);
Rid(:,3) = RidY;

Xpca = X * Pmlda;
Ypca = (Y - ones(size(Y,1),1)*M) * Pmlda;
[RidX,RidY] = classmah(Kmlda,Xpca,Ypca,g,[mX1 mX2]);
Rid(:,4) = RidY;

Xpca = X * Psvm;
Ypca = (Y - ones(size(Y,1),1)*M) * Psvm;
[RidX,RidY] = classmah(Ksvm,Xpca,Ypca,g,[mX1 mX2]);
Rid(:,5) = RidY;

rr(1,1) = 1 - sum(Rid(:,1)~=Rid(:,2))/(size(Rid,1));
rr(1,2) = 1 - sum(Rid(:,1)~=Rid(:,3))/(size(Rid,1));
rr(1,3) = 1 - sum(Rid(:,1)~=Rid(:,4))/(size(Rid,1));
rr(1,4) = 1 - sum(Rid(:,1)~=Rid(:,5))/(size(Rid,1));

disp('Done.');

%-------------------------------------------------------------------------------
