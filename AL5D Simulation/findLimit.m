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
    rval1 = [R rup1 rum1 rlp1 rlm1];
    rval1 = rval1(~isnan(rval1));
    if (dr > 0)
        rval1 = sort(rval1);
    else
        rval1 = sort(rval1,'descend');
    end
    rval1 = rval1(cumsum(rval1==R)==0);
    if (numel(rval1) == 1)
        rlims = [ri rval1];
    elseif (numel(rval1) > 1)
        rlims = [rval1(end-1) rval1(end)];
    else
        rlims = [NaN NaN];
    end
    
    u2=fun2(R,0)+threshold;
    ru2 = findZeroPrev(@(r) fun2(r,u2),ri,dr,R);
    l2=fun2(R,0)-threshold;
    rl2 = findZeroPrev(@(r) fun2(r,l2),ri,dr,R);
    rval2 = [R ru2 rl2];
    rval2 = rval2(~isnan(rval2));
    if (dr > 0)
        rval2 = sort(rval2);
    else
        rval2 = sort(rval2,'descend');
    end
    
    rval2 = rval2(cumsum(rval2==R)==0);
    if (numel(rval2)>0)
        rlim = rval2(end);
    else
        rlim = ri;
    end
    
    if (dr > 0)
        if(rlim > rlims(1))
            if (rlim < rlims(2))
                rlims(1) = rlim;
            else
                rlims = [NaN NaN];
            end
        end
    else
        if(rlim < rlims(1))
            if (rlim > rlims(2))
                rlims(1) = rlim;
            else
                rlims = [NaN NaN];
            end
        end
    end
% 
%     ang1(1) = fun1(rlims(1),0);
%     ang1(2) = fun1(rlims(2),0);
%     ang2(1) = fun2(rlims(1),0);
%     ang2(2) = fun2(rlims(2),0);
% 
    phi = linspace(-deltamax,deltamax,50);

    ang1 = zeros(size(phi));
    ang2 = zeros(size(phi));

    for i=1:length(phi)
        u = fun1(R,0)+threshold+phi(i);
        l = fun1(R,0)-threshold-phi(i);
        ru = findZeroPrev(@(r) fun1(r,u),ri,dr,R);
        rl = findZeroPrev(@(r) fun1(r,l),ri,dr,R);
        rval = [R, ru, rl, rlims(1)];
        rval = rval(~isnan(rval));
        if (dr > 0) rval = sort(rval);
        else rval = sort(rval,'descend');
        end
        rval = rval(cumsum(rval==R)==0);
        r = NaN;
        if (numel(rval) > 0 && dr*(rval(end)-rlim) >= 0 )
            r = rval(end);
        end
        ang1(i) = fun1(r,0);
        ang2(i) = fun2(r,0);
    end
end