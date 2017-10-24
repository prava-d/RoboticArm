%% define finger parameters

%Assumptions:
%   Mass doesnt affect the motion that much
%   The backing of the finger is the same size all the way through
%   The linear actuator can handle any force and thus we can abstract force to
%simply find in what orientation the finger will lie as the string length
%changes.
%   The force on the nearer sections of the finger are minimal (the part
%near the rotating bit for the finger subsection)
%   The spacing between the finger digits is negligable and thus they
%rotate around the point where they touch.

clear;
% define trapezoid shapes based on bottom, middle, and top length as well as height
base = [.5; 1; .5; .5];
mid = [.5; .5; .5; .5];
tip = [.5; 0; .5; .5];

% Place holes on the fingers
Hb = [GetTrapPoint(.4, base); GetTrapPoint(1.6, base)];
Hm = [GetTrapPoint(.4, mid); GetTrapPoint(1.1, mid)];
Ht = [GetTrapPoint(.4, tip); GetTrapPoint(.9, tip)];

% also set constraints for the fingers;
Cb = [0 0];
Cm = [0 ConstraintCalc(base, mid)];
Ct = [0 ConstraintCalc(mid, tip)];

% 2D transformation matrices for the fingers
Tb = [1 0 0; 0 1 0; 0 0 1];
Tm = [1 0 sum(base(1:3)); 0 1 0; 0 0 1];
Tt = [1 0 sum(mid(1:3)); 0 1 0; 0 0 1];

%% Determine Holes


%% try drawing the finger
clf;
hold on;
daspect([1 1 1])
Pb = Tb * GetTrapPoints(base);
plot(Pb(1,:), Pb(2,:))
Pm = Tb * Tm * GetTrapPoints(mid);
plot(Pm(1,:), Pm(2,:))
Pt = Tb * Tm * Tt * GetTrapPoints(tip);
plot(Pt(1,:), Pt(2,:))
holes = [(Tb * Hb') Tb * Tm * Hm' Tb * Tm * Tt * Ht'];
plot(holes(1,:), holes(2,:));

%% calculate str len
strlen = GetStrLen(holes);

%% Calculate direction of torque on the finger
% we only need to know the final point that the finger will be at based on
% string differnce.  Therefore the direction of torque determines the
% direction the finger piece moves and past that it is only important to
% make the string the correct length.  The relative torque between the
% each of the points of string that produce a force on the finger
% determines how much each part of the finger turns.  Of course the backing
% of the finger, the bendy part, whatever that is, it also determines how
% much each part of the finger can turn.  Similarly, I make the assumption
% that the linear actuator has the required force to pull it, therefore it
% is only the relative thickness of each of those pieces that determines
% how they interact, gotta figure that out at some point, but for now im
% abstracting that material out.

%Testing
% forcestr = (holes(:,end-1) - holes(:,end))/norm(holes(:,end-1) - holes(:,end));
% forcestr2 = ForceCalc([holes(:, 3) holes(:, 4) holes(:,5)]);
% testtorques = [TorqCalc(forcestr, holes(:,end)) TorqCalc(forcestr2, holes(:, 4))];
% dir = sign(testtorque);

%Run simulation for moving finger to final position for a range of string
%lengths to see how finger moves as it's pulled
finglen = sum([base(1:3); mid(1:3); tip(1:3)]);
threshold = .001;
targetlen = 3;
inc = 5;
steps = 200;
strlen = zeros(steps+1, 1);
strlen(1) = finglen;
angs = zeros(2, steps+1);

for i = 1:steps
    %Set axis
    clf;
    hold on;
    axis([-finglen finglen -finglen finglen])

    %Set transformation based on determined orientation
    Tb = TransMat(0, [0 0]);
    Tm = TransMat(angs(2, i), [sum(base(1:3)) 0]);
    Tt = TransMat(angs(1, i), [sum(mid(1:3)) 0]);

    Pb = Tb * GetTrapPoints(base);
    Pm = Tb * Tm * GetTrapPoints(mid);
    Pt = Tb * Tm * Tt *  GetTrapPoints(tip);
    plot(Pb(1,:), Pb(2,:), 'b-');
    plot(Pm(1,:), Pm(2,:), 'm-');
    plot(Pt(1,:), Pt(2,:), 'r-');

    Os = [Tb*zeros(3,1) Tb*Tm*zeros(3,1) Tb*Tm*Tt*zeros(3,1)];
    %Transform and plot Finger Holes
    holes = [(Tb * Hb') Tb * Tm * Hm' Tb * Tm * Tt * Ht'];

    %Determine forces and torques
    forcestr = (holes(:,end-1) - holes(:,end))/norm(holes(:,end-1) - holes(:,end));
    forcestr2 = ForceCalc([holes(:, 3) holes(:, 4) holes(:,5)]);
    totforce = norm(forcestr) + norm(forcestr2);
    testtorques = [TorqCalc(Tb*Tm*Tt, forcestr/totforce, holes(:,end)); TorqCalc(Tb*Tm, forcestr2/totforce, holes(:, 4))];

    strlen(i+2) = GetStrLen(holes);
    plot(holes(1,:), holes(2,:), 'k-');

    if strlen(i+2) == targetlen || all(isnan(testtorques))
        angs(1, i+1:end) = angs(1, i);
        angs(2, i+1:end) = angs(2, i);
        break
    end
    isnan(testtorques)
    testtorques(isnan(testtorques)) = 0;

    %Determine change in angle
    angs(:, i+1) = angs(:, i) + testtorques*inc;

    %constrain anglesc
    %angs(3) = min(max(0, Cb(1)), Cb(2));
    angs(2, i+1) = min(max(angs(2, i+1), Cm(1)), Cm(2));
    angs(1, i+1) = min(max(angs(1, i+1), Ct(1)), Ct(2));


    %Transform and plot COMs
    %COMs = [Tb * COMTrap(base) Tb * Tm * COMTrap(mid) Tb * Tm * Tt * COMTrap(tip)];
    %plot(COMs(1,:), COMs(2,:), 'kx')
    
    M(i+1) = getframe;
    if i ~= 0 && abs(targetlen - strlen(i+2)) > abs(targetlen - strlen(i+1)) && abs(targetlen - strlen(i+2)) > threshold
        inc = inc / -2;
    end
end

figure();
hold on;
plot(angs(1, :), 'r-')
plot(angs(2, :), 'm-')
figure();
plot(strlen, 'k-')

%movie(M,2)
%% animate bending of each digit
clear M;
clf;
hold on;
strlen = zeros(90,1);
for i = 0:90
    %Set axis
    clf;
    hold on;
    axis([-6 6 -6 6])
    
    %Determine finger orientation with constraint
    degb = min(max(i, Cb(1)), Cb(2));
    degm = min(max(i, Cm(1)), Cm(2));
    degt = min(max(i, Ct(1)), Ct(2));
    
    %Set transformation based on determined orientation
    Tb = TransMat(degb, [0 0]);
    Tm = TransMat(degm, [2 0]);
    Tt = TransMat(degt, [2 0]);
    
    %Transform and plot finger pieces
    Pb = Tb * GetTrapPoints(base);
    Pm = Tb * Tm * GetTrapPoints(mid);
    Pt = Tb * Tm * Tt *  GetTrapPoints(tip);
    plot(Pb(1,:), Pb(2,:));
    plot(Pm(1,:), Pm(2,:));
    plot(Pt(1,:), Pt(2,:));
    
    
    %Transform and plot Finger Holes
    holes = [(Tb * Hb') Tb * Tm * Hm' Tb * Tm * Tt * Ht'];
    plot(holes(1,:), holes(2,:), 'k-');
    
    %Transform and plot COMs
    %COMs = [Tb * COMTrap(base) Tb * Tm * COMTrap(mid) Tb * Tm * Tt * COMTrap(tip)];
    %plot(COMs(1,:), COMs(2,:), 'kx')
    strlen(i+1) = GetStrLen(holes);
    
    M(i+1) = getframe;
end
disp(strlen)

%figure
movie(M,2)

%% Determine Center of mass for each trapazoid.
mass = 1;

COMTrap(trap)