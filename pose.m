

for i = 1:length(data)

yaw = data(i,1);
pitch = data (i,2);
roll = data(i,3);
    
M1 = [1, 0, 0; 0, cosd(roll), -sind(roll); 0, sind(roll), cosd(roll)];
M2 = [cosd(pitch), 0, sind(pitch); 0, 1, 0; -sind(pitch), 0, cosd(pitch)];
M3 = [cosd(yaw), -sind(yaw), 0; sind(yaw), cosd(yaw), 0; 0, 0, 1];


tip = M1*M2*M3*[3;0;0];
left = M1*M2*M3*[0;-1;0];
right = M1*M2*M3*[0;1;0];
top = M1*M2*M3*[0;0;1];

plot3([tip(1),top(1),left(1),right(1),tip(1),left(1),top(1),right(1)],[tip(2),top(2),left(2),right(2),tip(2),left(2),top(2),right(2)],[tip(3), top(3),left(3),right(3),tip(3),left(3),top(3),right(3)]);
axis square
axis ([-3, 3, -3, 3, -3, 3])
% plot3([tip(1),left(1)],[tip(2),left(2)],[tip(3), left(3)]);
% plot3([tip(1),right(1)],[tip(2),right(2)],[tip(3), right(3)]);
% plot3([top(1),left(1)],[top(2),left(2)],[top(3), left(3)]);
% plot3([top(1),right(1)],[top(2),right(2)],[top(3), right(3)]);
% plot3([left(1),right(1)],[left(2),right(2)],[left(3), right(3)]);

pause(0.01)

end