function [COM] = COMTrap(trap)
%COMTRAP Summary of this function goes here
%   Detailed explanation goes here
    COMs = [trap(1)*2/3 trap(4)/3 1/2*trap(4)/trap(1)*trap(1)^2;
        trap(1)+trap(2)/2 trap(4)/2 trap(2)*trap(4);
        trap(1)+trap(2)+trap(3)/3 trap(4)/3 1/2*trap(4)/trap(3)*trap(3)^2];
    COM = [0; 0; 0];
    for i = 1:3
        COM(1) = COM(1) + COMs(i,1) * COMs(i,3);
        COM(2) = COM(2) + COMs(i,2) * COMs(i,3);
        COM(3) = COM(3) + COMs(i,3);
    end
    
    COM(1) = COM(1) / COM(3);
    COM(2) = COM(2) / COM(3);
    COM(3) = 1;

end

