function [ JointForces ] = JointForces( motorF, strX, strY, N)
%JOINTFORCES Summary of this function goes here
%   Detailed explanation goes here

    JointForces = zeros(2,N+1);
    for l = 1:size(strX, 1)
        
        strdiff_last = [0; 0];
        strdiff_next = [strX(l, 2) - strX(l, 1); strY(l, 2) - strY(l, 1)];
        
        for i = 1:N
            strdiff_last = strdiff_next;
            strdiff_next = [strX(l, 2*i+2) - strX(l, 2*i+1); strY(l, 2*i+2) - strY(l, 2*i+1)];
            JointForces(:,i) = JointForces(:,i) + (strdiff_next - strdiff_last)*motorF(l)/2;
        end
        JointForces(:, end) = JointForces(:, end) - strdiff_next*motorF(l);
    end
end

