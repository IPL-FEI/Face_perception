% Grafico 2D para o mlda
% Autores: Víctor Varela e Estela ribeiro


close all,clear all,clc
%% DADO
X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');
%% Quantidade de PCs
n = (min(size(X))-1);               %Calcula a máxima quantidade de PCs possíveis de extrair (Nsamples - 1)
%% Normalização
[lin, col] = size(X); dnorm = [];
for k = 1:lin
    dnorm(k,:) = X(k,:) - mean(X);
end
%% PCA
[Ppca, Kpca, Vpca] = ctPCA(dnorm, n);
%% MLDA
% USANDO TODOS OS DADOS PARA TREINAMENTO
[Pmlda,Kmlda,Vmlda] = ctmlda(dnorm*Ppca, 3,[115 230 115], 2)
Y = dnorm*Ppca * Pmlda; % Projeta os dados nos Autovetores P
        
    %figure,
    %title('Proje��o dos dados no eixo de discriminancia do MLDA usando Todos os dados')
    %xlabel('Eixo de proje��o')
    %p1=plot(Y(1:15,1),0,'ro', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    %p2=plot(Y(16:25,1),0,'b*', 'MarkerSize', 10, 'LineWidth', 2); hold on; % M�dio
    %p3=plot(Y(16:25,1),0,'g^', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Melhor
    %p4=plot(Y(16:20,1),Y(16:20,2),'kx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % BOM
    %p5=plot(Y(21:25,1),Y(21:25,2),'mx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % muito BOM
    %ind = [1:25]'; indx = num2str(ind); IND = cellstr(indx); %Para 25 amostras
    %text (Y(:,1),ones(25,1)*0.2, IND);
    %ylim([1 -1])
    %p1=plot(Y(1:17,1),0,'ro', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    %p2=plot(Y(18:25,1),0,'b*', 'MarkerSize', 10, 'LineWidth', 2); hold on; % M�dio
    %p3=plot(Y(18:25,1),0,'g^', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Melhor
    %p1=plot(Y(1:20,1),0,'ro', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    %p2=plot(Y(21:25,1),0,'b*', 'MarkerSize', 10, 'LineWidth', 2); hold on; % M�dio
   
    
    [idx,C] = kmeans (Y,3); 
    figure(1)
    hold on
    p1 = plot(C(:,1),C(:,2),'kx', 'MarkerSize',25,'LineWidth',3); 
    p2 = plot(Y(idx==1,1),Y(idx==1,2),'r.','MarkerSize',30)
    p3 = plot(Y(idx==2,1),Y(idx==2,2),'b.','MarkerSize',30)
    p4 = plot(Y(idx==3,1),Y(idx==3,2),'g.','MarkerSize',30)
    grid ON 
    ind = [1:460]'; indx = num2str(ind); IND = cellstr(indx); %Para 25 amostras
    text (Y(:,1), Y(:,2), IND)
    % legend([p1(1), p2(1), p3(1), p4(1)], 'Centroides', 'Ruins', 'Intermediários', 'Bons');
    % Limites
    %ylim([0 1]), xlim([(min(Y-1)) (1+max(Y))]);
    set(gca,'Ytick',[], 'Ycolor', 'none'), box off
    