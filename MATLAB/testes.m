close all
clear all
clc

%dado = csvread('L_pcaOrdenadoTODOS.csv');
%classes = csvread('ProfOrdenadoTODOS.csv');
% dado = csvread('PCA GENERO/L_pcaOrdenado_INTC_Alto Erro_GENERO.csv');
% classes = csvread('PCA GENERO/ProfOrdenadoGENERO.csv');

dado = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');

Graph_mlda_2D(dado, [115 230 115]);

