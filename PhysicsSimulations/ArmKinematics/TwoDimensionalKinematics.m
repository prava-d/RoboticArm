%% Forward Kinematics
clear;
clf;
% Setup
l = [5; 5; 5]; %lengths of pieces
Th = [30; 15; 15]; %orientation

s = length(l);

% Calculating
totTh = 0;
Pos = zeros(3,1);
T = zeros(3,3,s);
for i = 1:s
    totTh = totTh + Th(i);
    add = l(i) * [cosd(totTh); sind(totTh); 0];
    Pos = Pos + add;
    if(i == 1)
        T(:,:,i) = TransMat(Th(i), [0; 0]);
    else
        T(:,:,i) = TransMat(Th(i), [l(i-1); 0]);
    end
end

%T = [TransMat(0, [0 0]);
%    TransMat(angs(2, i), [sum(base(1:3)) 0]);
%    TransMat(angs(1, i), [sum(mid(1:3)) 0])];

% Plotting
hold on;
plot(Pos(1), Pos(2), 'ro')

%T(:,:,1)*[0 0; 0 l(1); 0 0]
Transform = eye(3);
for i = 1:s
    Transform = Transform * T(:,:,i);
    lineseg = Transform * [0 0 1; l(i) 0 1]';
    plot(lineseg(1,:), lineseg(2,:), 'b-');
end

%% Inverse Kinematics
clear;
clf;
l = [8; 6; 4; 2; 1];
Th = [30;30;30;30;30];
Pos = [-10; -4; 0];
khat = [0;0;1];
axlims = sum(l);
s = length(l);
[P, T] = KForward(l, Th);
count = 0;
while(norm(P(:, end) - Pos) > .5)
    e = P(:,end);
    pivots = zeros(3,s);
    for i = 1:length(P)-1
        pivots(:,i) = P(:,end) - P(:,i);
    end

    J = zeros(3,s);
    for i = 1:3
        for j = 1:s
            tmp = cross(khat, pivots(:,j));
            J(i,j) = tmp(i);
        end
    end
    Jinv = pinv(J);
    [P, T] = KForward(l, Th);
    de = P(:,end) - Pos;
    de = de/norm(de)*50;
    dTh = Jinv * de;
    Th = Th - dTh;
    norm(P(:, end) - Pos)
    Transform = eye(3);
    clf;
    hold on;
    for i = 1:s
        Transform = Transform * T(:,:,i);
        lineseg = Transform * [0 0 1; l(i) 0 1]';
        plot(lineseg(1,:), lineseg(2,:), 'b-');
        plot(Pos(1), Pos(2), 'ro');
        axis([-axlims axlims -axlims axlims])
    end
    getframe;
    count = count + 1;
end
%(Pos(1)^2 + Pos(2)^2 - l(1)^2 - l(2)^2)/(2*l(1)*l(2))
%cosrule = acos((Pos(1)^2 + Pos(2)^2 - l(1)^2 - l(2)^2)/(2*l(1)*l(2)))