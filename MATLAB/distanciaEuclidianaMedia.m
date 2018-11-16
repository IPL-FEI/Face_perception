function TAXA = distanciaEuclidianaMedia(mRNM, mRM, Y)

%mRNM; % Média nãomusicos
%mRM; % Média musicos

%Y(:,1); % Vetor para calcular distância
NM = []; M = [];
for v = 1:length(Y)
    NM(v,1) = dist(mRNM, Y(v,1));
    M(v,1) = dist(mRM, Y(v,1));
end

CLASS = [];
for w = 1:length(Y)
    if NM(w,1) < M(w,1)
        CLASS(w,1) = 1; % Não músico
    else
        CLASS(w,1) = 0; % Músico
    end
end

%GROUP = [0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1]; % 13-13
%GROUP = [0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1]; % 13 - 12
GROUP = [0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1]; %10 -10

FIM = [CLASS GROUP'];

ACERTO = 0;
for z=1:length(Y)
    if FIM(z,1)==FIM(z,2)
        ACERTO = ACERTO+1;
    end
end
TAXA = ACERTO/length(Y);
end
