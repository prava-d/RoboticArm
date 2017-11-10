function [ P, T ] = KForward( l, Th )
%FORWARD Summary of this function goes here
%   Detailed explanation goes here

s = length(l);

% Calculating
totTh = 0;
P = zeros(3,s+1);
T = zeros(3,3,s);
for i = 1:s
    totTh = totTh + Th(i);
    add = l(i) * [cosd(totTh); sind(totTh); 0];
    P(:, i+1) = P(:, i) + add;
    if(i == 1)
        T(:,:,i) = TransMat(Th(i), [0; 0]);
    else
        T(:,:,i) = TransMat(Th(i), [l(i-1); 0]);
    end
end
end

