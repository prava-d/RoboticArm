function [ momentarmlen ] = TorqCalc(ReferenceFrame, force, forceloc)
%TORQCALC Summary of this function goes here
%   Assuming the object rotates around its origin frame
%   forcedir is the direction of force
%   forceloc is the location at which force is happening.
    perpdir = cross(inv(ReferenceFrame) * force, [0; 0; 1]);
    %perpdir = perpdir/norm(perpdir)
    momentarmlen = dot(perpdir, inv(ReferenceFrame) * forceloc);

end