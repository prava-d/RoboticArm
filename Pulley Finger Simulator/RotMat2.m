function [ R ] = RotMat2( ang )
%ROTMAT2 Summary of this function goes here
%   Rotation Matrix in two dimensions, IN RADS

    R = [cos(ang) -sin(ang); sin(ang) cos(ang)];
end

