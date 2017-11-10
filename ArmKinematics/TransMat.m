function [T] = TransMat(deg, trans)
%ROTMAT Summary of this function goes here
%   Detailed explanation goes here
    T = [cosd(deg) -sind(deg) trans(1); sind(deg) cosd(deg) trans(2); 0 0 1];
end

