%% Simulation for the Pulley Finger
clear;
clf;
%Setup
initTh = [pi/6; -pi/6]; %Initial Thetas, should be N long
r = [.02 .02]; %Joint Radii, should be N long.
k = [100 100]; % Spring constants of each of the tendons (Active tends first, then passive), should be L long
Mdef = [.005 .006]; % Linear deformation caused by motor (how stretched is each string from initial deformation), should be M long
Lpos = [-.03 .03; zeros(1, length(k))]; % Position of each string (Length L)
Jlen = [.05, .05]; % Length of each bone piece after each joint. (Length N)
Lconnect = [.025 .025]; % Point at which tendons connect on bars (Length L)
Jmass = [1 1]; % Mass of each bone piece after each joint (Length N);
Lang = [-1 1; 1 -1]; %-1 is clockwise around joint; 1 is counter clockwise around joint (Length L)
Jpos = [0; .05]; %set position for first Joint.

[S, FullTrans] = TransMatGen(initTh, Jlen, Jpos)
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
motorForce = k.*Mdef;
[strPosx, strPosy] = PulleyToStrDirs(FullTrans, r, Lpos, Lang, Lconnect, Jpos, L, N);
hold on;
for i= 1:N
    ind=2*i
    plot([strPosx(1,ind-1) strPosx(1,ind)+strPosx(1,ind-1)], [strPosy(1,ind-1) strPosy(1,ind)+strPosy(1,ind-1)], 'b-');
    plot([strPosx(2,ind-1) strPosx(2,ind)+strPosx(2,ind-1)], [strPosy(2,ind-1) strPosy(2,ind)+strPosy(2,ind-1)], 'r-');
end
for i = 1:size(FullTrans,3)
    xax = FullTrans(:,:,i)*Xaxis;
    yax = FullTrans(:,:,i)*Yaxis;
    plot(xax(1,:), xax(2,:), 'r--')
    plot(yax(1,:), yax(2,:), 'b--')
end
plot(FingerTip(1,:), FingerTip(2,:), 'k-o')
for i = 1:length(Jlen)
    pulley = FullTrans(:,:,i+1)*[0;0;1];
    viscircles(pulley(1:2)', r(i),'Color','k');
end
daspect([1,1,1])
MotForces = zeros(L, N+1, 2);
for i = 1:L
    MotForces(i,:,:) = ones(N+1,2)*motorForce(i);
end
%ForceVecs = strDirs.*MotForces;


%Jj = [1; -1]; %Jacobian of each tendon's affect on the
