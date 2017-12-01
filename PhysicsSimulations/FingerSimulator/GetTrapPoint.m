function [point] = GetTrapPoint(x, trap)
%GETTRAPPOINT Summary of this function goes here
%   Detailed explanation goes here
    if 0 < x && x < trap(1)
        y= x*trap(4)/trap(1);
    elseif x < trap(1) + trap(2)
        y= trap(4);
    elseif x < trap(1) + trap(2) + trap(3)
        y= (x - (trap(1)+trap(2)+trap(3))) * -trap(4)/trap(3);
    end
    point = [x y 1];
end