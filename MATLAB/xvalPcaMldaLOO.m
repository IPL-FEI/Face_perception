function [Prediction, PredictionTrain]...
         = xvalPcaMldaLOO(X, Xlabel, showplot)
% =========================================================================
% DESCRIPTION
% Performe the PCA and MLDA/LDA according to the methodology proposed by
% THOMAZ et al. 2007
% crossvalidation: LEAVE ONE OUT (LOO)
% Classifier: Euclidian distance
%
% INPUT
% [X]       (matrix [N x M]) Data Sample (N = number of subjects)
% [Xlabel]  (vector [N x 1]) actual class labels of the Data Sample
% [showplot](scalar) 0 = no | 1 = yes
%
% OUTPUT
% [Prediction]  (matrix [nFold x 3]) Predicted data of the TEST SET
%               1Col = Kfold | 2Col = Predicted Data | 3Col = Actual Class Data
% [PredictionTrain]  (matrix [nFold x 3]) Predicted data of the TRAIN SET
%               1Col = Kfold | 2Col = Predicted Data | 3Col = Actual Class Data
% AUTHOR
%   Estela Ribeiro, November 2018
% =========================================================================

[nFold, ~] = size(X);
Prediction = []; PredictionTrain = [];
%--------------------------------------------------------------------------
for i = 1:nFold % acessa a divis�o feita pelo crossvalind
    
    message = 'Leave One Out Iteration...'; %Mostra em qual iteração está o algortimo
    disp(message)
    disp(i)
    
    indices = zeros(nFold,1); % create a logical vector containing zeros
    indices(i) = 1; % index of test data
    xtest = (indices ==1); % test data (1 sample)
    xtrain = ~xtest; % train data
        
    % --> Treinamento
    Xtr = X(xtrain,:); % Dados de TREINO
    TRlabel = Xlabel(xtrain);
    [ltrain,ctrain] = size(Xtr);
    ntrain = []; j = 0;
    for j = 1:ltrain
        ntrain(j,:) = Xtr(j,:) - mean(Xtr); % Remove a m�dia do treino
    end
    
    % --> Teste
    Xts = X(xtest,:); % Dados de TESTE
    TSlabel = Xlabel(xtest);
    [ltest,~] = size(Xts);
    ntest = []; jj = 0;
    for jj = 1:ltest
        ntest(jj,:) = Xts(jj,:) - mean(Xtr); % Remove a m�dia do treino
    end

    n = (min([ltrain,ctrain])-1); % maximo de PCs possiveis de extrair
    % --> PCA
    [Ppca, ~, ~] = ctPCA(ntrain, n); % 1argumento: Matriz com media zero
    Ytrain = ntrain * Ppca; % Projeta os dados de Treinamento nos Autovetores Ppca
    Ytest = ntest * Ppca; % Projeta os dados de Teste nos Autovetores Ppca
    
    % --> LDA/MLDA
    [Pmlda, ~, ~] = ctmlda(Ytrain, 2, ...
        [length(find(Xlabel(xtrain)==0))...
        , length(find(Xlabel(xtrain)==1))], 1);
    Ztrain = Ytrain * Pmlda; % Projeta os dados de Treinamento nos Autovetores Pmlda
    Ztest = Ytest * Pmlda; % Projeta os dados de Teste nos Autovetores Pmlda

    % SEM PCA
%     [Pmlda, Kmlda, Vmlda] = ctlda(Xtr, 2, ...
%         [length(find(Xlabel(xtrain)==0))...
%         , length(find(Xlabel(xtrain)==1))], 1);
%     Ztrain = Xtr * Pmlda; % Projeta os dados de Treinamento nos Autovetores Pmlda
%     Ztest = Xts * Pmlda; % Projeta os dados de Teste nos Autovetores Pmlda    
    
    % --> PLOTS
    
    if showplot == 1
    
    % Plotando dados do Treinamento
    subplot(nFold,1,i)
    p1=plot(Ztrain(find(TRlabel==0)),0,'rx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    p2=plot(Ztrain(find(TRlabel==1)),0,'bx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % M?dio

    % Plotando dados do Teste
    for idx = find(TSlabel==0)
        p3=plot(Ztest(idx),0,'m*', 'MarkerSize', 6, 'LineWidth', 6); hold on; % Ruim
    end
    for idx = find(TSlabel==1)
        p4=plot(Ztest(idx),0,'c*', 'MarkerSize', 6, 'LineWidth', 6); hold on; % M?dio
    end
    % Limites
    axis tight, ylim([0 1]);
    set(gca,'Ytick',[], 'Ycolor', 'none'), box off
    
    mGroup1 = mean(Ztrain(find(TRlabel==0))); 
    mGroup2 = mean(Ztrain(find(TRlabel==1))); % Media dos grupos
    p5 = plot(mGroup1,0, 'xr', mGroup2,0, 'xb', 'MarkerSize', 25, 'LineWidth', 3);
    end
    
    mGroup1 = mean(Ztrain(find(TRlabel==0))); 
    mGroup2 = mean(Ztrain(find(TRlabel==1))); % Media dos grupos
    
    % --> CLASSIFICATION
    % Class Predicted for TEST SET
    Predicted = erclassEuclidiandist(Ztest, mGroup1, mGroup2);
    Prediction = [Prediction; i*ones(length(TSlabel),1), Predicted, TSlabel];
    
    % Class Predicted for TRAINING SET
    PredictedTrain = erclassEuclidiandist(Ztrain, mGroup1, mGroup2);
    PredictionTrain = [PredictionTrain; i*ones(length(TRlabel),1), PredictedTrain, TRlabel];
        
end
end
% THOMAZ et al. Multivariate Statistical Differences of MRI Samples of the
% Human Brain. J. Math Imaging, v.29, p.95-106, 2007.