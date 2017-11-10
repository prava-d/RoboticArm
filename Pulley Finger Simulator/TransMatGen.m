function [ SeqTrans, FullTrans ] = TransMatGen( rots, trans, Jfirstpos )
%TRANSMATGEN Summary of this function goes here



%   ANGLES ARE IN RADS
    mats = length(rots);
    SeqTrans = zeros(3,3,mats);
    FullTrans = zeros(3,3,mats+1);
    FullTrans(:,:,1) = eye(3);
    
    %FirstJointTransform
    SeqTrans(:,:,1) = [[RotMat2(rots(1)); 0 0] [Jfirstpos(1); Jfirstpos(2); 1]];
    FullTrans(:,:,2) = FullTrans(:,:,1)*SeqTrans(:,:,1);
    for i = 2:mats
        SeqTrans(:,:,i) = [[RotMat2(rots(i)); 0 0] [0; trans(i); 1]];
        FullTrans(:,:,i+1) = FullTrans(:,:,i)*SeqTrans(:,:,i);
    end
    %SeqTrans(:,:,end) = [[RotMat2(rots(end)); 0 0] [0; 0; 1]];
    %FullTrans(:,:,end) = FullTrans(:,:,end-1)*SeqTrans(:,:,end);
end

