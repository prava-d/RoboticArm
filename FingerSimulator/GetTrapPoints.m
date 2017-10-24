function [points] = GetTrapPoints(trap)
%GETTRAPPOINTS Summary of this function goes here
%   Detailed explanation goes here
    points = [0 0 1; trap(1) trap(4) 1; trap(1)+trap(2) trap(4) 1; trap(1)+trap(2)+trap(3) 0 1; 0 0 1]';
end

