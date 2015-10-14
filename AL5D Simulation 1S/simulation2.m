clear; clc;

global BASE_HEIGHT HUMERUS ULNA HAND threshold deltamax;
BASE_HEIGHT = 169.0;   % base height (all mm)
HUMERUS = 146.05;      % shoulder to elbow
ULNA = 187.325;        % elbow to wrist 
HAND = 90.0;           % wrist to gripper tip

threshold = 10;
deltamax = 7.5; % Inaccuracy

% basAngle_d = 202.5;
% shlAngle_d = 47.8998;
% elbAngle_d = 42.6840;
% wriAngle_d = 179.4161;

basAngle_d = 90;
shlAngle_d = 90;
elbAngle_d = 90;
handAngle_d = -90;

[~, ~, tip] = forwardsKinematics(basAngle_d, shlAngle_d, elbAngle_d, handAngle_d );

[shlAngle_d, elbAngle_d, wriAngle_d] = inverseKinematics(sqrt(tip(1)^2+tip(2)^2)-100, tip(3), handAngle_d);

[elb, wri, tip] = forwardsKinematics(basAngle_d, shlAngle_d, elbAngle_d, handAngle_d );

bas = [0, 0, 0];
shl = [0, 0, BASE_HEIGHT];
tip_r = sqrt(tip(1)^2+tip(2)^2);

plot3([bas(1) shl(1) elb(1) wri(1) tip(1)],[bas(2) shl(2) elb(2) wri(2) tip(2)],[bas(3) shl(3) elb(3) wri(3) tip(3)],'b')

pos1 = [tip_r, basAngle_d, tip(3), handAngle_d];
pos2 = [tip_r,180,tip(3),handAngle_d];
duration = 100;
tvec = 0:duration; 

[rfn, afn, zfn, dfn, sfn, efn, wfn, deltafn] = anglefns(pos1, pos2, duration);

[elb, wri, tip] = forwardsKinematics(afn(tvec), sfn(tvec,0), efn(tvec,0), dfn(tvec));

for i = 1:length(tvec)
    t1 = findZeroPrev(@(t)deltafn(t,tvec(i),10),tvec(i));
    t2 = findZeroPrev(@(t)deltafn(t,t1,10),t1);
    n = 100;
    tvec2 = linspace(t2,tvec(i),n); % The vector of t-values that are in the probable area
    avec = afn(tvec2);
    svec = sfn(tvec2,0);
    rvec = rfn(tvec2);
    zvec = zfn(tvec2);
    a = afn(t1);
    s = sfn(t1,0);
    [elb2, wri2, tip2] = forwardsKinematics(a, s, efn(t1,0), dfn(t1));
    stda = 3.33;
    stds = 3.33;
    lim = 3;
%     stepsize = 500;
%     avec = linspace(a-lim*stda,a+lim*stda,stepsize);
%     svec = linspace(s-lim*stds,s+lim*stds,stepsize)';
    ux = HUMERUS*cosd(svec).*sind(avec);
    uy = HUMERUS*cosd(svec).*cosd(avec);
    uz = HUMERUS*sind(svec).*ones(size(avec))+BASE_HEIGHT;
    c = normpdf(svec,s,stds).*normpdf(avec,a,stda);
    c = c./max(max(c));
    c = ones(n,1)*c;
    
    for j=1:n
        x1(:,j) = linspace(shl(1),ux(j),n)';
        x2(:,j) = linspace(ux(j),sind(avec(j))*rvec(j),n)';
        x3(:,j) = linspace(sind(avec(j))*rvec(j),sind(avec(j))*rvec(j),n)';
        y1(:,j) = linspace(shl(2),uy(j),n)';
        y2(:,j) = linspace(uy(j),cosd(avec(j))*rvec(j),n)';
        y3(:,j) = linspace(cosd(avec(j))*rvec(j),cosd(avec(j))*rvec(j),n)';
        z1(:,j) = linspace(shl(3),uz(j),n)';
        z2(:,j) = linspace(uz(j),zvec(j)+HAND,n)';
        z3(:,j) = linspace(zvec(j)+HAND,zvec(j),n)';
    end
    
    plot3([bas(1) shl(1) elb(1,i) wri(1,i) tip(1,i)],[bas(2) shl(2) elb(2,i) wri(2,i) tip(2,i)],[bas(3) shl(3) elb(3,i) wri(3,i) tip(3,i)],'b',[bas(1) shl(1) elb2(1) wri2(1) tip2(1)],[bas(2) shl(2) elb2(2) wri2(2) tip2(2)],[bas(3) shl(3) elb2(3) wri2(3) tip2(3)],'r');
    axis([-500, 500, -500, 500, 0, 500])
    view(37.5,30)

    xlabel('x');
    ylabel('y');
    zlabel('z');
    hold on
    surf(x1,y1,z1,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',c)
    surf(x2,y2,z2,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',c)
    surf(x3,y3,z3,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',c)
    shading interp;
    colormap([1 0 0]);
    hold off
    pause(0.02)
end
    
% 
% %       drawnow
% %       frame = getframe(1);
% %       im = frame2im(frame);
% %       [imind,cm] = rgb2ind(im,256);
% % 
% %       if i == 2;
% %           imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1);
% %       else
% %           imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
% %       end
%       
% 
% 
% % pause(0.01);
% 
% end
% close

% create2dgif(rfn, afn, zfn, dfn, sfn, efn, wfn, deltafn, tvec)