X = rand(1000,1)-0.5;
I = (abs(X).^4)./(abs(1-X).^4);
[Idata Ibin] = hist(I,1000);
hold on
bar(Ibin,Idata)

Icoef = polyfit(Ibin,Idata,8);
line(Ibin,polyval(Icoef,Ibin));