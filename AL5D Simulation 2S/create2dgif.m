function create2dgif(rvec,hvec,thvec)

% filename = '2dfig04.gif';

% global HAND;
global deltamax;
% dr = 0.5;
% dh = -1;
% hi = 315.05;
% ri = -12.675;
% % dr = -0.5;
% % dh = 1;
% % hi = 90.05;
% % ri = 99.825;

opengl software
ri = rvec(1);
dr = rvec(2)-rvec(1);
hi = hvec(1);
dh = hvec(2)-hvec(1);
% for i = 1:length(rvec)
%     [a, b, thetavec(i)] = findLimit(ri,hi,dr,dh,rvec(i),0);
% end
[sfun, efun] = anglefns(ri, hi, dr, dh);

for i = 1:length(rvec)
    svec(i) = sfun(rvec(i),0);
    evec(i) = efun(rvec(i),0);
end
nmax = numel(rvec);
offset = 0;
for n=1:nmax
clear rvec2 thvec2
index = n+offset;
rf(n) = rvec(index);
sf(n) = svec(index);
ef(n) = evec(index);
[sp,sm,ep,em,ro,rlim,slim] = findLimitS(sfun, efun, ri, rvec(end), dr, rf(n));
rm = ro(1); rp = ro(2); rm2 = ro(3); rp2 = ro(4);
rvec2 = rvec(dr*(rvec - rlim) > 0 & dr*(rvec - rf(n)) < 0);
rvec2 = [rlim rvec2 rf(n)];
thvec2 = svec(dr*(rvec - rlim) > 0 & dr*(rvec - rf(n)) < 0);
thvec2 = [slim thvec2 sf(n)];
pause(0.02);
hFig = figure(1);
set(hFig, 'Position', [100 100 1000 700])
h = plot(rvec,thvec,'k',rvec,svec,'b',rvec,evec,'r',rf(n),sf(n),'b*',rf(n),ef(n),'r*',[rvec(n) rvec(n)],[0 200],'c:',[rvec(1) rvec(end)],[sp sp],'b:',[rvec(1) rvec(end)],[sm sm],'b:',[rvec(1) rvec(end)],[ep ep],'r:',[rvec(1) rvec(end)],[em em],'r:',[rp rp],[0 200],'m:',[rp2 rp2],[0 200],'m:',[rm rm],[0 200],'m:',[rm2 rm2],[0 200],'m:',rvec2,thvec2,'g');
% plot(r2,e2,'r*',r2,ep2,'g*',r2,em2,'b*');
% h = plot3(rvec,thvec,zeros(size(thvec)))

hold on
h(17) = fill([rvec(1) rvec(end) rvec(end) rvec(1)],[ep ep em em],'r','EdgeColor','none','facealpha',0.2);
h(18)=fill([rvec(1) rvec(end) rvec(end) rvec(1)],[sp sp sm sm],'b','EdgeColor','none','facealpha',0.2);
h(19)=fill([rm rm rp rp],[0 200 200 0],'m','EdgeColor','none','facealpha',0.2);
fill([rm2 rm2 rp2 rp2],[0 200 200 0],'m','EdgeColor','none','facealpha',0.2)
h(20)=fill([rvec(1) rvec(1) rvec(n) rvec(n)],[0 200 200 0],'c','EdgeColor','none','facealpha',0.2);
xlim([min(rvec)-0.001 max(rvec)+0.001])
ylim([0 200])
hold off

title('Position Estimation Using Accelerometer Error','fontweight','bold','fontsize',20)
xlabel('Radial Distance (mm)','FontWeight','bold','fontsize',14);
ylabel('Servo Angle (Degrees)','fontweight','bold','fontsize',14);
legend(h([3 4 17 18 19 20 16]),'Anticipated Shoulder Position','Anticipated Elbow Position','Elbow Threshold Region','Shoulder Threshold Region','Radius Threshold Region','Travelled Region','Real Shoulder Position');
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'YTick'       , 0:50:350, ...
  'LineWidth'   , 1         );
set(gcf,'color','w');

%       drawnow
%       frame = getframe(1);
%       im = frame2im(frame);
%       [imind,cm] = rgb2ind(im,256);
%       if n == 1;
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1);
%       else
%           imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
%       end
end