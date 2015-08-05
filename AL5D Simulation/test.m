clear; clc;
BASE_HEIGHT = 169.0;   % base height (all mm)
HUMERUS = 146.05;      % shoulder to elbow
ULNA = 187.325;        % elbow to wrist 
HAND = 90.0;           % wrist to gripper tip
dr = 0.5;
dh = -1;
hi = 315.05;
ri = -12.675;
syms x y r
h = (dh/dr)*(r-ri)+hi;
s2w_r = r;
s2w_h = h-BASE_HEIGHT;
s2w = ( s2w_h * s2w_h ) + ( s2w_r * s2w_r ); % (Length of line from shoulder to wrist (S-W))^2
a1 = atan( s2w_h, s2w_r ); % Angle between S-W line and ground
a2 = acos((( HUMERUS^2 - ULNA^2 ) + s2w ) / ( 2 * HUMERUS * sqrt( s2w ) )); % Angle between S-W line and humerus
t = radtodeg(a1+a2);
tr = diff(t,r);
% a1x = solve(a1==x,r)
% 
% a2x = solve(a2==x,r)
% 
% solve(a1x+a2x==y,x)



hvec = hi:dh:HAND;
rvec = ri:dr:(ri+(length(hvec)-1)*dr);
rf = rvec(end/2);
tf = double(subs(t,r,rf));
% myfun = @(r) t == tf-10;
delta = 20;
ct=tf+delta;
fun = @(r) (1007958012753983*acos((10*((2*r - 1207/10)^2 + r^2 - 3782334602438243/274877906944))/(2921*((2*r - 1207/10)^2 + r^2)^(1/2))))/17592186044416 + (1007958012753983*angle(r*(1 - 2*i) + (1207*i)/10))/17592186044416-ct;

cr=fzero(fun,rf)
% rs = vpasolve(t==tf+delta);
% ts = double(subs(t,r,rs));
% thetavec = double(subs(t,r,rvec));
% tr = double(subs(tr,r,rvec));
% 
% 
% plot(rvec,thetavec,rvec,10*tr,rf,tf,'r*',cr,ct,'m*');
% tr = subs(tr,[B,H,U],[BASE_HEIGHT, HUMERUS, ULNA]);
% th = subs(tr,[B,H,U],[BASE_HEIGHT, HUMERUS, ULNA]);
