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

% ri = wri_r;
% hi = wri_h;
% theta0 = basAngle_d;

% dr = -0.5;   
% dh = 1;
% dtheta = -0.5;
% hvec = tip_h:dh:225.05;
% dr = 0.5;   
% dh = -1;
% dtheta = 0.5;
% hvec = tip_h:dh:0;
% hlen = length(hvec)-1;
% rvec = ri:dr:(ri+hlen*dr);
% thvec = theta0:dtheta:(theta0+hlen*dtheta);
bas = [0, 0, 0];
shl = [0, 0, BASE_HEIGHT];
tip_r = sqrt(tip(1)^2+tip(2)^2);

plot3([bas(1) shl(1) elb(1) wri(1) tip(1)],[bas(2) shl(2) elb(2) wri(2) tip(2)],[bas(3) shl(3) elb(3) wri(3) tip(3)],'b')

pos1 = [tip_r, basAngle_d, tip(3), handAngle_d];
pos2 = [tip_r,180,tip(3),handAngle_d];
duration = 10;
tvec = linspace(0,duration,150); 

[rfn, afn, zfn, dfn, sfn, efn, wfn, deltafn] = anglefns(pos1, pos2, duration);

[elb, wri, tip] = forwardsKinematics(afn(tvec), sfn(tvec,0), efn(tvec,0), dfn(tvec));

filename = '3dfig02.gif';
opengl software

% for i = 1:length(tvec)
%     t1 = findZeroPrev(@(t)deltafn(t,tvec(i),10),tvec(i));
%     t2 = findZeroPrev(@(t)deltafn(t,t1,10),t1);
%     n = 100;
%     tvec2 = linspace(t2,tvec(i),n); % The vector of t-values that are in the probable area
%     avec = afn(tvec2);
%     svec = sfn(tvec2,0);
%     rvec = rfn(tvec2);
%     zvec = zfn(tvec2);
%     a = afn(t1);
%     s = sfn(t1,0);
%     [elb2, wri2, tip2] = forwardsKinematics(a, s, efn(t1,0), dfn(t1));
%     stda = 4;
%     stds = 4;
%     lim = 3;
% %     stepsize = 500;
% %     avec = linspace(a-lim*stda,a+lim*stda,stepsize);
% %     svec = linspace(s-lim*stds,s+lim*stds,stepsize)';
%     ux = HUMERUS*cosd(svec).*sind(avec);
%     uy = HUMERUS*cosd(svec).*cosd(avec);
%     uz = HUMERUS*sind(svec).*ones(size(avec))+BASE_HEIGHT;
%     c = normpdf(svec,s,stds).*normpdf(avec,a,stda); % Assuming IID random variables
%     c = 0.67*c./max(max(c)); % Scale to reflect probability more clearly
%     c = ones(n,1)*c;
%     
%     for j=1:n
%         x1(:,j) = linspace(shl(1),ux(j),n)';
%         x2(:,j) = linspace(ux(j),sind(avec(j))*rvec(j),n)';
%         x3(:,j) = linspace(sind(avec(j))*rvec(j),sind(avec(j))*rvec(j),n)';
%         y1(:,j) = linspace(shl(2),uy(j),n)';
%         y2(:,j) = linspace(uy(j),cosd(avec(j))*rvec(j),n)';
%         y3(:,j) = linspace(cosd(avec(j))*rvec(j),cosd(avec(j))*rvec(j),n)';
%         z1(:,j) = linspace(shl(3),uz(j),n)';
%         z2(:,j) = linspace(uz(j),zvec(j)+HAND,n)';
%         z3(:,j) = linspace(zvec(j)+HAND,zvec(j),n)';
%     end
%     
%     hFig = figure(1);
%     set(hFig,'units','normalized','outerposition',[0 0 0.6 0.9]);
% 
%     h = plot3([bas(1) shl(1) elb(1,i) wri(1,i) tip(1,i)],[bas(2) shl(2) elb(2,i) wri(2,i) tip(2,i)],[bas(3) shl(3) elb(3,i) wri(3,i) tip(3,i)],'g','Color',[0.2 0.9 0.1],'LineWidth',1.5);%,[bas(1) shl(1) elb2(1) wri2(1) tip2(1)],[bas(2) shl(2) elb2(2) wri2(2) tip2(2)],[bas(3) shl(3) elb2(3) wri2(3) tip2(3)],'r');
%     axis([min([elb(1,:) wri(1,:) tip(1,:)]), max([elb(1,:) wri(1,:) tip(1,:)]), min([elb(2,:) wri(2,:) tip(2,:)]), max([elb(2,:) wri(2,:) tip(2,:)]), 0, max([elb(3,:) wri(3,:) tip(3,:)])]);
%     view(37.5,30)
% 
%     xlabel('x (mm)','FontWeight','bold','fontsize',14);
%     xlabh = get(gca,'XLabel');
%     set(xlabh,'Position',get(xlabh,'Position') + [-60 +30 0])
%     ylabel('y (mm)','FontWeight','bold','fontsize',14);
%     ylabh = get(gca,'YLabel');
%     set(ylabh,'Position',get(ylabh,'Position') + [-30 +60 0])
%     zlabel('z (mm)','FontWeight','bold','fontsize',14);
%     hold on
%     h(2) = plot3(tip(1,:),tip(2,:),tip(3,:),'k--','Color',[0.3,0.3,0.3]);
%     h(3) = surf(x1,y1,z1,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',c);
%     surf(x2,y2,z2,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',c)
%     surf(x3,y3,z3,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',c)
%     title('Robot Arm Position Estimation During Collision','fontweight','bold','fontsize',20)
%     hlegend = legend(h([1 3 2]),'Anticipated Position','Possible Position','Travel Path','Location','BestOutside');
%     set(hlegend,'FontSize',12)
%     shading interp;
%     colormap([1 0 0]);
%     set(gca, ...
%       'Box'         , 'off'     , ...
%       'TickDir'     , 'out'     , ...
%       'TickLength'  , [.02 .02] , ...
%       'XMinorTick'  , 'on'      , ...
%       'YMinorTick'  , 'on'      , ...
%       'ZMinorTick'  , 'on'      , ...
%       'XColor'      , [.3 .3 .3], ...
%       'YColor'      , [.3 .3 .3], ...
%       'ZColor'      , [.3 .3 .3], ...
%       'LineWidth'   , 1         );
%     set(gcf,'color','w');
%     grid on
%     hold off
% 
%     drawnow
%     frame = getframe(1);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256);
% 
%     if i == 1;
%       imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1);
%     else
%       imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
%     end
%     
%     pause(0.02)
% 
% end
%     
% for j=1:25
%     imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
% end

create2dgif(rfn, afn, zfn, dfn, sfn, efn, wfn, deltafn, tvec)