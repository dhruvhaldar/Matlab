clear; clc;

global HAND;
global threshold;
threshold = 5;
delta = 2;
dr = 0.5;
dh = -1;
hi = 315.05;
ri = -12.675;

hvec = hi:dh:HAND;
rvec = ri:dr:(ri+(length(hvec)-1)*dr);
% for i = 1:length(rvec)
%     [a, b, thetavec(i)] = findLimit(ri,hi,dr,dh,rvec(i),0);
% end
[sfun, efun] = anglefns(ri, hi, dr, dh);

for i = 1:length(rvec)
    thetavec(i) = sfun(rvec(i),0);
    evec(i) = efun(rvec(i),0);
end
nmax = numel(rvec);
offset = 0;
for n=1:nmax
index = n+offset;
rf(n) = rvec(index);
tf(n) = thetavec(index);
ef(n) = evec(index);
[r(n),s(n),sp(n),sm(n),e(n),ep(n),em(n)] = findLimitS(sfun, efun, ri, dr, rf(n), delta);
[r2(n),s2(n),s2p(n),s2m(n),e2(n),ep2(n),em2(n)] = findLimitS(sfun, efun, ri, dr, rf(n), -delta);
if (abs(r2(n)-rf(n)) < abs(r(n)-rf(n)))
    s(n) = s2(n);
    e(n) = e2(n);
end
pause(0.04);
h = plot(rvec,thetavec,'b',rvec,evec,'k',rf(n),tf(n),'b*',rf(n),ef(n),'k*',[rvec(1) rvec(end)],[sp(n) sp(n)],'r:',[rvec(1) rvec(end)],[sm(n) sm(n)],'m:',[rvec(1) rvec(end)],[ep(n) ep(n)],'r:',[rvec(1) rvec(end)],[em(n) em(n)],'m:',r(n),s(n),'g*',r(n),e(n),'g*');
% plot(r2,e2,'r*',r2,ep2,'g*',r2,em2,'b*');
title('Postion Estimation Using Accelerometer Error','fontweight','bold')
xlabel('Radial Distance (mm)','FontWeight','bold');
ylabel('Servo Angle (Degrees)','fontweight','bold');
legend(h([3 4 5 6 end]),'Anticipated Shoulder Position','Anticipated Elbow Position','Upper Threshold Limit','Lower Threshold Limit','Estimated Position');
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
end