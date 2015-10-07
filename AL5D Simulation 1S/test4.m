clearvars -except rfn afn zfn dfn sfn efn wfn tvec
clc;

stdy = 3.33;
stdp = 3.33;


lim = 3; %stds
stepsize = 500;
pitch2 = sfn(tvec,0);
yaw2 = afn(tvec);
pitch1 = pitch2(1);
yaw1 = yaw2(1);
% yaw2 = linspace(yaw1-lim*stdy,yaw1+lim*stdy,stepsize);
% pitch2 = linspace(pitch1-lim*stdp,pitch1+lim*stdp,stepsize);
%pitch2 = pitch2;

% c = acosd(cosd(yaw1).*cosd(yaw2).*cosd(pitch1-pitch2)+sind(yaw1).*sind(yaw2).*ones(size(pitch2)));
c = acosd(cosd(pitch1).*cosd(pitch2).*cosd(yaw1-yaw2)+sind(pitch1).*sind(pitch2));
% c = acosd(cosd(pitch1)*cosd(pitch2)*cosd(yaw1-yaw2)+sind(pitch1)*sind(pitch2)*ones(size(yaw2)));
% c = c./max(max(c));

delta = @(t) acosd(cosd(sfn(t,0) - sfn(tvec(1),0)).*cosd(afn(tvec(1))).*cosd(afn(t))+sind(afn(tvec(1))).*sind(afn(t)));
delta2 = @(t) acosd(cosd(afn(t) - afn(tvec(1))).*cosd(sfn(tvec(1),0)).*cosd(sfn(t,0))+sind(sfn(tvec(1),0)).*sind(sfn(t,0)));
c = delta(tvec);
c2 = delta2(tvec);

plot3(pitch2-pitch1,yaw2-yaw1,c,pitch2-pitch1,yaw2-yaw1,c2)
xlabel('Pitch Disparity (Degrees)')
ylabel('Yaw Disparity (Degrees)')
zlabel('Total Disparity (Degrees)')
