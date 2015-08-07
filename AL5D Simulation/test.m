clear; clc;

global HAND;
dr = 0.5;
dh = -1;
hi = 315.05;
ri = -12.675;
delta = 10;

hvec = hi:dh:HAND;
rvec = ri:dr:(ri+(length(hvec)-1)*dr);
for i = 1:length(rvec)
    [a, b, thetavec(i)] = findLimit(ri,hi,dr,dh,rvec(i),0);
end

for n=1:150
index = n;
rf(n) = rvec(index);
[er(n), et(n), tf(n)] = findLimit(ri,hi,dr,dh,rf(n),delta);


pause(0.04);
plot(rvec,thetavec,rf,tf,'g*',er(n),et(n),'r*');

end