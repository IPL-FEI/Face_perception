function Predicted = erclassEuclidiandist(Y, mGroup1, mGroup2)
% DESCRIPTION
%   Calculate the Euclidian distance of each mean group. Classify based on
%   the lowest distance.
%
% INPUTS
% [Y]           (vector [nx1]) Data on discriminate axis. 
% [mGroup1]     (scalar) Mean Group 1
% [mGroup2]     (scalar) Mean Group 2
%
% OUTPUTS
%  [Predicted]  (vector [nx1]) Predicted group for the X sample
%               Group1 = 0 | Group2 = 1
% AUTHOR
%   Estela Ribeiro, November 2018
% =========================================================================
Y = Y(:);

distGroup1 = []; distGroup2 = [];
% Calculate the EuclidianDistance for all points based on the mean of each
% group
for v = 1:length(Y)
    distGroup1(v,1) = sum((mGroup1-Y(v)).^2).^0.5;
    distGroup2(v,1) = sum((mGroup2-Y(v)).^2).^0.5;
end

% Predicted group for the X sample
Predicted = [];
for w = 1:length(Y)
    if distGroup1(w,1) < distGroup2(w,1)
        Predicted(w,1) = 0; % Group 1
    else
        Predicted(w,1) = 1; % Group 2
    end
end

end