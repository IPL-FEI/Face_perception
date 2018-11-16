clc; clear all; close all

X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/img1_GFMT.csv');
% classes = csvread('~/Dropbox/Dados/VETOR_IMAGENS/ProfOrdenadoGENERO.csv');


XLabel = [zeros(10,1); ones(10,1)];

[Prediction, PredictionTrain] = xvalPcaMldaLOO(X, XLabel, 0)