function [ tendLen adiffLastout] = TendLenCalc(r, Jpos, strX, strY, Lang, adiffLast)
%TENDLENCALC Summary of this function goes here
%   Detailed explanation goes here

    L = size(strX,1);
    J = size(Jpos,2);
    tendLen = zeros(L, 1);
    adiffLastout = zeros(L, J);
    for l = 1:L
        for j = 1:J
            tendLen(l) = tendLen(l) + norm([strX(l, 2*j) - strX(l,2*j-1); strY(l, 2*j)- strY(l,2*j-1)]);
        end
        for j = 1:J-1
             pstart = [strX(l, 2*j); strY(l, 2*j)]-Jpos(1:2, j);
             pend = [strX(l, 2*j+1); strY(l, 2*j+1)]-Jpos(1:2, j);
             astart = atan2(pstart(2), pstart(1));
             aend = atan2(pend(2), pend(1));
             adiff = mod((aend-astart)+pi, 2*pi)-pi;
             if Lang(l, j) == sign(adiff)
                 adiff = 2*pi + abs(adiff);
             else
                 adiff = 2*pi - abs(adiff);
             end
             if nargin == 6
                 if abs(adiff - adiffLast(l, j)) > pi
                     adiff = adiff + sign(adiffLast(l,j)-adiff)*2*pi;
                 end
             end
             tendLen(l) = tendLen(l) + adiff*r(j);
             adiffLastout(l,j) = adiff;
        end
    end
end
