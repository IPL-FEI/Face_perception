clear all, close all, clc

%% Dados / Par�metros
% Dados
X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');

% Par�metros
ng = [460-23 23]; % Numero de amostras por classe
Xlabel = [zeros(ng(1),1); ones(ng(2),1)]; % classifica��o das amostras
nFold = 10; % Para K-FOLD - numero de K itera��es

showplot = 0; % Para Leave one Out

%% --> K-FOLD <--
[Etest, Ptest, Etrain, Ptrain] = xvalPcaMldaKFOLD(X, Xlabel, nFold, ng);

% Resultados do TESTE
sensitivityTest = (sum(Etest(:,2))/nFold)*100; specificityTest = (sum(Etest(:,3))/nFold)*100;
precisionTest = (sum(Etest(:,4))/nFold)*100; recallTest = (sum(Etest(:,5))/nFold)*100;
f_measureTest = (sum(Etest(:,5))/nFold)*100; 
acuracyTest = (sum(Etest(:,1))/nFold)*100
stdevTest = std(Etest(1:end,1))*100

% Armazena todos os dados em um �nico vetor
Etest = [Etest; acuracyTest, sensitivityTest, specificityTest, precisionTest, recallTest, f_measureTest, stdevTest];

% Grava os dados
%dlmwrite('testEvaluation.csv',Etest);%,'-append','newline','pc');
%dlmwrite('testPrediction.csv',Ptest);%,'-append','newline','pc');

sensitivityTrain = (sum(Etrain(:,2))/nFold)*100; specificityTrain = (sum(Etrain(:,3))/nFold)*100;
precisionTrain = (sum(Etrain(:,4))/nFold)*100; recallTrain = (sum(Etrain(:,5))/nFold)*100;
f_measureTrain = (sum(Etrain(:,6))/nFold)*100;
acuracyTrain = (sum(Etrain(:,1))/nFold)*100
stdevTrain = std(Etrain(1:end,1))*100

% Armazena todos os dados em um �nico vetor
Etrain = [Etrain; acuracyTrain, sensitivityTrain, specificityTrain, precisionTrain, recallTrain, f_measureTrain, stdevTrain];
%dlmwrite('trainEvaluation.csv',Etrain);%,'-append','newline','pc');
%dlmwrite('trainPrediction.csv',Ptrain);%,'-append','newline','pc');

%% --> LEAVE ONE OUT <--
% [Ptest, Ptrain] = xvalPcaMldaLOO(X, Xlabel, showplot); % 0 ou 1 para mostrar grafico
% 
% testEval = Evaluate(Ptest(:,3),Ptest(:,2));
% testEval = testEval.*100
% trainEval = Evaluate(Ptrain(:,3),Ptrain(:,2))
% trainEval = trainEval.*100
% %dlmwrite('testEvaluation.csv',testEval);%,'-append','newline','pc');
% %dlmwrite('trainEvaluation.csv',trainEval);%,'-append','newline','pc');