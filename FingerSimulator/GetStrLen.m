function [strlen] = GetStrLen(holepoints)
%GETSTRLEN Summary of this function goes here
%   Detailed explanation goes here
    strlen = 0;
    for i = 1:size(holepoints, 2)-1
        strlen = strlen + sqrt((holepoints(1, i)-holepoints(1,i+1))^2 + (holepoints(2, i)-holepoints(2, i+1))^2);
    end
end

