% MEC2407 ELECTROMECHANICS - Computer Lab Part 3 Solution %
% Written by Darren McMorran %
clear; clc;
data = importdata('data.txt','\t');
res = 200; % The rotary encoder resolution in pulses / revolution
n = 1:length(data);
st = 360e-6; % Sample Period (determined by Arduino)
sf = 1/st; % Sample Frequency

A = data(:,1)' > 125; % Convert signal A to digital
B = data(:,2)' > 125; % Convert signal B to digital
C = data(:,3)'; % Absolute angular position

t = linspace(0,st*(length(data)-1),length(data)); % Time vector

dA = diff(A)==1; % Signal A Rising Pulses
t2 = t(2:end); % Time vector corresponding to dA vector
At = t2(dA); % Time vector of signal A rising pulses
dAt = diff(At); % Time difference between signal A rising pulses

% Determine Angular Position
dAB = dA.*(-2*(B(1:numel(dA))-1/2)); % Scale with direction
% If A leads B: at a rising pulse in A, signal B is 0 so dAB = +1
% If B leads A: at a rising pulse in A, signal B is 1 so dAB = -1
dpos = dAB./res; % Scale to correct angular position (revolutions) 
pos = cumsum(dpos); % Position = integral of change in position (dpos)

% Determine Angular Velocity
dpos = dpos(dA); % Take non-zero values
speed = 60*dpos(2:end)./dAt; % Calculate angular velocity (rpm)

% Filter 1 (simple)
f1 = 10; % Filter 1 length
speedf1 = filter(1/f1*ones(f1,1),1,speed); % Apply mean filter

% Filter 2 removes stationary errors that result from the mean filter
% Extend speed vector to size of input data at correct time scale
j = 1;
speedj = 0;
speed2 = zeros(size(t)); % Initialise vector to improve efficiency
for i = 1:numel(t)
    if (At(j) == t(i)) % If there is a new speed calculated at this time
        speedj = speed(j); % Store most recently calculated speed
        if (j+1 <= numel(speed) )
            j = j+1;
        end
    end
    speed2(i) = speedj; % Extend speed vector
end

f2 = 200; % Filter 2 length
speedf2 = filter(1/f2*ones(f2,1),1,speed2); % Apply mean filter 2

% Display two plots simultaneously showing angular position and velocity
subplot(2,1,1);
plot(t2,pos,'r',t,C,'b');
title('Rotary Encoder Angular Position','fontweight','bold');
xlabel('Time (s)','fontweight','bold');
ylabel('Angular Position (revolutions)','fontweight','bold');
legend('Estimated Position','Given Position');
subplot(2,1,2);
plot(At(2:end),speed,'b',At(2:end),speedf1,'g',t,speedf2,'r');
title('Rotary Encoder Angular Velocity','fontweight','bold');
xlabel('Time (s)','fontweight','bold');
ylabel('Angular Velocity (RPM)','fontweight','bold');
legend('Estimated Velocity','Filtered Velocity 1','Filtered Velocity 2');