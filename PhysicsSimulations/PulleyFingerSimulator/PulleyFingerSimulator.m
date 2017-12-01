%% Setup
clear;
clf;
%Setup
Th = [pi/3; pi/3]; %Initial Thetas, should be N long
r = [.02 .02]; %Joint Radii, should be N long.
k = [10 10]; % Spring constants of each of the tendons (Active tends first, then passive), should be L long
ldef = [.05 .05]; % Linear deformation caused by motor (how stretched is each string from initial deformation), should be M long
Lpos = [-.02 .02; zeros(1, length(k))]; % Position of each string (Length L)
Jlen = [.05, .05]; % Length of each bone piece after each joint. (Length N)
Jwidth = .01*[1, 1]; %Width of each bone piece after each joint.
Lconnect = .025*ones(1,2); % Point at which tendons connect on bars (Length L)
Jmass = [1 1]; % Mass of each bone piece after each joint (Length N);
Lang = [-1 -1; 1 1]; %-1 is clockwise around joint; 1 is counter clockwise around joint (L*J)
Jposinit = [0; .05]; %set position for first Joint.

%List of Lengths
L = length(k); %Number of Tendons
M = length(ldef); %Number of Actuators
N = length(Th); %Number of Joints.

Bones = zeros(3, 5, N);
%Bones(:,:,i+1) = [-Jwidth(1) Jwidth(1) Jwidth(1) -Jwidth(1) -Jwidth(1); 0 0 Jlen(1) Jlen(1) 0; ones(1,5)];
for i = 1:N
    Bones(:,:,i) = [-Jwidth(i) Jwidth(i) Jwidth(i) -Jwidth(i) -Jwidth(i); 0 0 Jlen(i) Jlen(i) 0; ones(1,5)];
end
AxLen = .04;
Xaxis = [0 AxLen;0 0;1 1];
Yaxis = [0 0;0 AxLen;1 1];


%% Settings
Th = [pi/2 -pi/2]; %Initial Thetas, should be N long
k = [200 200]; % Spring constants of each of the tendons (Active tends first, then passive), should be L long
ldef = [.05 .05]; % Linear deformation caused by motor (how stretched is each string from initial deformation), should be M long
mdef = [.000 000]; %Acuator Deformation
steprate = .4;
simlen = 400;
drawForces = 1;
drawStrings = 1;
drawTransforms = 0;
drawBones = 1;
quickStop = 0;
%% Simulate Finger
ldef = [.05 .05];
clf;
close all;
figure();
% Initial Calculations
[~, FullTrans] = TransMatGen(zeros(length(Th),1), Jlen, Jposinit);
Jpos = zeros(3, N+1);
for i = 1:N
    Jpos(:,i) = FullTrans(:,:,i+1)*[0;0;1];
end

[strPosx, strPosy] = PulleyToStrPos(FullTrans, r, Lpos, Lang, Lconnect, Jposinit, Jlen, L, N);
[tendLenInit, adiffLast] = TendLenCalc(r, Jpos, strPosx, strPosy, Lang);
l0 = tendLenInit' - ldef;



%Calculations
% [~, FullTrans] = TransMatGen(Th, Jlen, Jposinit);
% Jpos = zeros(3, N+1);
% for i = 1:N
%     Jpos(:,i) = FullTrans(:,:,i+1)*[0;0;1];
% end
% Jpos(:,end) = FullTrans(:,:,end)*[0;Lconnect(1);1];
TForce = zeros(L, simlen);
pltTh = zeros(N, simlen);
for t = 1:simlen
    [~, FullTrans] = TransMatGen(Th, Jlen, Jposinit);
    Jpos = zeros(3, N+1);
    for i = 1:N
        Jpos(:,i) = FullTrans(:,:,i+1)*[0;0;1];
    end
    Jpos(:,end) = FullTrans(:,:,end)*[0;Lconnect(1);1];
    [strPosx, strPosy] = PulleyToStrPos(FullTrans, r, Lpos, Lang, Lconnect, Jposinit, Jlen, L, N);
    [tendLen, adiffLast] = TendLenCalc(r, Jpos, strPosx, strPosy, Lang, adiffLast);
    TForce(:, t) = k.*(tendLen'+mdef*t - l0);
    
    JointF = JointForces(TForce(:,t), strPosx, strPosy, N);
    %SOMETHING IS WRONG FROM JOINTF OR ITS DEPENDENCIES
    %The forces of lower joints seem to depend heavily on the rotation of
    %themselves, which idk if thats right
    %disp(JointF)
    clf;
    hold on;
    if drawStrings
        for i= 1:N+1
            ind=2*i;
            plot(strPosx(1,ind-1:ind), strPosy(1,ind-1:ind), 'b*-');
            plot(strPosx(2,ind-1:ind), strPosy(2,ind-1:ind), 'r*-');
            %plot(strPosx(3,ind-1:ind), strPosy(3,ind-1:ind), 'm*-');
            %plot(strPosx(4,ind-1:ind), strPosy(4,ind-1:ind), 'k*-');
        end
    end
    NScale = zeros(N+1, 1);
    for i = 1:N
        xax = FullTrans(:,:,i)*Xaxis;
        if drawTransforms
            yax = FullTrans(:,:,i)*Yaxis;
            plot(xax(1,:), xax(2,:), 'r--')
            plot(yax(1,:), yax(2,:), 'b--')
        end
        xax = xax(1:2,2) - xax(1:2,1);
        xax = xax/norm(xax);
        NScale(i) = dot(xax, JointF(1:2,i));
        if drawForces
            NF = NScale(i) * xax;
            plot(Jpos(1, i)+[0 JointF(1, i)], Jpos(2, i)+[0 JointF(2, i)], 'm--', 'LineWidth', 1)
            plot(Jpos(1, i)+[0 NF(1)], Jpos(2, i)+[0 NF(2)], 'k--', 'LineWidth', 1)
        end
    end
    % FingerTip
    xax = FullTrans(:,:,end)*Xaxis;
    if drawTransforms
        yax = FullTrans(:,:,end)*Yaxis;
        plot(xax(1,:), xax(2,:), 'r--')
        plot(yax(1,:), yax(2,:), 'b--')
    end

    xax = xax(1:2,2) - xax(1:2,1);
    xax = xax/norm(xax);
    NScale(end) = dot(xax, JointF(1:2,end));
    if drawForces
        NF = NScale(end) * xax;
        plot(Jpos(1, end)+[0 JointF(1, end)], Jpos(2, end)+[0 JointF(2, end)], 'm--', 'LineWidth', 1)
        plot(Jpos(1, end)+[0 NF(1)], Jpos(2, end)+[0 NF(2)], 'k--', 'LineWidth', 1)
    end
    
    %disp(NScale)
    if drawBones
        for i = 1:N
            BonePlot = FullTrans(:,:,i+1)*Bones(:,:,i);
            plot(BonePlot(1,:), BonePlot(2,:), 'k-')
        end
    end
    for i = 1:N
        viscircles(Jpos(1:2,i)', r(i),'Color','k');
    end
    daspect([1,1,1])
    axis([-.1, .1, 0, .2])
    if (quickStop && all(abs(NScale(2:end)) < .0005))
        TForce(:, t+1:end) = TForce(:, t)*ones(1, simlen-t);
        pltTh(:, t:end) = Th'*ones(1, simlen-t+1)
        break;
    end
    AScale = zeros(N, 1);
    for i = 1:N
        AScale(i) = NScale(i+1)/sum(Jmass(1:i));
    end
    %AScale
    Th = Th - NScale(2:end)'*steprate;
    pltTh(:, t) = Th;
    getframe;
end
figure()
hold on;
%for l = 1:L
plot(1:simlen, TForce(1,:), 'b-');
plot(1:simlen, TForce(2,:), 'r-');
%plot(1:simlen, TForce(3,:), 'm-');
%plot(1:simlen, TForce(4,:), 'k-');
%2end
figure();
hold on;
for n = 1:N
    plot(1:simlen, pltTh(n, :), '-');
end
legend('Joint1','Joint2');
