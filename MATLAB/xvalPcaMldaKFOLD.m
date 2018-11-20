function [Evaluation, Prediction, EvaluationTrain, PredictionTrain]...
    = xvalPcaMldaKFOLD(X, Xlabel, nFold, ng)
% =========================================================================
% DESCRIPTION
% Performe the PCA and MLDA/LDA according to the methodology proposed by
% THOMAZ et al. 2007
% crossvalidation: K-FOLD
% classifier: Euclidian distance
%
% INPUT
% [X]       (matrix [N x M]) Data Sample (N = number of subjects)
% [Xlabel]  (vector [N x 1]) actual class labels of the Data Sample
% [nFold]   (scalar) number of K iterations on K-FOLD
% [ng]      (vector [1x2]) number of samples per class
%
% OUTPUT
% [Evaluation]  (vector [1x7])performance of a classification model of TEST SET 
% [Prediction]  (matrix [nFold x 3]) Predicted data of the TEST SET
%               1Col = Kfold | 2Col = Predicted Data | 3Col = Actual Class Data
% [EvaluationTrain]  (vector [1x7])performance of a classification model of TRAIN SET
% [PredictionTrain]  (matrix [nFold x 3]) Predicted data of the TRAIN SET
%               1Col = Kfold | 2Col = Predicted Data | 3Col = Actual Class Data
% AUTHOR
%   Estela Ribeiro, November 2018
% =========================================================================

  indGroup1 = crossvalind('Kfold', Xlabel(1:ng(1),:), nFold); % Realiza o k-fold cross-validation 
  indGroup2 = crossvalind('Kfold', Xlabel(ng(1)+1:(ng(1)+ng(2)),:), nFold); % Realiza o k-fold cross-validation 
  indices = [indGroup1; indGroup2];
  cp = classperf(Xlabel); %reinitialize the cp-structure

Evaluation = []; Prediction = [];
EvaluationTrain = []; PredictionTrain = [];
%--------------------------------------------------------------------------
for i = 1:nFold % acessa a divis�o feita pelo crossvalind
            xtest = (indices == i); % testData = uma das divis�es do k-fold
            xtrain = ~xtest; % trainData = o restante dos dados
%    trainInd = find(xtrain);
%    testInd = find(xtest);

% --> Treinamento com media zero
Xtr = X(xtrain,:); % Dados de TREINO
TRlabel = Xlabel(xtrain);
[ltrain,ctrain] = size(Xtr);
ntrain = []; j = 0;
for j = 1:ltrain
 ntrain(j,:) = Xtr(j,:) - mean(Xtr);
end

% --> Teste com m�dia zero
Xts = X(xtest,:); % Dados de TESTE
TSlabel = Xlabel(xtest);
[ltest,ctest] = size(Xts);
ntest = []; jj = 0;
for jj = 1:ltest
ntest(jj,:) = Xts(jj,:) - mean(Xtr);
end

% --> PCA
n = (min([ltrain,ctrain])-1); % maximo de PCs poss?veis de extrair
[Ppca, ~, ~] = ctPCA(ntrain, 1); % 1 argumento: Matriz com media zero
Ytrain = ntrain * Ppca; % Projeta os dados de Treinamento nos Autovetores Ppca
Ytest = ntest * Ppca; % Projeta os dados de Teste nos Autovetores Ppca

% --> MLDA
[Pmlda, ~, ~] = ctmlda(Ytrain, 2, ...
[length(find(Xlabel(xtrain)==0))...
, length(find(Xlabel(xtrain)==1))], 1);
Ztrain = Ytrain * Pmlda; % Projeta os dados de Treinamento nos Autovetores Pmlda
Ztest = Ytest * Pmlda; % Projeta os dados de Teste nos Autovetores Pmlda
    
    % Plotando dados do Treinamento
    subplot(nFold,1,i)
    p1=plot(Ztrain(find(TRlabel==0)),0,'rx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    p2=plot(Ztrain(find(TRlabel==1)),0,'bx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % M?dio

    % Plotando dados do Teste
    for idx = find(TSlabel==0)
        p3=plot(Ztest(idx),0,'ro', 'MarkerSize', 15, 'LineWidth', 2); hold on; % Ruim
    end
    for idx = find(TSlabel==1)
        p4=plot(Ztest(idx),0,'bo', 'MarkerSize', 15, 'LineWidth', 2); hold on; % M?dio
    end
    % Limites
    axis tight, ylim([0 1]);
    set(gca,'Ytick',[], 'Ycolor', 'none'), box off
    
    mGroup1 = mean(Ztrain(find(TRlabel==0))); 
    mGroup2 = mean(Ztrain(find(TRlabel==1))); % Media dos grupos
    p5 = plot(mGroup1,0, 'xm', mGroup2,0, 'xc', 'MarkerSize', 25, 'LineWidth', 3);

    % --> Classification
    Predicted = erclassEuclidiandist(Ztest, mGroup1, mGroup2);
    Prediction = [Prediction; i*ones(length(TSlabel),1), Predicted, TSlabel];
    
    PredictedTrain = erclassEuclidiandist(Ztrain, mGroup1, mGroup2);
    PredictionTrain = [PredictionTrain; i*ones(length(TRlabel),1), PredictedTrain, TRlabel];

    EVAL = Evaluate(TSlabel,Predicted);
    Evaluation = [Evaluation; EVAL];
    
    EVALtrain = Evaluate(TRlabel,PredictedTrain);
    EvaluationTrain = [EvaluationTrain; EVALtrain];

end
end