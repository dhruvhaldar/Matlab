% syms Lb Lu Lf Lh
% Ob = 0; Os = 0; Oe = 0; Ow = 0;
% T1 = [cosd(Ob) -sind(Ob) 0 0; sind(Ob) cosd(Ob) 0 0; 0 0 1 Lb; 0 0 0 1];
% T2 = [1 0 0 0; 0 0 -1 0; 0 1 0 0; 0 0 0 1];
% T3 = [cosd(Os) -sind(Os) 0 0; sind(Os) cosd(Os) 0 0; 0 0 1 0; 0 0 0 1];
% T4 = [1 0 0 Lu; 0 1 0 0; 0 0 1 0; 0 0 0 1];
% T5 = [cosd(Oe) sind(Oe) 0 0; -sind(Oe) cosd(Oe) 0 0; 0 0 1 0; 0 0 0 1];
% T6 = [1 0 0 Lf; 0 1 0 0; 0 0 1 0; 0 0 0 1];
% T7 = [cosd(Ow) sind(Ow) 0 0; -sind(Ow) cosd(Ow) 0 0; 0 0 1 0; 0 0 0 1];
% T8 = [1 0 0 Lh; 0 1 0 0; 0 0 1 0; 0 0 0 1];
% T = T1*T2*T3*T4*T5*T6*T7*T8;
% T*[0;0;0;1]

syms Lb Lu Lf Lh Ob Os Oe
assume(Ob >= 0)
assumeAlso(Ob <= pi/2)
assume(Os >= 0)
assumeAlso(Os <= pi/2)
assume(Oe >= 0)
assumeAlso(Oe <= pi/2)
Lb = 1; Lu = 1; Lf = 1; Lh = 1; Ow = 0;
T1 = [cos(Ob) -sin(Ob) 0 0; sin(Ob) cos(Ob) 0 0; 0 0 1 Lb; 0 0 0 1];
T2 = [1 0 0 0; 0 0 -1 0; 0 1 0 0; 0 0 0 1];
T3 = [cos(Os) -sin(Os) 0 0; sin(Os) cos(Os) 0 0; 0 0 1 0; 0 0 0 1];
T4 = [1 0 0 Lu; 0 1 0 0; 0 0 1 0; 0 0 0 1];
T5 = [cos(Oe) sin(Oe) 0 0; -sin(Oe) cos(Oe) 0 0; 0 0 1 0; 0 0 0 1];
T6 = [1 0 0 Lf; 0 1 0 0; 0 0 1 0; 0 0 0 1];
T7 = [cos(Ow) sin(Ow) 0 0; -sin(Ow) cos(Ow) 0 0; 0 0 1 0; 0 0 0 1];
T8 = [1 0 0 Lh; 0 1 0 0; 0 0 1 0; 0 0 0 1];
T = T1*T2*T3*T4*T5*T6*T7*T8;
T = T*[0;0;0;1]
S = solve(T(1)==0,T(2)==0,T(3)==1)
%J = [diff(T(1),'Ob'), diff(T(1),'Os'), diff(T(1),'Oe'); diff(T(2),'Ob'), diff(T(2),'Os'), diff(T(2),'Oe'); diff(T(3),'Ob'), diff(T(3),'Os'), diff(T(3),'Oe')];

