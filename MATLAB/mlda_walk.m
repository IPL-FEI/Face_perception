% DESCRIPTION
% Generate the images by walking through the mlda hyperplane
%
% INPUTS
% [Pmlda]    (vector [nx1]) Eigenvectors of LDA/MLDA. 
% [Nlabel]   (vetor [1xn])  Number of samples of each group.
% [dim]      (scalar)       Image width.
% [Ppca]     (vector [nx1]) PCA Eigenvectors. 
% [data]     (vector [nxm]) Original data.
% [Z]        (vector [nx1]) LDA/MLDA Hyperplane (data*Ppca*Pmlda).
%
% @author: Pedro Augusto and Estela Ribeiro
% FEI - Centro Universitário FEI
% =========================================================================


function mlda_walk(Pmlda, Nlabel, dim, Ppca, data, Z)
    % Calcula as médias dos grupos (está invertido porque 
    % a parte esquerda doplano do mlda é negativa)
    x(2) = mean(Z(1:Nlabel(1))); 
    x(1) = mean(Z((Nlabel(1)+1):end,1));
    
    % Calcula o desvio padrão dos grupos
    st(2) = std(Z(1:Nlabel(1)));
    st(1) = std(Z((Nlabel(1)+1):end,1));
    
    % Flipa os vetores dos 
    if x(2) < x(1)
        x = fliplr(x);
        st = fliplr(st);
    end
    
    % Calcula a média global    
    media = mean(data);
    media = media';
    
    % Vetor das imagens obtidas na navegação
    vetor = {};
    
    for g=1:2 % group1 and group2
        if g==1 %
            for j = -3:1:-1  %passo da navegação
                  y = j*st(g)*Pmlda + x(g)*Pmlda;
                  imagem = media + Ppca*(y);

                  % Transforma o vetor em uma matriz
                  imagem = vec2mat(imagem',dim);
                  % Mapeia a imagem para escala de cinza
    %               imagem = mat2gray(imagem);

                  vetor = [vetor; imagem];
            end
        end %
        if g == 1
            % Imagem média global
            imagem = vec2mat(media,dim);
%             imagem = mat2gray(imagem);
            vetor = [vetor; imagem];
        end
        
         %=====
        if g==2
            for j = 1:1:3  %passo da navegação
              y = j*st(g)*Pmlda + x(g)*Pmlda;
              imagem = media + Ppca*(y);
              
              % Transforma o vetor em uma matriz
              imagem = vec2mat(imagem',dim);
              % Mapeia a imagem para escala de cinza
%               imagem = mat2gray(imagem);
        
              vetor = [vetor; imagem];
            end 
        end
        %=======
    end
    %montage(vetor, 'Size', [1 7]);
    % Caso esteja usando Matlab 2015a usar:
    newimage = cell2mat(vetor');
    figure('Name','MLDA_WALK')
    imshow(newimage(:, :, 1), [0 80])
end