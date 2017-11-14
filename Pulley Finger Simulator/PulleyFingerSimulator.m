%% Setup
clear;
clf;
%Setup
Th = [pi/3; pi/3]; %Initial Thetas, should be N long
r = [.02 .02]; %Joint Radii, should be N long.
k = [10 10 10 10]; % Spring constants of each of the tendons (Active tends first, then passive), should be L long
ldef = [.05 .05 .05 .05]; % Linear deformation caused by motor (how stretched is each string from initial deformation), should be M long
Lpos = [-.03 .03 -.01 .01; zeros(1, length(k))]; % Position of each string (Length L)
Jlen = [.05, .05]; % Length of each bone piece after each joint. (Length N)
Lconnect = .025*ones(1,4); % Point at which tendons connect on bars (Length L)
Jmass = [1 1]; % Mass of each bone piece after each joint (Length N);
Lang = [-1 -1; 1 1 ;-1 1; 1 -1]; %-1 is clockwise around joint; 1 is counter clockwise around joint (L*J)
Jposinit = [0; .05]; %set position for first Joint.

FingerTip = [-.01 .01 .01 -.01 -.01; 0 0 Jlen(end) Jlen(end) 0; ones(1,5)];
AxLen = .04;
Xaxis = [0 AxLen;0 0;1 1];
Yaxis = [0 0;0 AxLen;1 1];
%List of Lengths
L = length(k); %Number of Tendons
M = length(ldef); %Number of Actuators
N = length(Th); %Number of Joints.

%% Parameters of Interest
Th = [pi/2; pi/2]; %Initial Thetas, should be N long
k = [100 100 100 100]; % Spring constants of each of the tendons (Active tends first, then passive), should be L long
ldef = [.01 .01 .01 .01]; % Linear deformation caused by motor (how stretched is each string from initial deformation), should be M long
mdef = [.001 000 000 000]; %Acuator Deformation
steprate = 1;

simlen = 50;


% Initial Calculations
[~, FullTrans] = TransMatGen(zeros(length(Th),1), Jlen, Jposinit);
Jpos = zeros(3, N+1);
for i = 1:N
    Jpos(:,i) = FullTrans(:,:,i+1)*[0;0;1];
end

[strPosx, strPosy] = PulleyToStrPos(FullTrans, r, Lpos, Lang, Lconnect, Jposinit, Jlen, L, N);
[tendLenInit, adiffLast] = TendLenCalc(r, Jpos, strPosx, strPosy, Lang);
l0 = tendLenInit' - ldef
%% Simulate Finger




%Calculations
% [~, FullTrans] = TransMatGen(Th, Jlen, Jposinit);
% Jpos = zeros(3, N+1);
% for i = 1:N
%     Jpos(:,i) = FullTrans(:,:,i+1)*[0;0;1];
% end
% Jpos(:,end) = FullTrans(:,:,end)*[0;Lconnect(1);1];

for t = 1:simlen
    [~, FullTrans] = TransMatGen(Th, Jlen, Jposinit);
    Jpos = zeros(3, N+1);
    for i = 1:N
        Jpos(:,i) = FullTrans(:,:,i+1)*[0;0;1];
    end
    Jpos(:,end) = FullTrans(:,:,end)*[0;Lconnect(1);1];
    [strPosx, strPosy] = PulleyToStrPos(FullTrans, r, Lpos, Lang, Lconnect, Jposinit, Jlen, L, N);
    [tendLen, adiffLast] = TendLenCalc(r, Jpos(1:2, :), strPosx, strPosy, Lang, adiffLast);
    TForce = k.*(tendLen' - l0);
    disp(TForce)
    JointF = JointForces(TForce, strPosx, strPosy, N);
    %SOMETHING IS WRONG FROM JOINTF OR ITS DEPENDENCIES
    %The forces of lower joints seem to depend heavily on the rotation of
    %themselves, which idk if thats right
    %disp(JointF)
    clf;
    hold on;
    for i= 1:N+1
        ind=2*i;
        plot(strPosx(1,ind-1:ind), strPosy(1,ind-1:ind), 'bo-');
        plot(strPosx(2,ind-1:ind), strPosy(2,ind-1:ind), 'ro-');
        plot(strPosx(3,ind-1:ind), strPosy(3,ind-1:ind), 'mo-');
        plot(strPosx(4,ind-1:ind), strPosy(4,ind-1:ind), 'ko-');

    end
    NScale = zeros(N+1, 1);
    for i = 1:N
        xax = FullTrans(:,:,i)*Xaxis;
        yax = FullTrans(:,:,i)*Yaxis;
        plot(xax(1,:), xax(2,:), 'r--')
        plot(yax(1,:), yax(2,:), 'b--')

        xax = xax(1:2,2) - xax(1:2,1);
        xax = xax/norm(xax);
        NScale(i) = dot(xax, JointF(1:2,i));
        NF = NScale(i) * xax;
        plot(Jpos(1, i)+[0 JointF(1, i)], Jpos(2, i)+[0 JointF(2, i)], 'm--', 'LineWidth', 1)
        plot(Jpos(1, i)+[0 NF(1)], Jpos(2, i)+[0 NF(2)], 'k--', 'LineWidth', 1)
    end
    % FingerTip
    xax = FullTrans(:,:,end)*Xaxis;
    yax = FullTrans(:,:,end)*Yaxis;
    plot(xax(1,:), xax(2,:), 'r--')
    plot(yax(1,:), yax(2,:), 'b--')

    xax = xax(1:2,2) - xax(1:2,1);
    xax = xax/norm(xax);
    NScale(end) = dot(xax, JointF(1:2,end));
    NF = NScale(end) * xax;
    plot(Jpos(1, end)+[0 JointF(1, end)], Jpos(2, end)+[0 JointF(2, end)], 'm--', 'LineWidth', 1)
    plot(Jpos(1, end)+[0 NF(1)], Jpos(2, end)+[0 NF(2)], 'k--', 'LineWidth', 1)
    
    %disp(NScale)
    FingerPlot = FullTrans(:,:,end)*FingerTip;
    plot(FingerPlot(1,:), FingerPlot(2,:), 'k-o')
    for i = 1:length(Jlen)
        viscircles(Jpos(1:2,i)', r(i),'Color','k');
    end
    daspect([1,1,1])
    axis([-.1, .1, 0, .2])
    for i = 1:N
        Th(i) = Th(i) - NScale(i+1)*steprate;
    end
    getframe;
end
%MotForces = zeros(L, N+1, 2);
%for i = 1:L
%    MotForces(i,:,:) = ones(N+1,2)*motorForce(i);
%end
%ForceVecs = strDirs.*MotForces;


%Jj = [1; -1]; %Jacobian of each tendon's affect on the
