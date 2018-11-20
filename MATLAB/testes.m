close all
clear all
clc
%% Parametros

Samples = [400 400];

dim = 250;


%% DADO
% 
X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');

%% Calculando os Labels:
Nlabels = [ones(Samples(1),1); 2*ones(Samples(2),1)];

%% Quantidade de PCs
n = (min(size(X))-1);               %Calcula a máxima quantidade de PCs possíveis de extrair (Nsamples - 1)
%% Normalização
[lin, col] = size(X); dnorm = [];
for k = 1:lin
    dnorm(k,:) = X(k,:) - mean(X);
end
%% PCA
[Ppca, Kpca, Vpca] = ctPCA(dnorm, n);
%% MLDA
% USANDO TODOS OS DADOS PARA TREINAMENTO
[Pmlda,Kmlda,Vmlda] = ctmlda(dnorm*Ppca, 2, Samples, 1);
Z = dnorm*Ppca*Pmlda;

%% Metodos

% Graph_mlda_2D(Z,X)
pca_walk(X, Kpca, Ppca, dim, 7)
mlda_walk(Pmlda, Nlabels, dim, Ppca, X, Z)
%% PLOTS
%Unfinished...