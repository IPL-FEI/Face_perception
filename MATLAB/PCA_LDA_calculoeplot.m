clear all, close all, clc
  
%-----------------------------Treino---------------------------------------

data = csvread('~/Dropbox/Dados/VETOR_IMAGENS/VECTOR_IMAGE_Ordenado_INTC_Intacta Baixo Erro_GENERO.csv'); % matriz com as imagens concatenadas
            % lin = n. imagens; col = pixels concatenados
            % obs. ordenado de acordo com as classes	
            % data = matrix [lin x col]  

% Normaliza dados de treinamento (média = 0)
[lin, col] = size(data); dnorm = [];
for k = 1:lin
    dnorm(k,:) = data(k,:) - mean(data); 
end

n = (min([lin,col])-1); % máximo de CPs possíveis de extrair
%n=20;
[P1, K1, V1] = ctPCA(dnorm, n); % 1ºargumento: Matriz com média zero
                 % 2º argumento: Redução da dimensionalidade

% Remove as duas primeiras componentes
P1(:,1) = []; K1(1,:) = []; 
P1(:,1) = []; K1(1,:) = [];

Y = dnorm * P1; % Projeta os dados nos Autovetores P do PCA
               % Y = [lin x col] * [col x n] = [lin x n]

escala_gt = csvread('separação/escala_dor_gt.csv');
escala_gt = vertcat(escala_gt, csvread('separação/escala_ndor_gt.csv'));

%--------------------------------Teste-------------------------------------  

data2 = csvread('~/Dropbox/Dados/VETOR_IMAGENS/VECTOR_IMAGE_Ordenado_INTC_Intacta Baixo Erro_GENERO.csv');
[lin, col] = size(data2);
dnmor2 = [];
for k = 1:lin
    dnorm2(k,:) = data2(k,:) - mean(data); 
end

Y2 = dnorm2 * P1;
escala_test = csvread('separação/escala_test_gt.csv');

%--------------------------Classificação-----------------------------------

label = 2;      % Número de grupos distintos
                % label = scalar

Nlabel = [29,30];
                % quantas imagens tem cada grupo, 
                % ordenadas de acordo com a matriz data
                % Nlabel = vector [1 x length(Nlabel)]

nn = 1; % dimensões

[P3, K2, V2] = ctmlda(Y, label, Nlabel, nn); % n=redução de dimensionalidade

Z = Y * P3; 	% Projeção dos dados nos autovetores P
                % Z = [lin x col] * [col x n] = [lin x n]
                % Note que Z continua com o mesmo número de Imagens que
                % possui em seus dados%
Z2 = Y2 * P3;                

%--------------------------------PLOTS-------------------------------------
subplot(2,1,1)
p1=plot(Z(1:Nlabel(1),1),0,'ro', 'MarkerSize', 10, 'LineWidth', 1.1); hold on; % Grupo 1
p2=plot(Z((Nlabel(1)+1):end,1),0,'b*', 'MarkerSize', 10, 'LineWidth', 1.1); hold on; % Grupo 2
%p3=plot(Z2 ,0,'g.','MarkerSize', 11, 'LineWidth',1.6); hold on

% Plota em 2 dimensões com a escala de dor
% p1=plot(Z(1:Nlabel(1),1),escala_gt(1:29),'ro', 'MarkerSize', 10, 'LineWidth', 1.1); hold on; % Grupo 1
% p2=plot(Z((Nlabel(1)+1):end,1),escala_gt(30:end),'b*', 'MarkerSize', 10, 'LineWidth', 1.1); hold on; % Grupo 2
% p3=plot(Z2 ,escala_test,'g^','MarkerSize', 8,'LineWidth',0.2);
%grid on

% Calcula as médias dos grupos
mQ1 = mean(Z(1:Nlabel(1))); 
mQ2 = mean(Z((Nlabel(1)+1):end,1));
%mQ3 = mean(Z((Nlabel(2)+1):end,1));

% Plota as médias no gráfico
media1 = plot(mQ1,0,'rx', 'MarkerSize', 17, 'LineWidth', 2); hold on;
media2 = plot(mQ2,0,'bx', 'MarkerSize', 17, 'LineWidth', 2); hold on;
%plot(mQ3,0,'gx', 'MarkerSize', 30, 'LineWidth', 1); hold off;

% Calcula o desvio padrão dos grupos
st(1) = std(Z(1:Nlabel(1)));
st(2) = std(Z((Nlabel(1)+1):end,1));

% Calcula a média global
X = mean(Z);
plot(mQ1 + st(1),0,'r^', 'MarkerSize', 17, 'LineWidth', 2); hold on;
plot(mQ1 - st(1),0,'r^', 'MarkerSize', 17, 'LineWidth', 2); hold on;

plot(mQ2 + st(2),0,'b^', 'MarkerSize', 17, 'LineWidth', 2); hold on;
plot(mQ2 - st(2),0,'b^', 'MarkerSize', 17, 'LineWidth', 2); hold on;

plot(X,0,'g^', 'MarkerSize', 17, 'LineWidth', 2); hold on;

% legenda
legend([p1(1), p2(1)] ,'Com dor','Sem dor');

% Plot Style
ylim([0 1]);
set(gca,'Ytick',[], 'Ycolor', 'none'), box off
   
subplot(2,1,2)
plotGaussian(Z, Nlabel(1), Nlabel(2))
%pca_walk(data, K1, P1, 120, 6)
%mlda_walk(Z,Nlabel)