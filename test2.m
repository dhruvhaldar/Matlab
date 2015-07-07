% Assignment 4 Problem 4 Part a by Darren McMorran 2339 0085 %
syms t x y s

f(t) = 1/((1-x*t)*(1-y*t)); % MT(t)

f1(t) = diff(f); % First derivative

f2(t) = diff(f1); % Second derivative

f2(0)