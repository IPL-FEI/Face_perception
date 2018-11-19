% DESCRIPTION
% Generate the images by walking through the mlda hyperplane
%
% INPUTS
% [Pmlda]    (vector [nx2]) Eigenvectors of LDA/MLDA. 
% [Nlabel]   (vetor [1xn])  Number of samples of each group.
% [dim]      (scalar)       Image width.
% [Ppca]     (vector [nx1]) PCA Eigenvectors. 
% [data]     (vector [nxm]) Original data.
% [Z]        (vector [nx1]) LDA/MLDA Hyperplane (data*Ppca*Pmlda).
%
% @author: Pedro Augusto, Estela Ribeiro and Víctor Varela
% FEI - Centro Universitário FEI
% =========================================================================

%%%
% NOT VALIDATED!!!!!!!!!!!
%%%
function mlda_2d_walk(Pmlda,Nlabel, dim, Ppca, data, Z)
    % Calcula as médias dos grupos (está invertido porque 
    % a parte esquerda doplano do mlda é negativa)
%     x(1) = mean(Z(1:Nlabel(1))); 
%     x(2) = mean(Z(1:Nlabel(2)));
%     x(3) = mean(Z((Nlabel(2)+1):end,1));
        x = mean(Z);
    % Calcula o desvio padrão dos grupos
    st(1) = std(Z(1:Nlabel(1)));
    st(2) = std(Z(1:Nlabel(2)));
    st(3) = std(Z((Nlabel(1)+1):end,1));
      st = std(Z);
    
    % Calcula a média global    
    media = mean(data);
    media = media';
    
    % Vetor das imagens obtidas na navegação
    vetor = {};
    for k=3:-1:-3
         for j = -3:1:3  %passo da navegação
              y = j*st(:,1)*Pmlda(:,1) + j*x(:,1)*Pmlda(:,1)...
                  + k*x(:,2)*Pmlda(:,2)+ k*st(:,2)*Pmlda(:,2);
              imagem = media + Ppca*(y);

              % Transforma o vetor em uma matriz
              imagem = vec2mat(imagem',dim);
              % Mapeia a imagem para escala de cinza
    %               imagem = mat2gray(imagem);

              vetor = [vetor; imagem];
           end
      end
    %montage(vetor, 'Size', [1 7]);
    % Caso esteja usando Matlab 2015a usar:
     newimage = reshape(vetor, [7 7]);
     newimage = cell2mat(newimage');  
    
    %----
%     newimage = cell2mat(vetor');
%     newimage = reshape(newimage,[7 7]);
    %----
    figure('Name','MLDA_2D_WALK')
    imshow(newimage(:, :, 1), [0 80])
end