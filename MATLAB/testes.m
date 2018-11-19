close all
clear all
clc

%dado = csvread('L_pcaOrdenadoTODOS.csv');
%classes = csvread('ProfOrdenadoTODOS.csv');
% dado = csvread('PCA GENERO/L_pcaOrdenado_INTC_Alto Erro_GENERO.csv');
% classes = csvread('PCA GENERO/ProfOrdenadoGENERO.csv');

dado = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');



% USANDO TODOS OS DADOS PARA TREINAMENTO
[P,K,V] = ctmlda(dado, 2,[230 230],1); % Calcula o MLDA
Y = dado * P; % Projeta os dados nos Autovetores P
