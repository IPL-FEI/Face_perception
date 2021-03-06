% Description
% =========================
% Function that plot 2 dimension MLDA result
% using K-means
% 
% ps: This function needs ctPCA and 
%     ctmlda in your folder
% ============
% INPUTS:
% Z = Data*Ppca*Pmlda
% Data -> Original Data (already sorted)
% 
% ============
% OUTPUTS:
% Plot a graph
%=============
% 
% @author: Víctor Varela e Estela ribeiro
% Centro Universitário FEI
% =========================


%% Chamada de Função
function Graph_mlda_2D(Z,Data)
% %% DADO
% % 
% % X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');
% X = Data;
% %% Quantidade de PCs
% n = (min(size(X))-1);               %Calcula a máxima quantidade de PCs possíveis de extrair (Nsamples - 1)
% %% Normalização
% [lin, col] = size(X); dnorm = [];
% for k = 1:lin
%     dnorm(k,:) = X(k,:) - mean(X);
% end
% %% PCA
% [Ppca, Kpca, Vpca] = ctPCA(dnorm, n);
% %% MLDA
% % USANDO TODOS OS DADOS PARA TREINAMENTO
% [Pmlda,Kmlda,Vmlda] = ctmlda(dnorm*Ppca, 3,Samples, 2);
% Y = dnorm*Ppca * Pmlda; % Projeta os dados nos Autovetores P
        Y = Z
       
    [idx,C] = kmeans (Y,3); 
    figure('Name','K-means MLDA 2D')
    hold on
    p1 = plot(C(:,1),C(:,2),'kx', 'MarkerSize',25,'LineWidth',3); 
    p2 = plot(Y(idx==1,1),Y(idx==1,2),'r.','MarkerSize',30)
    p3 = plot(Y(idx==2,1),Y(idx==2,2),'b.','MarkerSize',30)
    p4 = plot(Y(idx==3,1),Y(idx==3,2),'g.','MarkerSize',30)
    grid ON 
    ind = [1:min(size(Data))]'; indx = num2str(ind); IND = cellstr(indx); %Para 25 amostras
    text (Y(:,1), Y(:,2), IND)
    % legend([p1(1), p2(1), p3(1), p4(1)], 'Centroides', 'Ruins', 'Intermediários', 'Bons');
    % Limites
    %ylim([0 1]), xlim([(min(Y-1)) (1+max(Y))]);
    set(gca,'Ytick',[], 'Ycolor', 'none'), box off
