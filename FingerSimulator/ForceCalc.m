function [ force ] = ForceCalc(holes)
%FORCECALC Summary of this function goes here
%   holes is the GLOBAL position of the holes, not local
    diffs = [holes(:,1) - holes(:,2)  holes(:,3) - holes(:,2)];
    forces = .5 * [diffs(:, 1)/norm(diffs(:,1)) diffs(:,2)/norm(diffs(:,2))];
    force = forces(:, 1) + forces(:, 2);

end

