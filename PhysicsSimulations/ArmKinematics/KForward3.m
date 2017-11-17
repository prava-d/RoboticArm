function [ P, T ] = KForward3( l, Phi, Th, Sig )
%FORWARD Summary of this function goes here
%   Detailed explanation goes here

s = length(l);
% Calculating
P = zeros(4,s+1);
T = zeros(4,4,s);
Transform = eye(4);
for i = 1:s
    if(i == 1)
        T(:,:,i) = TransMat3D(Phi(i), Th(i), Sig(i), [0; 0; 0]);
    else
        T(:,:,i) = TransMat3D(Phi(i), Th(i), Sig(i), [0; 0; l(i-1)]);
    end
    Transform = Transform * T(:,:,i);
    P(:, i+1) = Transform * [0;0;l(i);1];
    %totPhi = totPhi + Phi(i);
    %totTh = totTh + Th(i);
    %totSig = totSig + Sig(i);
    
    %add = Transform*[0;0;l(i);1] % * [sind(totTh)*cosd(totPhi); sind(totTh)*sind(totPhi); cosd(totTh)];
    %Pos = Pos + add(1:3);
end
P = P(1:3, :);
end



