close all, clear all, clc

% Importando os dados
% X = csvread ('L_pcaOrdenadoTODOS.csv')
X = csvread('~/Dropbox/Dados/VETOR_IMAGENS/VECTOR_IMAGE_Ordenado_INTC_Intacta Baixo Erro_GENERO.csv');
n = (min(size(X))-1); % m�ximo de PCs poss�veis de extrair
dim = sqrt(max(size(X)));

[lin, col] = size(X); dnorm = [];
for k = 1:lin
    dnorm(k,:) = X(k,:) - mean(X);
end

[Ppca, Kpca, Vpca] = ctPCA(dnorm, n); % 1�argumento: Matriz com m�dia zero

pca_walk(X, Kpca, Ppca, dim, 5)

[Pmlda,Kmlda,Vmlda] = ctmlda(dnorm*Ppca, 2,[15 10], 1); % Calcula o MLDA

mlda_walk(Pmlda, [1, 2], dim, Ppca, X, dnorm*Ppca*Pmlda)
disp('fim')


