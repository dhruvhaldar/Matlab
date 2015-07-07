clearvars -except data
ratio = data(:,1)';
margin = data(:,2)';
coeffs = polyfit([1 10], [0 max(margin)], 1);
a = coeffs(1);
c = coeffs(2);
b = -1;

a = (ratio(:)-1)\margin(:)
c = -a;

x = linspace(0, ceil(1.1*max(ratio)), 200);
y = a*x+c;

%plot(ratio,margin,'bo',x,y,'r',1,0,'k*')

distance = abs(a*ratio+b*margin+c)/sqrt(a.^2+b.^2);

ratiox = ratio(distance >= 2.5*std(distance));
marginx = margin(distance >= 2.5*std(distance));
ratio = ratio(distance < 2.5*std(distance));
margin = margin(distance < 2.5*std(distance));

coeffs = polyfit(ratio, margin, 1)

odd(1) = input('Enter odd1: ');
odd(2) = input('Enter odd2: ');
fprintf('Estimated margin: %d\n',round(coeffs(1)*(max(odd)/min(odd))+coeffs(2)));

a = (ratio(:)-1)\margin(:);

fittedX = linspace(0, ceil(1.1*max(ratio)), 200);
fittedY = a*fittedX-a;%polyval(coeffs, fittedX);


plot(ratio,margin,'go',ratiox,marginx,'ro',x,y,'k-',fittedX,fittedY,'b-')
grid ON