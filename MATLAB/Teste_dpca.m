%% Load Data

X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');

% 

%% ========Extrai informações dos dados (Para plotar pca/mlda walk)====

n = (min(size(X))-1);               %Calcula a máxima quantidade de PCs possíveis de extrair (Nsamples - 1)
dim = sqrt(max(size(X)));           %Se a imagem for quadrada, usar esse dim
        
    %Caso a Imagem não seja quadrada:
dim = 250;                

%
%% ======Divisão das samples para o MLDA===

SamplesSimples = [19 20]; %Numero de participantes = 39
%=======
SamplesSimples = [19 20]; %Numero de participantes = 39

Samples = SamplesSimples*40;

%
%% ========Normalização dos dados==========

[lin, col] = size(X); dnorm = [];
for k = 1:lin
    dnorm(k,:) = X(k,:) - mean(X);
end

%% Calculo dos d-pca

%Dados de treino grupo 1:
X1 = dnorm(1:18*40,:);
X2 = dnorm(19*40+1:38*40,:);

Y1 = dnorm(18*40+1:19*40,:);
Y2 = dnorm(38*40:end,:);

npca = size(X1,1) +  size(X2,1) - 1;
[rr, Pstd, Kstd, Pzhu, Kzhu, Pmlda, Kmlda, Psvm, Ksvm] = kfoldpca(X1,X2,Y1,Y2,npca);
%% 
%Vector training set
Xp = [X1;X2]; 
%%
pca_walk(Xp, Kmlda, Pmlda, dim, 5)
