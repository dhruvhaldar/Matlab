clear; clc;


global HAND;
global threshold;
threshold = 10;
delta = 8;
dr = 0.5;
dh = -1;
hi = 315.05;
ri = -12.675;
% dr = -0.5;
% dh = 1;
% hi = 90.05;
% ri = 99.825;

opengl software

hvec = hi:dh:HAND;%315.05
rvec = ri:dr:(ri+(length(hvec)-1)*dr);
% for i = 1:length(rvec)
%     [a, b, thetavec(i)] = findLimit(ri,hi,dr,dh,rvec(i),0);
% end
[sfun, efun] = anglefns(ri, hi, dr, dh);


for i = 1:length(rvec)
    svec(i) = sfun(rvec(i),0);
    evec(i) = efun(rvec(i),0);
    wvec(i) = 360-svec(i)-evec(i)+90;
end

[ax,p1,p2] = plotyy(rvec,hvec,[rvec', rvec',rvec'],[svec',evec', wvec']);
set(p1,{'color'},{[0 .6 .1]})
set(p2,{'color'},{[0 .65 1];'b';'c'})
set(ax,{'ycolor'},{[0 .6 .1];['b']},'XColor'      , [.3 .3 .3]);
%   'YColor'      , [.3 .3 .3], ...)
% plot(r2,e2,'r*',r2,ep2,'g*',r2,em2,'b*');
% h = plot3(rvec,thvec,zeros(size(thvec)))


title('Robot Arm Travel Path','fontweight','bold','fontsize',20)
xlabel('Radial Distance (mm)','FontWeight','bold','fontsize',14);
ylabel(ax(2),'Servo Angle (Degrees)','fontweight','bold','fontsize',14);
ylabel(ax(1),'Height (mm)','fontweight','bold','fontsize',14);
l = legend(ax(2),'Shoulder Angle', 'Elbow Angle', 'Wrist Angle');
ylim(ax(2),[0 450])
set(l,'color','w');
% set(gca, ...
%   'Box'         , 'off'     , ...
%   'TickDir'     , 'out'     , ...
%   'TickLength'  , [.02 .02] , ...
%   'XMinorTick'  , 'on'      , ...
%   'YMinorTick'  , 'on'      , ...
%   'XColor'      , [.3 .3 .3], ...
%   'YColor'      , [.3 .3 .3], ...
%   'YTick'       , 0:50:350, ...
%   'LineWidth'   , 1         );
% set(gcf,'color','w');

%       drawnow
%       frame = getframe(1);
%       im = frame2im(frame);
%       [imind,cm] = rgb2ind(im,256);
%       if n == 1;
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1);
%       else
%           imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
%       end