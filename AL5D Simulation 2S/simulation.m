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
wriAngle_d = 90;

[elb_r, elb_h, wri_r, wri_h, tip_r, tip_h, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);

[shlAngle_d, elbAngle_d, wriAngle_d] = inverseKinematics(tip_r-100, tip_h, handAngle_d);

[elb_r, elb_h, wri_r, wri_h, tip_r, tip_h, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);

ri = wri_r;
hi = wri_h;
theta0 = basAngle_d;

% dr = -0.5;   
% dh = 1;
% dtheta = -0.5;
% hvec = tip_h:dh:225.05;
dr = 0.5;   
dh = -1;
dtheta = 0.5;
hvec = tip_h:dh:0;
hlen = length(hvec)-1;
rvec = ri:dr:(ri+hlen*dr);
thvec = theta0:dtheta:(theta0+hlen*dtheta);

[sfun, efun] = anglefns(ri, hi, dr, dh);

% filename = '3dfig04.gif';
% 
% hFig = figure(1);
% set(hFig,'units','normalized','outerposition',[0 0 1 1]);
% 
% 
% for i=2:length(hvec)   
% [shlAngle_d, elbAngle_d, wriAngle_d] = inverseKinematics(rvec(i), hvec(i), handAngle_d);
% 
% [elb_r0, elb_z0, wri_r0, wri_z0, tip_r0, tip_z0, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);
% 
% basAngle_d = thvec(i);
% 
% elb_x0 = elb_r0*sind(basAngle_d); elb_y0 = elb_r0*cosd(basAngle_d);
% wri_x0 = wri_r0*sind(basAngle_d); wri_y0 = wri_r0*cosd(basAngle_d);
% tip_x0 = tip_r0*sind(basAngle_d); tip_y0 = tip_r0*cosd(basAngle_d);
% 
% delta = linspace(-deltamax,deltamax,15);
% 
% phi = threshold + delta;
% 
% 
% % for k=1:length(phi)
% %     [shl, elb] = findLimit(sfun, efun, phi(k), ri, dr, tip_r0);
% %     wri = 360-shl-elb+handAngle_d;
% %     [elb_r, elb_z(k), wri_r, wri_z(k), tip_r, tip_z(k), handAngle_d] = forwardsKinematics(shl, elb, wri);
% %     theta = dtheta*((tip_r-ri)/dr)+theta0;
% %     elb_x(k) = elb_r*sind(theta); elb_y(k) = elb_r*cosd(theta);
% %     wri_x(k) = wri_r*sind(theta); wri_y(k) = wri_r*cosd(theta);
% %     tip_x(k) = tip_r*sind(theta); tip_y(k) = tip_r*cosd(theta);
% % end
% 
% [shl, elb] = findLimit(sfun, efun, ri, dr, tip_r0);
% 
% % for(z = 2:length(shl))
% %     if(shl(z) == shl(z-1))
% %         
% %         shl(z) = shl(z-1) + 0.2;
% %         elb(z) = elb(z-1) + 0.2;
% %     end
% % end
% summ = sum(diff(shl)==0);
% 
% for k=1:length(shl)
%     wri = 360-shl(k)-elb(k)+handAngle_d;
%     [elb_r, elb_z(k), wri_r, wri_z(k), tip_r, tip_z(k), hand] = forwardsKinematics(shl(k), elb(k), wri);
%     theta = dtheta*((tip_r-ri)/dr)+theta0;
%     elb_x(k) = elb_r*sind(theta); elb_y(k) = elb_r*cosd(theta);
%     wri_x(k) = wri_r*sind(theta); wri_y(k) = wri_r*cosd(theta);
%     tip_x(k) = tip_r*sind(theta); tip_y(k) = tip_r*cosd(theta);
% end
% 
% 
% % count = sum(diff(elb_x)==0);
% % m = count+1;
% % if(count~=0)
% %     for n=1:m
% %         elb_x(n) = (n-1)*(elb_x(m)-elb_x0)/count + elb_x0; elb_y(n) = (n-1)*(elb_y(m)-elb_y0)/count + elb_y0; elb_z(n) = (n-1)*(elb_z(m)-elb_z0)/count + elb_z0;
% %         wri_x(n) = (n-1)*(wri_x(m)-wri_x0)/count + wri_x0; wri_y(n) = (n-1)*(wri_y(m)-wri_y0)/count + wri_y0; wri_z(n) = (n-1)*(wri_z(m)-wri_z0)/count + wri_z0;
% %         tip_x(n) = (n-1)*(tip_x(m)-tip_x0)/count + tip_x0; tip_y(n) = (n-1)*(tip_y(m)-tip_y0)/count + tip_y0; tip_z(n) = (n-1)*(tip_z(m)-tip_z0)/count + tip_z0;
% %     end
% % end
% 
% 
% t = linspace(0,1,50);
% s = linspace(0,1,length(elb_x))';
% c = normpdf(s,0.5,0.2);
% c = c - min(c);
% d = 1;
% c = d*c./abs(max(c))+1-d;
% 
% 
% C = (c*ones(size(t)))';
% % 
% % % wr = wrir(1) + s*(wrir(3)-wrir(1));
% % % wz = wriz(1) + s*(wriz(3)-wriz(1));
% x1 = t'*elb_x;
% y1 = t'*elb_y;
% z1 = t'*(elb_z-BASE_HEIGHT)+BASE_HEIGHT;
% 
% x2 = t'*(wri_x-elb_x)+ones(size(t'))*elb_x;
% y2 = t'*(wri_y-elb_y)+ones(size(t'))*elb_y;
% z2 = t'*(wri_z-elb_z)+ones(size(t'))*elb_z;
% 
% x3 = t'*(tip_x-wri_x)+ones(size(t'))*wri_x;
% y3 = t'*(tip_y-wri_y)+ones(size(t'))*wri_y;
% z3 = t'*(tip_z-wri_z)+ones(size(t'))*wri_z;
% 
% index1 = 1;%ceil(length(elb_x)/2);
% index2 = numel(elb_x);
% armx1 = [0 elb_x(index1) wri_x(index1) tip_x(index1)];
% army1 = [0 elb_y(index1) wri_y(index1) tip_y(index1)];
% armz1 = [BASE_HEIGHT elb_z(index1) wri_z(index1), tip_z(index1)];
% armx2 = [0 elb_x(index2) wri_x(index2) tip_x(index2)];
% army2 = [0 elb_y(index2) wri_y(index2) tip_y(index2)];
% armz2 = [BASE_HEIGHT elb_z(index2) wri_z(index2), tip_z(index2)];
% dist = max(sqrt((armx1-armx2).^2+(army1-army2).^2+(armz1-armz2).^2));
% D = 5/dist;
% 
% %h = plot3(rvec.*sind(thvec),rvec.*cosd(thvec),hvec+HAND,'k--');
% hold on
% h(2) = plot3([0, 0, elb_x0, wri_x0, tip_x0],[0, 0, elb_y0, wri_y0, tip_y0],[0, BASE_HEIGHT, elb_z0, wri_z0, tip_z0],'r','MarkerSize',1,'LineWidth',2);
% h(3) = surf([armx2;armx2+D*(armx1-armx2)],[army2;army2+D*(army1-army2)],[armz2;armz2+D*(armz1-armz2)]);
% alpha(h(3),0);
% % surf(x1, y1, z1);
% % surf(x2, y2, z2);
% % surf(x3, y3, z3);
% % surf(x2, y2, z2, 'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
% % surf(x3, y3, z3,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
% h(4)=surf(x1,y1,z1,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
% h(5)=surf(x2,y2,z2,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
% h(6)=surf(x3,y3,z3,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
% hold off
% shading interp;
% colormap([0.3 0.3 1]);
% axis equal
% 
% 
% title('Robot Arm Collision Simulation','fontweight','bold','fontsize',20)
% xlabel('X (mm)','FontWeight','bold','fontsize',14);
% ylabel('Y (mm)','FontWeight','bold','fontsize',14);
% zlabel('Z (mm)','FontWeight','bold','fontsize',14);
% %legend(h([1 2 3]),'Path of Motion','Anticipated Position','Possible Position After Collision','Location',[0.75 0.85 0.2 .1]);
% 
% set(gca, ...
%   'Box'         , 'off'     , ...
%   'TickDir'     , 'out'     , ...
%   'TickLength'  , [.02 .02] , ...
%   'XMinorTick'  , 'on'      , ...
%   'YMinorTick'  , 'on'      , ...
%   'ZMinorTick'  , 'on'      , ...
%   'XColor'      , [.3 .3 .3], ...
%   'YColor'      , [.3 .3 .3], ...
%   'ZColor'      , [.3 .3 .3], ...
%   'LineWidth'   , 1         );
% set(gcf,'color','w');
% 
% % axis([-1.1*(HUMERUS+ULNA+HAND), 1.1*(HUMERUS+ULNA+HAND), -1.1*(HUMERUS+ULNA+HAND), 1.1*(HUMERUS+ULNA+HAND), 0, 1.1*(BASE_HEIGHT+HUMERUS)])
% axis([-2.5*max(rvec), 2.5*max(rvec), -2.5*max(rvec), 2.5*max(rvec), 0, max(hvec)+HAND])
% grid on
% 
% 
% 
% % view(0,0)
% %view(15,15)
% view(37.5,30)
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
create2dgif(rvec,hvec+HAND,thvec)