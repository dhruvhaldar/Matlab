sum1=0;
sum2=0;
sum3=0;
for n=0:1000
    sum1 = sum1 + 1/(factorial(n)*2^n);
    sum2 = sum2 + 1/factorial(n);
    sum3 = sum3 + 1/(2^n);
end
sum1
sum2+sum3