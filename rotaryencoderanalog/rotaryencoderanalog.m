clear;
clc;
data = importdata('data.txt','\t');
res = 200;
fn = 10;
fl = 200;
n = 1:length(data);
st = 360e-6; % Sample Period
sf = 1/st; % Sample Frequency

A = data(:,1)' > 125;
B = data(:,2)' > 125;
Z = data(:,3)' > 125;
% time = data(:,4)'/1e6;
t = linspace(0,st*length(data),length(data));
% 
dA = diff(A)==1;
At = t(dA);
dAt = diff(At);
% As = 60./(res*At);
dAB = dA.*(2*(B(1:numel(dA))-1/2));
dAB2 = dAB(dAB~=0);
t2 = t(dAB~=0);
dABsum = cumsum(dAB2);
pos = dABsum./res;
pos2 = cumsum(dAB)./res;
dpos = diff(pos);
dt2 = diff(t2);
speed = 60*dpos./dt2;
speedf = filter(1/fn*ones(fn,1),1,speed);

j = 1;
speedj = 0;
speed2 = zeros(size(t));
for i = 1:numel(t)
    if (t2(j) == t(i))
        speedj = speed(j);
        if (j+1 <= numel(speed) )
            j = j+1;
        end
    end
    speed2(i) = speedj;
end

fn = 200; 
speedf2 = filter(1/fn*ones(fn,1),1,speed2);

% dpost = pos(dpos~=0);
% test = 6000./(res*diff(dABsum));
%dABt = Bt(1:numel(dAt)).*dAt;
% dAt2 = 60./(res*dAt);
% speed = 0;
% j=0;
% s = zeros(size(dAB));
% for i=1:numel(dAB)
%     if ( dA(i) == 1 )
%         if( j > 0 )
%             speed = dAt2(j);
%         end
%         j=j+1;
%     elseif ( dAB(i) == -1 )
%         speed = -dAt2(j);
%         j=j+1;
%     end
%     s(i) = speed;
% end
% 
% for i=(fl+1):numel(dAB)
%     s(i)=(dABsum(i)-dABsum(i-fl))/(t(i)-t(i-fl));
% end

        
% fdAt = filter(1/fn*ones(fn,1),1,dAt2);
% % 
% dZ = diff(Z)==1;
% Zt = time(diff(Z)==1);
% dZt = 60./diff(Zt);
% 
% nt = n(diff(Z)==1);
% nt2 = n(diff(Z)==-1);
% nt2-nt;
% 
% for i=1:numel(nt)-1
% sum(dA(nt(i):nt(i+1)))
% end
%
plot(t(2:end),10*pos2,'k',t2(2:end),speed,'b',t2(2:end),speedf,'g',t,speedf2,'r');
%plot(linspace(0,st*length(data),numel(pos)),pos);%,linspace(0,st*length(data),numel(s)),s);
%plot(linspace(0,st*length(data),numel(dAt2)),dAt2,linspace(0,st*length(data),numel(fdAt)),fdAt,'r');%,Bt(1:numel(fdBt)),fdBt,Zt(1:numel(dZt)),dZt);
xlabel('Time (s)');
ylabel('Angular Velocity (RPM)');
legend('Angular Position','Raw','Mean Filtered (n=10)','Mean Filtered (n=100)');
%plot(Z)
