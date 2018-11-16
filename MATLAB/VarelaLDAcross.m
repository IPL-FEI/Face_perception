close all
clear all
clc

dado = csvread('L_pcaOrdenadoTODOS.csv');
classes = csvread('ProfOrdenadoTODOS.csv');
%dado = csvread('L_pcaOrdenadoTODOS35.csv');
%classes = csvread('ProfOrdenadoTODOS35.csv');


% USANDO TODOS OS DADOS PARA TREINAMENTO
[P,K,V] = ctmlda(dado, 2,[10 9 10 10],1); % Calcula o LDA
Y = dado * P; % Projeta os dados nos Autovetores P
        
    figure,
    %title('Proje��o dos dados no eixo de discriminancia do MLDA usando Todos os dados')
    %xlabel('Eixo de proje��o')
    p1=plot(Y(1:10),0,'ro', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    p2=plot(Y(11:19),0,'b*', 'MarkerSize', 10, 'LineWidth', 2); hold on; % M�dio
    p3=plot(Y(20:29),0,'g^', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Melhor
    p4=plot(Y(30:39),0,'kx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % BOM
    legend([p1(1), p2(1), p3(1), p4(1)],'1quartil','2quartil','3quartil','4quartil');
    mQ1 = mean(Y(1:10)); mQ2 = mean(Y(11:19));
    mQ3 = mean(Y(20:29)); mQ4 = mean(Y(30:end));
    plot(mQ1,0,'rx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
    plot(mQ2,0,'bx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
    plot(mQ3,0,'gx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
    plot(mQ4,0,'kx', 'MarkerSize', 30, 'LineWidth', 1); hold off;

    % Limites
    ylim([0 1]), xlim([(min(Y-1)) (1+max(Y))]);
    set(gca,'Ytick',[], 'Ycolor', 'none'), box off
    
% SEPARANDO OS DADOS PARA CROSSVALIDATION
X = dado;
%X_label = [zeros(10,1); ones(10,1)]; %Classifica��o 2 classes
%X_label = [ones(10,1); 2*ones(9,1); 3*ones(10,1); 4*ones(10,1)]; %Classifica��o
%X_label = classes;
X_label = [ones(29,1); 2*ones(10,1)]; %Classifica��o
fold_number = 10; %Numero de folds do Crossvalidation 
RESULTADO = [];

    % Ordena os dados para o k-fold, separando o que ser� usado para Teste
    % e o que ser� usado para Treino
%    indicesQ1 = crossvalind('Kfold', X_label(1:10,:), fold_number);
%    indicesQ2 = crossvalind('Kfold', X_label(11:19,:), fold_number);
%    indicesQ3 = crossvalind('Kfold', X_label(20:29,:), fold_number);
%    indicesQ4 = crossvalind('Kfold', X_label(30:end,:), fold_number);
%    indices = [indicesQ1; indicesQ2; indicesQ3; indicesQ4];

indicesRuins = crossvalind('Kfold', X_label(1:29,:), fold_number);
indicesBons = crossvalind('Kfold', X_label(30:end,:), fold_number);
indices = [indicesRuins; indicesBons];
    cp = classperf(X_label); %!!! reinitialize the cp-structure

    
MATRIZ = [];
RESULTADO = [];
figure
for i = 1:fold_number % acessa a divis�o feita pelo crossvalind
        
        test = (indices == i); % testData = uma das divis�es do k-fold
        train = ~test; % trainData = o restante dos dados

                trainInd = find(train);
                testInd = find(test);

        % MLDA PARA CADA K-FOLD
%[P,K,V] = ctmlda(X(train,:),4,...
%[length(find(X_label(train)==1)), length(find(X_label(train)==2)), length(find(X_label(train)==3)), length(find(X_label(train)==4))],...
%1); % Calcula o LDA

[P,K,V] = ctmlda(X(train,:),2,[length(find(X_label(train)==1)), length(find(X_label(train)==2))],1); % Calcula o LDA

Y = X * P; % Projeta os dados nos Autovetores P
        
    subplot(fold_number,1,i)
    p1=plot(Y(1:10),0,'ro', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    p2=plot(Y(11:19),0,'b*', 'MarkerSize', 10, 'LineWidth', 2); hold on; % M�dio
    p3=plot(Y(20:29),0,'g^', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Melhor
    p4=plot(Y(30:39),0,'kx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % BOM
    
    % ----- CLASSIFICA��O PELA DISTANCIA EUCLIDIANA DA M�DIA    
 %   mQ1 = mean(Y(1:10)); mQ2 = mean(Y(11:19));
 %   mQ3 = mean(Y(20:29)); mQ4 = mean(Y(30:end));
 mRuins = mean(Y(1:29)); mBons = mean(Y(30:end));
 p5 = plot(mRuins,0,'r*', 'MarkerSize', 30, 'LineWidth', 1); hold on;
 p6 = plot(mBons,0,'kx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
 %legend([p1(1), p2(1), p3(1), p4(1), p5(1), p6(1)],'Quartil 1','Quartil 2','Quartil 3','Quartil 4','M�dia Quartil 1,2 e 3', 'M�dia Quartil 4');
 
 %   plot(mQ1,0,'rx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
 %   plot(mQ2,0,'bx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
 %   plot(mQ3,0,'gx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
 %   plot(mQ4,0,'kx', 'MarkerSize', 30, 'LineWidth', 1); hold off;

        % Limites
    ylim([0 1]), xlim([-10000 10000]);
    set(gca,'Ytick',[], 'Ycolor', 'none'), box off
    
%    distQ1=[]; distQ2=[]; distQ3=[]; distQ4=[];
distRuins = []; distBons = [];
    % Calculando a dist�ncia de cada ponto para cada m�dia
    for v = 1:length(Y)
%         distQ1(v,1) = dist(mQ1, Y(v,1));
%         distQ2(v,1) = dist(mQ2, Y(v,1));
%         distQ3(v,1) = dist(mQ3, Y(v,1));
%         distQ4(v,1) = dist(mQ4, Y(v,1));
          distRuins(v,1) = dist(mRuins, Y(v,1));  
          distBons(v,1) = dist(mBons, Y(v,1));
    end
    
%    distVect = ([distQ1, distQ2, distQ3, distQ4]);
    distVect = ([distRuins, distBons]);
    % Compara os valores da dist�ncia de cada ponto para cada m�dia
    classResult=[];
    for w = 1:length(Y)
        classResult(w) = find(distVect(w,:)==min(distVect(w,:)));
    end
    
    
    
    MATRIZ = [MATRIZ; i, classResult; i, X_label'];
    
    WW = [classResult', X_label];
    
    ACERTO = 0;
    for z=1:length(Y)
        if WW(z,1)==WW(z,2)
            ACERTO = ACERTO+1;
        end
    end
    TAXA = ACERTO/length(Y);
    RESULTADO = [RESULTADO;TAXA];
end

TOTAL = sum(RESULTADO)/(length(RESULTADO))*100
STD = std(RESULTADO)*100

MATRIZ % matriz de confusão