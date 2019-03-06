%Experimento para Journal
close all, clear all, clc

%% Data

     X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_BxR_GFMT.csv');
%      X = csvread ('~/Dropbox/Journal/Individuals/imgCONCATENADA_GOOD_GFMT.csv');
%      X = csvread ('~/Dropbox/Journal/Individuals/30_GFMT.csv');
  disp('Data ready')
% 
%% ========Extrai informações dos dados====

n = (min(size(X))-1);               %Calcula a máxima quantidade de PCs possíveis de extrair (Nsamples - 1)
dim = sqrt(max(size(X)));           %Se a imagem for quadrada, usar esse dim
        
    %Caso a Imagem não seja quadrada:
dim = 250;                

%
%% ======Divisão das samples para o MLDA===

SamplesSimples = [19 20]; %Numero de participantes = 39
%=======
SamplesSimples = [10 10]; %Numero de participantes = 39

Samples = SamplesSimples*40;

%
%% ========Normalização dos dados==========

[lin, col] = size(X); dnorm = [];
for k = 1:lin
    dnorm(k,:) = X(k,:) - mean(X);
end

%
%% ================PCA=====================

[Ppca, Kpca, Vpca] = ctPCA(dnorm, n); % 1�argumento: Matriz com m�dia zero
disp(Vpca(1))
%
%% ================MLDA====================


[Pmlda,Kmlda,Vmlda] = ctmlda(dnorm*Ppca, 2,Samples, 1); % Calcula o MLDA

%
%% ============Navegação PCA===============
%       (Data, K1, P1,dim, n)
pca_walk(X, Kpca, Ppca, dim, 1)

%
%% ===========Navegação MLDA===============

 mlda_walk(Pmlda, Samples, dim, Ppca, X, dnorm*Ppca*Pmlda)

%
%% ==============FINAL=====================
disp('finalizado')

%% Treino com 100% dos dados
Y = dnorm * Ppca * Pmlda; % Projeta os dados nos Autovetores P
        
    figure,
    %title('Proje��o dos dados no eixo de discriminancia do MLDA usando Todos os dados')
    %xlabel('Eixo de proje��o')
    p1=plot(Y(1:Samples(1)),0,'ro', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    p4=plot(Y(Samples(1)+1:end),0,'kx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % BOM
%     legend([p1(1), p2(1), p3(1), p4(1)],'1quartil','2quartil','3quartil','4quartil');
    mQ1 = mean(Y(1:Samples(1))); mQ4 = mean(Y(Samples(1)+1:end));
    plot(mQ1,0,'rx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
%     plot(mQ2,0,'bx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
%     plot(mQ3,0,'gx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
    plot(mQ4,0,'kx', 'MarkerSize', 30, 'LineWidth', 1); hold off;


Predicted = erclassEuclidiandist(Y, mQ1, mQ4);
Actual = [zeros(Samples(1),1); ones(Samples(2),1)];
EVAL = Evaluate(Actual,Predicted)
%% First PCA component
PCA_1 = dnorm * Ppca(:,1);
% getting first pca component
figure,
p1=plot(PCA_1,0,'kx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
PCA_1_mQ1 = mean(PCA_1);
plot(PCA_1_mQ1,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);
xlim auto
