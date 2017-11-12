function [ StrPosX StrPosY ] = PulleyToStrPos(Trans, r, Lpos, Lang, Lconnect, Jpos, Jlen, L, N)
%PULLEYTOFORCEVECS Summary of this function goes here
%   Detailed explanation goes here
    StrPosX = zeros(L,2*(N+1));
    StrPosY = zeros(L,2*(N+1));
    
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
    StrPosX(:,2) = Lpos(1,:) + newdiffs(1,:);
    StrPosY(:,2) = Lpos(2,:) + newdiffs(2,:);
    
    %% Subsequent Pulleys
    for j = 1:N-1
        firstpos = 0;
        secondpos = 0;
        theta_same = asin((r(j+1)-r(j))/Jlen(j));
        theta_cross = acos((r(j+1)+r(j))/Jlen(j));
        for i = 1:L
            if Lang(i, j) == Lang(i,j+1)
                firstpos = Trans(:, :, j+1)*TransMat2((pi/2+theta_same)*-Lang(i, j), [0 0])*[0; r(j); 1]
                secondpos = Trans(:, :, j+1)*TransMat2((pi/2-theta_same)*Lang(i, j+1), [0 Jlen(j)])*[0; -r(j+1); 1]
            else
                firstpos = Trans(:, :, j+1)*TransMat2(theta_cross*-Lang(i, j), [0 0])*[0; r(j); 1]
                secondpos = Trans(:, :, j+1)*TransMat2(theta_cross*Lang(i, j+1), [0 Jlen(j)])*[0; -r(j+1); 1]
            end
            StrPosX(i,2*j+1) = firstpos(1);
            StrPosY(i,2*j+1) = firstpos(2);
            StrPosX(i,2*j+2) = secondpos(1);
            StrPosY(i,2*j+2) = secondpos(2);
        end
    end
    
    
    %% Last Pulley
    
%     pdiffs = zeros(2, L);
%     for i = 1:L
%         dif =  - Trans(:,:,end)*[0;0;1];
%         pdiffs(:, i) = dif(1:2);
%     end
    newdiffs = zeros(2, L);
    wheelpoint = zeros(3,L);
    for i = 1:L
        fintie = Trans(:,:,end)*[0; Lconnect(i); 1];
        wheelEdgeAng = asin(r(end)/Lconnect(i));
        
        wheelpoint(:,i) = Trans(:,:,end) * TransMat2((pi/2-wheelEdgeAng)*-Lang(i,end), [0 0])*[0; r(end); 1]; 
        newdiffs(:,i) = fintie(1:2);
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

