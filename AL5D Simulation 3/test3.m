clear;
clc;

stdy = 3.33;
stdp = 3.33;

yaw1 = 45;
lim = 3; %stds
stepsize = 500;
yaw2 = linspace(yaw1-lim*stdy,yaw1+lim*stdy,stepsize);
pitch1 = 45;
pitch2 = linspace(pitch1-lim*stdp,pitch1+lim*stdp,stepsize);
pitch2 = pitch2';
ux = cosd(pitch2)*cosd(yaw2);
uy = cosd(pitch2)*sind(yaw2);
uz = sind(pitch2)*ones(size(yaw2));
vx = cosd(pitch1)*cosd(yaw1);
vy = cosd(pitch1)*sind(yaw1);
vz = sind(pitch1);

c = normpdf(pitch2,pitch1,stdp)*normpdf(yaw2,yaw1,stdy);

% c = acosd(cosd(pitch1)*cosd(pitch2)*cosd(yaw1-yaw2)+sind(pitch1)*sind(pitch2)*ones(size(yaw2)));
c = c./max(max(c));


plot3([0 vx], [0 vy], [0 vz]);
hold on 
surf(ux,uy,uz,'FaceAlpha','flat','AlphaDataMapping','none','AlphaData',c)
shading interp;
colormap([0 0 1]);
axis([0 1 0 1 0 1])
% mesh(pitch2-pitch1,yaw2-yaw1,c)
% xlabel('Pitch Disparity (Degrees)')
% ylabel('Yaw Disparity (Degrees)')
% zlabel('Total Disparity (Degrees)')
