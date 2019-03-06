% Code to Check all the first PCA components and save on a file

close all, clear all, clc
%% ============ Data ==================

%      X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_BxR_GFMT.csv');
     X = csvread ('~/Dropbox/Journal/VETOR_IMAGENS/imgCONCATENADA_GFMT.csv');
%      X = csvread ('~/Dropbox/Journal/Individuals/imgCONCATENADA_GOOD_GFMT.csv');
%      X = csvread ('~/Dropbox/Journal/Individuals/imgCONCATENADA_BAD_GFMT.csv'); 
%      X = csvread ('~/Dropbox/Journal/Individuals/30_GFMT.csv');
    disp('Data ready')
% 
%% ======= Extract data information ===

n = (min(size(X))-1);               %Calcula a máxima quantidade de PCs possíveis de extrair (Nsamples - 1)
dim = sqrt(max(size(X)));           %Se a imagem for quadrada, usar esse dim
        
    %Case not square image:
dim = 250;                

%% ======= Data normalization =========

[lin, col] = size(X); dnorm = [];
for k = 1:lin
    dnorm(k,:) = X(k,:) - mean(X);
end

%% ============== PCA =================

[Ppca, Kpca, Vpca] = ctPCA(dnorm, n); % 1�argumento: Matriz com m�dia zero
disp(Vpca(1))

%% =========== PCA WALK ===============
%       (Data, K1, P1,dim, n)
pca_walk(X, Kpca, Ppca, dim, 1)

%% ======= First PCA component ========
PCA_1 = dnorm * Ppca(:,5);
% getting first pca component
figure,
p1=plot(PCA_1,0,'kx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
PCA_1_mQ1 = mean(PCA_1);
plot(PCA_1_mQ1,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);
xlim auto

%% ============================= TEST AREA==================================== %%

%% Individual Processing
list = [30,7,27,20,6,38,15,14,33,41,31, 25,29,32,11,37,2,17,24,26,40,12,10,5,22,28,1,4,39,19,23,13,35,36,16,21,18,9,3];
[linL,colL] = size(list);
means = [];
figure,
for i = 1:colL
    Individual_Number = list(i);
    Individual_Number_str = int2str(Individual_Number);
    Data_ind = strcat('~/Dropbox/Journal/Individuals/',Individual_Number_str);
    Data_ind = strcat(Data_ind, '_GFMT.csv');
    Individual = csvread (Data_ind);

    [lin, col] = size(Individual); dnorm2 = [];
    for k = 1:lin
        dnorm2(k,:) = Individual(k,:) - mean(X);
    end

    PCA_Individual = dnorm2 * Ppca(:,1);
    % getting first pca component
    subplot(colL,1,i),
    p1=plot(PCA_Individual,0,'kx', 'MarkerSize', 10, 'LineWidth', 2); hold on; % Ruim
    PCA_1_mQ1 = mean(PCA_1); PCA_Individual_mQ2 = mean(PCA_Individual);
%     plot(PCA_1_mQ1,0,'rx', 'MarkerSize', 30, 'LineWidth', 1); hold on;
    plot(PCA_Individual_mQ2,0,'bx', 'MarkerSize', 30 , 'LineWidth',1)
    xlim([-1000 1000]);hold on;
    
    means = [means, PCA_Individual_mQ2];
end
%%

means_1 = mean(means(1:3));
means_2 = mean(means(4:6));
means_3 = mean(means(7:9));
means_4 = mean(means(10:12));
means_5 = mean(means(13:15));
means_6 = mean(means(16:18));
means_7 = mean(means(19:21));
means_8 = mean(means(22:24));
means_9 = mean(means(25:27));
means_10 = mean(means(28:30));
means_11 = mean(means(31:33));
means_12 = mean(means(34:36));
means_13 = mean(means(37:39));

figure()
subplot(13,1,1)
plot(means_1,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,2)
plot(means_2,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,3)
plot(means_3,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,4)
plot(means_4,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,5)
plot(means_5,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,6)
plot(means_6,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,7)
plot(means_7,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,8)
plot(means_8,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,12)
plot(means_9,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,11)
plot(means_10,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,9)
plot(means_11,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,10)
plot(means_12,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;
subplot(13,1,13)
plot(means_13,0,'rx', 'MarkerSize', 30, 'LineWidth', 1);xlim([-1000 1000]); hold on;



