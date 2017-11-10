function [ StrPosX StrPosY ] = PulleyToStrDirs(Trans, r, Lpos, Lang, Lconnect, Jpos, L, N)
%PULLEYTOFORCEVECS Summary of this function goes here
%   Detailed explanation goes here
    StrPosX = zeros(L,2*N);
    StrPosY = zeros(L,2*N);
    
    pdiffs = zeros(2, L);
    for i = 1:L
        pdiffs(:, i) = Jpos(:,1) - Lpos(:,i);
    end
    newdiffs = zeros(2, L);
    for i = 1:L
        strlen = norm(pdiffs(:, i));
        %groundAng = atan2(pdiffs(2,i), pdiffs(1,i))
        wheelEdgeAng = asin(r(1)/strlen);
        %finAng = groundAng + 
        newdiffs(:,i) = RotMat2(wheelEdgeAng*-Lang(i,1)) * pdiffs(:, i);
    end
    StrPosX(:,1) = Lpos(1,:);
    StrPosY(:,1) = Lpos(2,:);
    StrPosX(:,2) = newdiffs(1,:);
    StrPosY(:,2) = newdiffs(2,:);
    
    %% Subsequent Pulleys
    
    
    %% Last Pulley
    
    pdiffs = zeros(2, L);
    for i = 1:L
        dif = Trans(:,:,end)*[0; Lconnect(i); 1] - Trans(:,:,end)*[0;0;1];
        pdiffs(:, i) = dif(1:2);
    end
    newdiffs = zeros(2, L);
    wheelpoints = zeros(3,L);
    for i = 1:L
        strlen = norm(pdiffs(:, i));
        %groundAng = atan2(pdiffs(2,i), pdiffs(1,i))
        wheelEdgeAng = asin(r(end)/strlen)
        
        wheelpoint(:,i) = Trans(:,:,end) *TransMat2(pi/2-wheelEdgeAng, [0 0])*[0; r(end); 1];
        %finAng = groundAng + 
        newdiffs(:,i) = RotMat2(wheelEdgeAng*Lang(i,end)) * pdiffs(:, i);
    end
    StrPosX(:,end-1) = wheelpoint(1,:);
    StrPosY(:,end-1) = wheelpoint(2,:);
    StrPosX(:,end) = newdiffs(1,:);
    StrPosY(:,end) = newdiffs(2,:);
    
%     pdiff = zeros(Lpos, Jpos);
%     for i = 1:Lpos
%             pdiffs(i,1) = Jpos(j) - Lpos(i);
%     end
%     for j = 1:Jpos
%         for i = 1:Lpos
%             pdiffs(i,j) = Jpos(j) - 
%         end
%     end
%     ForceVecs(1) = 
%     ForceVecs = 
end

