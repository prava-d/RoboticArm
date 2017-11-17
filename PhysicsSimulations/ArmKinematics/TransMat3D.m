function [ T ] = TransMat3D( Phi, Th, Sig, trans )
%TRANSMAT3D Summary of this function goes here
%   Detailed explanation goes here
    Rx = [1 0 0; 0 cosd(Sig) -sind(Sig); 0 sind(Sig) cosd(Sig)];
    Ry = [cosd(Th) 0 sind(Th); 0 1 0; -sind(Th) 0 cosd(Th)];
    Rz = [cosd(Phi) -sind(Phi) 0; sind(Phi) cosd(Phi) 0; 0 0 1];
    R = Rz * Ry * Rx;
    T = [[R;[0 0 0]] [trans;1]];
end

