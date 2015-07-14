global BASE_HEIGHT HUMERUS ULNA HAND;
BASE_HEIGHT = 169.0;   % base height (all mm)
HUMERUS = 146.05;      % shoulder to elbow
ULNA = 187.325;        % elbow to wrist 
HAND = 90.0;           % wrist to gripper tip

delta = 10;

delta2 = 10;

basAngle_d = 90;
shlAngle_d = 90;
elbAngle_d = 90;
wriAngle_d = 90;

[elb_r, elb_h, wri_r, wri_h, tip_r, tip_h, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);

tip_h_max = tip_h;

wri_R = wri_r;
wri_H = wri_h;

for i=1:tip_h_max

r1 = wri_r; h1 = wri_h;
    
[shlAngle_d, elbAngle_d, wriAngle_d] = inverseKinematics(tip_r+0.5, tip_h-1, handAngle_d);

[elb_r, elb_h, wri_r, wri_h, tip_r, tip_h, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);

r2 = wri_r; h2 = wri_h;

dh = h2-h1; dr = r2-r1;

m = dh/dr; c = h1-m*r1;
theta = atan2d(dr,-dh);

a2 = HUMERUS*cosd(shlAngle_d+delta);

b2 = HUMERUS*sind(shlAngle_d+delta) + BASE_HEIGHT;

d = abs((r2-r1)*(h1-b2)-(r1-a2)*(h2-h1))/sqrt((r2-r1)^2+(h2-h1)^2)

e = shlAngle_d + delta2 + elbAngle_d - 180;

if (e < ULNA)
    e2 = theta - acosd(d/ULNA);
    if (e2 < e)
        e = e2;
    end
end

a3 = a2 + ULNA*cosd(e);
b3 = b2 + ULNA*sind(e);

% syms x y a b m c u
%    
% S = solve([(x-a)^2+(y-b)^2==u^2, y == m*x+c],x,y)
%    
% x2 = double(real(subs(S.x,{a,b,c,m,u},[a2,b2,C,M,ULNA])))
% 
% y2 = double(real(subs(S.y,{a,b,c,m,u},[a2,b2,C,M,ULNA])))

plot3([0, 0, elb_r*sind(basAngle_d), wri_r*sind(basAngle_d), tip_r*sind(basAngle_d)],[0, 0, elb_r*cosd(basAngle_d), wri_r*cosd(basAngle_d), tip_r*cosd(basAngle_d)],[0, BASE_HEIGHT, elb_h, wri_h, tip_h], 'r', [0 a2 a3 a3],[0 0 0 0],[BASE_HEIGHT b2 b3,b3-HAND],'b',[0,500],[0,0],[m*(0)+c,m*(500)+c],'k--','LineWidth',2);
%plot3(x2(1),0,y2(1));

axis([-1.1*(HUMERUS+ULNA+HAND), 1.1*(HUMERUS+ULNA+HAND), -1.1*(HUMERUS+ULNA+HAND), 1.1*(HUMERUS+ULNA+HAND), 0, 1.1*(BASE_HEIGHT+HUMERUS)])

grid on

view(37.5,30)

pause(0.01);

end



