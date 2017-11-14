%% Simulation for the Pulley Finger
clear;
clf;
%Setup
initTh = [pi/3; pi/3]; %Initial Thetas, should be N long
r = [.02 .02]; %Joint Radii, should be N long.
k = [100 100 100 100]; % Spring constants of each of the tendons (Active tends first, then passive), should be L long
Mdef = [.005 .005 .005 .005]; % Linear deformation caused by motor (how stretched is each string from initial deformation), should be M long
Lpos = [-.03 .03 -.01 .01; zeros(1, length(k))]; % Position of each string (Length L)
Jlen = [.05, .05]; % Length of each bone piece after each joint. (Length N)
Lconnect = .025*ones(1,4); % Point at which tendons connect on bars (Length L)
Jmass = [1 1]; % Mass of each bone piece after each joint (Length N);
Lang = [-1 -1; 1 1 ;-1 1; 1 -1]; %-1 is clockwise around joint; 1 is counter clockwise around joint (L*J)
Jposinit = [0; .05]; %set position for first Joint.

[S, FullTrans] = TransMatGen(initTh, Jlen, Jposinit);
FingerTip = [-.01 .01 .01 -.01 -.01; 0 0 Jlen(end) Jlen(end) 0; ones(1,5)];
FingerTip = FullTrans(:,:,end)*FingerTip;
AxLen = .04;
Xaxis = [0 AxLen;0 0;1 1];
Yaxis = [0 0;0 AxLen;1 1];


%List of Lengths
L = length(k); %Number of Tendons
M = length(Mdef); %Number of Actuators
N = length(initTh); %Number of Joints.


%Calculations
Jpos = zeros(3, N+1);
for i = 1:N
    Jpos(:,i) = FullTrans(:,:,i+1)*[0;0;1];
end
Jpos(:,end) = FullTrans(:,:,end)*[0;Lconnect(1);1];

motorForce = -k(1:length(Mdef)).*Mdef;
[strPosx, strPosy] = PulleyToStrPos(FullTrans, r, Lpos, Lang, Lconnect, Jposinit, Jlen, L, N);
JointF = JointForces(motorForce, strPosx, strPosy, N);
hold on;
for i= 1:N+1
    ind=2*i;
    plot(strPosx(1,ind-1:ind), strPosy(1,ind-1:ind), 'bo-');
    plot(strPosx(2,ind-1:ind), strPosy(2,ind-1:ind), 'ro-');
    plot(strPosx(3,ind-1:ind), strPosy(3,ind-1:ind), 'mo-');
    plot(strPosx(4,ind-1:ind), strPosy(4,ind-1:ind), 'ko-');
    
end
NScale = zeros(N, 1);
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

plot(FingerTip(1,:), FingerTip(2,:), 'k-o')
for i = 1:length(Jlen)
    pulley = FullTrans(:,:,i+1)*[0;0;1];
    viscircles(pulley(1:2)', r(i),'Color','k');
end
daspect([1,1,1])
axis([-.1, .1, 0, .2])
%MotForces = zeros(L, N+1, 2);
%for i = 1:L
%    MotForces(i,:,:) = ones(N+1,2)*motorForce(i);
%end
%ForceVecs = strDirs.*MotForces;


%Jj = [1; -1]; %Jacobian of each tendon's affect on the
