clear; clc;

global HAND;
global threshold;
threshold = 2;
delta = 7;
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
end
for n=1:150
index = n+50;
rf(n) = rvec(index);
tf(n) = thetavec(index);
[r(n),s(n),e(n),ep(n),em(n)] = findLimitS(sfun, efun, ri, dr, rf(n), delta);
[r2(n),s2(n),e2(n),ep2(n),em2(n)] = findLimitS(sfun, efun, ri, dr, rf(n), -delta);
pause(0.04);
plot(rvec,thetavec,rf,tf,'g*',r(n),s(n),'r*',r2(n),s2(n),'m*');
% plot(r2,e2,'r*',r2,ep2,'g*',r2,em2,'b*');
end