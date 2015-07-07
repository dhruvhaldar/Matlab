clear;
clc;
data = importdata('data.txt',' ');
res = 200;
fn = 200;
n = 1:length(data);

A = data(:,1)';
B = data(:,2)';
Z = data(:,3)';
time = data(:,4)'/1e6;

dA = diff(A)==1;
At = time(diff(A)==1);
dAt = 60./(res*diff(At));
fdAt = filter(1/fn*ones(fn,1),1,dAt);

Bt = time(diff(B)==1);
dBt = 60./(res*diff(Bt));
fdBt = filter(1/fn*ones(fn,1),1,dBt);

Zt = time(diff(Z)==1);
dZt = 60./diff(Zt);

nt = n(diff(Z)==1);
nt2 = n(diff(Z)==-1);
nt2-nt;

for i=1:length(nt)-1
sum(dA(nt(i):nt(i+1)))
end

plot(At(1:length(fdAt)),fdAt,Bt(1:length(fdBt)),fdBt,Zt(1:length(dZt)),dZt);
xlabel('Time (s)');
ylabel('Speed (rpm)');

