clear; clc;

global BASE_HEIGHT HUMERUS ULNA HAND threshold deltamax;
BASE_HEIGHT = 169.0;   % base height (all mm)
HUMERUS = 146.05;      % shoulder to elbow
ULNA = 187.325;        % elbow to wrist 
HAND = 90.0;           % wrist to gripper tip

threshold = 10;
deltamax = 7.5; % Inaccuracy

basAngle_d = 90;
shlAngle_d = 90;
elbAngle_d = 90;
wriAngle_d = 90;

[elb_r, elb_h, wri_r, wri_h, tip_r, tip_h, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);

[shlAngle_d, elbAngle_d, wriAngle_d] = inverseKinematics(tip_r-200, tip_h, handAngle_d);

[elb_r, elb_h, wri_r, wri_h, tip_r, tip_h, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);

ri = wri_r;
hi = wri_h;
theta0 = basAngle_d;

dr = 0.5;   
dh = -1;
dtheta = 0.5;
hvec = tip_h:dh:0;
rvec = tip_r:dr:(wri_r+(length(hvec)-1)*dr);
thvec = theta0:dtheta:(theta0+(length(hvec)-1)*dtheta);

[sfun, efun] = anglefns(ri, hi, dr, dh);

for i=2:length(hvec)   
[shlAngle_d, elbAngle_d, wriAngle_d] = inverseKinematics(rvec(i), hvec(i), handAngle_d);

[elb_r0, elb_z0, wri_r0, wri_z0, tip_r0, tip_z0, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);

basAngle_d = thvec(i);

elb_x0 = elb_r0*sind(basAngle_d); elb_y0 = elb_r0*cosd(basAngle_d);
wri_x0 = wri_r0*sind(basAngle_d); wri_y0 = wri_r0*cosd(basAngle_d);
tip_x0 = tip_r0*sind(basAngle_d); tip_y0 = tip_r0*cosd(basAngle_d);

delta = [-deltamax 0 deltamax];

phi = threshold + delta;


for k=1:length(phi)
    [shl, elb] = findLimit(sfun, efun, phi(k), ri, dr, tip_r0);
    wri = 360-shl-elb+handAngle_d;
    [elb_r, elb_z(k), wri_r, wri_z(k), tip_r, tip_z(k), handAngle_d] = forwardsKinematics(shl, elb, wri);
    theta = dtheta*((tip_r-ri)/dr)+theta0;
    elb_x(k) = elb_r*sind(theta); elb_y(k) = elb_r*cosd(theta);
    wri_x(k) = wri_r*sind(theta); wri_y(k) = wri_r*cosd(theta);
    tip_x(k) = tip_r*sind(theta); tip_y(k) = tip_r*cosd(theta);
end

t = linspace(0,1,length(elb_x));
s = linspace(0,1,length(delta))';
c = normpdf(s,0.5,0.2);
c = c - min(c);
c = c./abs(max(c));

C = (c*ones(size(t)));

% wr = wrir(1) + s*(wrir(3)-wrir(1));
% wz = wriz(1) + s*(wriz(3)-wriz(1));
x1 = t'*elb_x;
y1 = t'*elb_y;
z1 = t'*(elb_z-BASE_HEIGHT)+BASE_HEIGHT;

x2 = t'*(wri_x-elb_x)+ones(size(t'))*elb_x;
y2 = t'*(wri_y-elb_y)+ones(size(t'))*elb_y;
z2 = t'*(wri_z-elb_z)+ones(size(t'))*elb_z;

x3 = t'*(tip_x-wri_x)+ones(size(t'))*wri_x;
y3 = t'*(tip_y-wri_y)+ones(size(t'))*wri_y;
z3 = t'*(tip_z-wri_z)+ones(size(t'))*wri_z;

index = ceil(length(elb_x)/2);
plot3([0, 0, elb_x0, wri_x0, tip_x0],[0, 0, elb_y0, wri_y0, tip_y0],[0, BASE_HEIGHT, elb_z0, wri_z0, tip_z0], 'r', [0 elb_x(index) wri_x(index) tip_x(index)],[0 elb_y(index) wri_y(index) tip_y(index)],[BASE_HEIGHT elb_z(index) wri_z(index), tip_z(index)],'b',rvec.*sind(thvec),rvec.*cosd(thvec),hvec+HAND,'k.','MarkerSize',1,'LineWidth',2);
% hold on
hold on
% surf(x1, y1, z1);
% surf(x2, y2, z2);
% surf(x3, y3, z3);
% surf(x1,y1,z2,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
% surf(x2,y2,z1,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
% surf(x3,y3,z3,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
hold off
% shading interp;
% colormap([0.3 0.3 1]);
% axis equal

axis([-1.1*(HUMERUS+ULNA+HAND), 1.1*(HUMERUS+ULNA+HAND), -1.1*(HUMERUS+ULNA+HAND), 1.1*(HUMERUS+ULNA+HAND), 0, 1.1*(BASE_HEIGHT+HUMERUS)])

grid on

% view(0,0)
view(37.5,30)

pause(0.01);

end