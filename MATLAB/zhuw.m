function [vb,db]=zhuw(X,C,nh)
% [vb,db] = zhuw(X,C,nh)
%
% Zhu and Aleix Martinez hyperplane based on the between scatter matrix used
% to align the principal components on the corr_LDA.m code.
%
% input:
% C  -- number of classes
% X  -- n-by-p training data (n and p are the number of samples and features)
% nh -- 1-by-C matrix indicating the number of samples for each class
%
% output:
% vb -- the Zhu and Martinez eigenvectors (between covariance matrix)
% db -- the corresponding eigenvalues
%
% Copyrighted code
% (c) Manli Zhu & Aleix M Martinez
% **** Original code (corr_LDA.m) changed by Carlos Thomaz on 10-aug-2009

n = size(X,1);
p = size(X,2);

start = 0; 
for i=1: C
    temp = X(start+1:start+nh(i),:);
    classmean(i,:)=mean(temp,1);
    start = sum(nh(1:i));
end
clear temp;

%calculate the covariance matrix of the classmean;
meanx = mean(X);
SigmaB = zeros(p,p);
for i=1:C
   temp = classmean(i,:)-meanx;
   SigmaB = SigmaB + temp'*temp*nh(i);
end
SigmaB=SigmaB/n;
clear temp;

opts.disp=0;
rankB=rank(SigmaB);
[vb,db]=eigs(SigmaB,rankB,'LM',opts);
db = diag(db)';
