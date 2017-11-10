%% Forward Kinematics
clear;
clf;
% Setup
l = [5; 5; 5]; %lengths of pieces
Phi = [30; 30; 30]; %Yaw
Th = [30;30;30]; %Pitch
Sig = [30;30;30]; %Roll

axlims = sum(l);


s = length(l);
% Calculating
totPhi = 0;
totTh = 0;
totSig = 0;
Pos = zeros(3,1);
T = zeros(4,4,s);
Transform = eye(4);
for i = 1:s
    if(i == 1)
        T(:,:,i) = TransMat3D(Phi(i), Th(i), Sig(i), [0; 0; 0]);
    else
        T(:,:,i) = TransMat3D(Phi(i), Th(i), Sig(i), [0; 0; l(i-1)]);
    end
    Transform = Transform * T(:,:,i);
    
    %totPhi = totPhi + Phi(i);
    %totTh = totTh + Th(i);
    %totSig = totSig + Sig(i);
    
    %add = Transform*[0;0;l(i);1] % * [sind(totTh)*cosd(totPhi); sind(totTh)*sind(totPhi); cosd(totTh)];
    %Pos = Pos + add(1:3);
end
Pos = Transform * [0;0;l(i);1];
%T = [TransMat(0, [0 0]);
%    TransMat(angs(2, i), [sum(base(1:3)) 0]);
%    TransMat(angs(1, i), [sum(mid(1:3)) 0])];

% Plotting
hold on;
plot3(Pos(1), Pos(2), Pos(3), 'ro')

%T(:,:,1)*[0 0; 0 l(1); 0 0]
Transform = eye(4);
for i = 1:s
    Transform = Transform * T(:,:,i);
    lineseg = Transform * [0 0 0 1; 0 0 l(i) 1]';
    plot3(lineseg(1,:), lineseg(2,:), lineseg(3,:), 'b-');
end
axis([-axlims axlims -axlims axlims -axlims axlims])
view([30, 30])

%% Inverse Kinematics
%clear;
%clf;
%l = [2;2;2;2;2;2;2;2;2;2];

%Phi = [30;30;30;30;30;30;30;30;30;30]; %Yaw
%Th = [30;30;30;30;30;30;30;30;30;30]; %Pitch
%Sig = [30;30;30;30;30;30;30;30;30;30]; %Roll

Pos = [-7;6;5];

%khat = [0;0;1;0];
%jhat = [0;1;0;0];
%ihat = [1;0;0;0];

axlims = sum(l);

s = length(l);
[P, T] = KForward3(l, Phi, Th, Sig);
count = 0;
EmptyTransforms = zeros(4,4,s+1);
for i = 1:s+1
    EmptyTransforms(:,:,i) = eye(4);
end
while(norm(P(:, end) - Pos) > .3)
    e = P(:,end);
    pivots = zeros(3,s);
    for i = 1:length(P)-1
        pivots(:,i) = P(:,end) - P(:,i);
    end
    JPhi = zeros(3,s);
    JTh = zeros(3,s);
    JSig = zeros(3,s);
    Transforms = EmptyTransforms;
    for j = 1:s
        Transforms(:,:,j+1) = Transforms(:,:,j) * T(:,:,j);
        %for i = 1:3
            %totPhi = sum(Phi(1:i));
        
        a = Transforms(:, :, j)*khat;
        b = Transforms(:, :, j+1)*jhat;
        c = Transforms(:, :, j+1)*ihat;
        tmpPhi = cross(a(1:3), pivots(:,j));
        tmpTh = cross(b(1:3), pivots(:,j));
        tmpSig = cross(c(1:3), pivots(:,j));
        JPhi(:,j) = tmpPhi;
        JTh(:,j) = tmpTh;
        JSig(:,j) = tmpSig;
        
        %end
    end
    JinvPhi = pinv(JPhi);
    JinvTh = pinv(JTh);
    JinvSig = pinv(JSig);
    [P, T] = KForward3(l, Phi, Th, Sig);
    de = P(:,end) - Pos;
    %de = de/norm(de) * 1;
    dPhi = JinvPhi * de;
    dTh = JinvTh * de;
    dSig = JinvSig * de;
    
    diffvec = [dPhi dTh dSig];
    diffvec = [diffvec(:,1)/norm(diffvec(:,1)) diffvec(:,2)/norm(diffvec(:,2)) diffvec(:,3)/norm(diffvec(:,3))] * 2;
    %diffvec(:,1)
    Phi = Phi - diffvec(:,1);
    Th = Th - diffvec(:,2);
    Sig = Sig - diffvec(:,3);
    norm(P(:, end) - Pos)
    %Transform = eye(4);
    clf;
    hold on;
    for i = 1:s
        lineseg = Transforms(:,:,i+1) * [0 0 0 1; 0 0 l(i) 1]';
        plot3(lineseg(1,:), lineseg(2,:), lineseg(3,:), 'b-');
        plot3(Pos(1), Pos(2), Pos(3), 'ro');
        view([30 30])
        axis([-axlims axlims -axlims axlims -axlims axlims])
    end
    getframe;
    count = count + 1;
end
%(Pos(1)^2 + Pos(2)^2 - l(1)^2 - l(2)^2)/(2*l(1)*l(2))
%cosrule = acos((Pos(1)^2 + Pos(2)^2 - l(1)^2 - l(2)^2)/(2*l(1)*l(2)))