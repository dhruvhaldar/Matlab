function [ang1,ang2] = findLimit(fun1, fun2, ri, dr, R)
    global threshold deltamax;
    
    up1=fun1(R,0)+threshold+deltamax;
    um1=fun1(R,0)+threshold-deltamax;
    lp1=fun1(R,0)-threshold+deltamax;
    lm1=fun1(R,0)-threshold-deltamax;
    rup1 = findZeroPrev(@(r) fun1(r,up1),ri,dr,R);
    rum1 = findZeroPrev(@(r) fun1(r,um1),ri,dr,R);
    rlp1 = findZeroPrev(@(r) fun1(r,lp1),ri,dr,R);
    rlm1 = findZeroPrev(@(r) fun1(r,lm1),ri,dr,R);
    rsort1 = sort([R rup1 rum1 rlp1 rlm1]);
    rvalues1 = rsort1(cumsum(rsort1==R)==0);
    if (numel(rvalues1) == 1)
        rlims = [ri rvalues1];
    elseif (numel(rvalues1) > 1)
        rlims = [rvalues1(end-1) rvalues1(end)];
    else
        rlims = [NaN NaN];
    end
    
    u2=fun2(R,0)+threshold;
    ru2 = findZeroPrev(@(r) fun2(r,u2),ri,dr,R);
    l2=fun2(R,0)-threshold;
    rl2 = findZeroPrev(@(r) fun2(r,l2),ri,dr,R);
    rsort2 = sort([R ru2 rl2]);
    rvalues2 = rsort2(cumsum(rsort2==R)==0);
    if (numel(rvalues2)>0)
        rlim = rvalues2(end);
    else
        rlim = ri;
    end
    
    if (rlim > rlims(1))
        if (rlim < rlims(2))
            rlims(1) = rlim;
        else
            rlims = [NaN NaN];
        end
    end
% 
%     ang1(1) = fun1(rlims(1),0);
%     ang1(2) = fun1(rlims(2),0);
%     ang2(1) = fun2(rlims(1),0);
%     ang2(2) = fun2(rlims(2),0);

    phi = [threshold-deltamax, threshold+deltamax];

    ang1 = zeros(size(phi));
    ang2 = zeros(size(phi));

    for i=1:length(phi)
        ang1(i) = fun1(R,0)+phi(i);
        if (~isnan(ang1(i)))
            r = findZeroPrev(@(r) fun1(r,ang1(i)),ri,dr,R);
            if (~isnan(r))
                if (dr*(rlim(1)-r) > 0)
                    r = rlim(1);
                end
            end
            ang1(i) = fun1(r,0)+phi(i);
            ang2(i) = fun2(r,0)+phi(i);
        else
            ang2(i) = NaN;
        end
    end
end