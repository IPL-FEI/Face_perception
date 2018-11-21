%Experimento para Journal
close all, clear all, clc


% %% =========Importando os dados===========
% X1 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img1_GFMT.csv');
% X2 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img2_GFMT.csv');
% X3 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img3_GFMT.csv');
% X4 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img4_GFMT.csv');
% X5 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img5_GFMT.csv');
% X6 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img6_GFMT.csv');
% X7 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img7_GFMT.csv');
% X8 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img8_GFMT.csv');
% X9 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img9_GFMT.csv');
% X10 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img10_GFMT.csv');
% X11 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img11_GFMT.csv');
% X12 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img12_GFMT.csv');
% X13 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img13_GFMT.csv');
% X14 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img14_GFMT.csv');
% X15 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img15_GFMT.csv');
% X16 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img16_GFMT.csv');
% X17 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img17_GFMT.csv');
% X18 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img18_GFMT.csv');
% X19 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img19_GFMT.csv');
% X20 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img20_GFMT.csv');
% X21 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img21_GFMT.csv');
% X22 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img22_GFMT.csv');
% X23 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img23_GFMT.csv');
% %X35 = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img35_GFMT.csv');
% 
% %%============Media dos dados=============
% 
% SOMA = X1+ X2+ X3+ X4+ X5+ X6+ X7+ X8+ X9+ X10+X11+ X12+ X13+ X14+ X15+ X16+ X17+ X18+ X19+ X20+ X21+ X22+ X23;
% X = SOMA/23; %Media das estrategias oculares dos varios dados

%% Data

X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');

% 
%% ========Extrai informações dos dados====

n = (min(size(X))-1);               %Calcula a máxima quantidade de PCs possíveis de extrair (Nsamples - 1)
dim = sqrt(max(size(X)));           %Se a imagem for quadrada, usar esse dim
        
    %Caso a Imagem não seja quadrada:
dim = 250;                

%
%% ======Divisão das samples para o MLDA===
<<<<<<< HEAD
SamplesSimples = [19 20]; %Numero de participantes = 39
=======
SamplesSimples = [34 5] %Numero de participantes = 39
>>>>>>> master
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

%
%% ================MLDA====================

[Pmlda,Kmlda,Vmlda] = ctmlda(dnorm*Ppca, 2,Samples, 1); % Calcula o MLDA

%
%% ============Navegação PCA===============

% pca_walk(X, Kpca, Ppca, dim, 5)

%
%% ===========Navegação MLDA===============

% mlda_walk(Pmlda, Samples, dim, Ppca, X, dnorm*Ppca*Pmlda)

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
