function [ T ] = TransMat2( rot, trans )
%TRANSMAT Summary of this function goes here
%   Detailed explanation goes here

    T = [[RotMat2(rot);0 0] [trans(1); trans(2); 1]];
end

