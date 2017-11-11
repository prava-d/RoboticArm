function [ JointForces ] = JointForces( motorF, strX, strY, N)
%JOINTFORCES Summary of this function goes here
%   Detailed explanation goes here

    JointForces = zeros(2,N);
    for l = 1:size(strX, 1)
        motorF(l)
        strdiff_last = [0; 0];
        strdiff_next = [strX(l, 2) - strX(l, 1); strY(l, 2) - strY(l, 1)];
        
        for i = 1:N
            strdiff_next = [strX(1); strY(l, 2) - strY(l, 1)];
        end
    end
end

