function [ maxang ] = ConstraintCalc(trap1, trap2)
%CONSTRAINTCALC Summary of this function goes here
%   Detailed explanation goes here
    ang1 = atan2(trap1(4),trap1(3));
    ang2 = atan2(trap2(4),trap2(1));
    maxang = (pi - (ang1 + ang2))*180/pi;
end

