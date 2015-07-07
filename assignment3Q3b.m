% Assignment 3 Problem 3 Part b by Darren McMorran 2339 0085 %
%% Section i
C = 1000; mu = 20; alpha = 0.01; var = [10, 100, 1000];
Q = qfuncinv(alpha);
n = (var*Q^2+2*mu*C-Q*sqrt((var.^2)*Q^2 + 4*mu*C*var))/(2*mu^2);
EB = C./n;
i = table(var',n',EB','VariableNames',{'Variance' 'MaxUsers' 'EffectiveBandwidth'});

%% Section ii
mu = 20; alpha = 0.01; var = 100; C = [100, 1000, 10000];
Q = qfuncinv(alpha);
n = (var*Q^2+2*mu*C-Q*sqrt((var.^2)*Q^2 + 4*mu*C*var))/(2*mu^2);
EB = C./n;
ii = table(C',n',EB','VariableNames',{'Capacity' 'MaxUsers' 'EffectiveBandwidth'});

%% Section iii
C = 1000; mu = 20; var = 100; alpha = [0.1,0.01,0.001]; 
Q = qfuncinv(alpha);
n = (var*Q.^2+2*mu*C-Q.*sqrt((var.^2)*Q.^2 + 4*mu*C*var))/(2*mu^2);
EB = C./n;
iii = table(alpha',n',EB','VariableNames',{'Alpha' 'MaxUsers' 'EffectiveBandwidth'});




%%