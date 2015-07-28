clear; clc;

global BASE_HEIGHT HUMERUS ULNA HAND;
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

wri0r = wri_r;
wri0h = wri_h;
theta0 = basAngle_d;

dr = 0.5;   
dh = -1;
dtheta = 0.005;
hvec = tip_h:dh:0;
rvec = tip_r:dr:(wri_r+(length(hvec)-1)*dr);
thvec = theta0:dtheta:(theta0+(length(hvec)-1)*dtheta);

for i=2:length(hvec)

R1 = wri_r; H1 = wri_h;
    
[shlAngle_d, elbAngle_d, wriAngle_d] = inverseKinematics(rvec(i), hvec(i), handAngle_d);

[elb_r, elb_h, wri_r, wri_h, tip_r, tip_h, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d);

basAngle_d = thvec(i);

R2 = wri_r; H2 = wri_h; wri1x = wri_r*sind(basAngle_d); wri1y = wri_r*cosd(basAngle_d); wri1z = wri_h;

elb1x = elb_r*sind(basAngle_d); elb1y = elb_r*cosd(basAngle_d); elb1z = elb_h;

tip1x = tip_r*sind(basAngle_d); tip1y = tip_r*cosd(basAngle_d); tip1z = tip_h;

dh = H2-H1; dr = R2-R1;

m = dh/dr; c = H1-m*R1;
omega = atan2d(dr,-dh);

delta = [-deltamax 0 deltamax];

elbr = HUMERUS*cosd(shlAngle_d+threshold-delta);

elbz = HUMERUS*sind(shlAngle_d+threshold-delta) + BASE_HEIGHT;

d = ((R2-R1)*(H1-elbz)-(R1-elbr)*(H2-H1))/sqrt(dr^2+dh^2); % minimum distance from elbow to wrist motion path

phi = shlAngle_d + threshold - delta + elbAngle_d - 180;

holdif = 0;

for j=1:length(phi)
    if (d(j) < ULNA)
        if (phi(j) > omega - acosd(d(j)/ULNA))
            phi(j) = omega - acosd(d(j)/ULNA);
        end
    else
        if (phi(j) > omega)
            phi(j) = omega;
            rvec2 = linspace(-300,300,1000);
            offset = ULNA*sqrt(dr^2+dh^2)/dr;
            hvec2 = (dh/dr).*(rvec2-R1)+H1-offset;
            const = (R1*dh/dr + BASE_HEIGHT - H1 + offset)/HUMERUS;
            A = dh/dr;
            B = 1;
            M = sqrt(A^2+B^2);
            MAX = (A^2+B^2)/M;
            if (abs(const) > abs(MAX))
                fprintf('%4.2f > %4.2f\n',const,MAX);
            else
%             thetaa = 2*atan2d(sqrt(X^2+Y^2-C^2)-X,C+Y)
            thetaa = acosd(const/M)+atan2d(B,A);
            elbr(j);
            elbr(j)=HUMERUS*cosd(thetaa);
            elbz(j);
            elbz(j)=HUMERUS*sind(thetaa)+BASE_HEIGHT;
            holdif = 1;
            end
        end
    end
end

wrir = elbr + ULNA*cosd(phi);
wriz = elbz + ULNA*sind(phi);
theta = theta0 + (wrir-wri0r)*dtheta/dr;

wrix = wrir.*sind(theta);
wriy = wrir.*cosd(theta);

elbx = elbr.*sind(theta);
elby = elbr.*cosd(theta);

% if(holdif)elbr
%     elbR
%     elbz
%     elbZ
% end

t = linspace(0,1,50);
s = linspace(0,1,100)';
c = normpdf(s,0.5,0.2);
c = c - min(c);
c = c./abs(max(c));

wr = wrir(1) + s*(wrir(3)-wrir(1));
wz = wriz(1) + s*(wriz(3)-wriz(1));

for n=1:length(s)
    s2w = wr(n)^2 + (wz(n)-BASE_HEIGHT)^2;
    theta1 = acosd((s2w+HUMERUS^2-ULNA^2)/(2*sqrt(s2w)*HUMERUS));
    theta2 = asind(HUMERUS*sind(theta1)/ULNA);
    theta1 = theta1 + atan2d(wz(n)-BASE_HEIGHT,wr(n));
    theta2 = theta2 + atan2d(wr(n),wz(n)-BASE_HEIGHT)-90;
    r1(n,:) = t*HUMERUS*cosd(theta1);
    z1(n,:) = BASE_HEIGHT + t*HUMERUS*sind(theta1);
    r2(n,:) = wr(n)-t*ULNA*cosd(theta2);
    z2(n,:) = wz(n)+t*ULNA*sind(theta2);   
    r3(n,:) = wr(n)*ones(size(t));
    z3(n,:) = wz(n)-t*HAND;
end

thetad = (theta(1) + s*(theta(3)-theta(1))*ones(size(t)));

x1 = r2.*sind(thetad);
y1 = r2.*cosd(thetad);

x2 = r1.*sind(thetad);
y2 = r1.*cosd(thetad);

x3 = r3.*sind(thetad);
y3 = r3.*cosd(thetad);

C = (c*ones(size(t)));

plot3([0, 0, elb1x, wri1x, tip1x],[0, 0, elb1y, wri1y, tip1y],[0, BASE_HEIGHT, elb1z, wri1z, tip1z], 'r', [0 elbx(2) wrix(2) wrix(2)],[0 elby(2) wriy(2) wriy(2)],[BASE_HEIGHT elbz(2) wriz(2), wriz(2)-HAND],'b',rvec.*sind(thvec),rvec.*cosd(thvec),hvec+HAND,'k.','MarkerSize',1,'LineWidth',2);
hold on
surf(x1,y1,z2,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
surf(x2,y2,z1,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
surf(x3,y3,z3,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',C);
hold off
shading interp;
colormap([0.3 0.3 1]);
axis equal

axis([-1.1*(HUMERUS+ULNA+HAND), 1.1*(HUMERUS+ULNA+HAND), -1.1*(HUMERUS+ULNA+HAND), 1.1*(HUMERUS+ULNA+HAND), 0, 1.1*(BASE_HEIGHT+HUMERUS)])

grid on

view(0,0)
% view(37.5,30)

pause(0.01);

end