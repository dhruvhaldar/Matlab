function [ang1,ang2] = findLimit(fun1, fun2, ri, dr, R)
    global threshold deltamax;
    
    ulim=fun2(R,0)+(threshold+deltamax);
    llim=fun2(R,0)-(threshold+deltamax);
    ru = findZeroPrev(@(r) fun2(r,ulim),ri,dr,R);
    ang1u = fun1(ru,0)
    rl = findZeroPrev(@(r) fun2(r,llim),ri,dr,R);
    ang1l = fun1(rl,0)
%     rmin = findZeroPrev(@(r) fun1(r,smin),ri,dr,R);

%     phi = linspace(threshold-deltamax,threshold+deltamax,100);
    phi = [threshold-deltamax, threshold+deltamax];
    
    ang1 = zeros(size(phi));
    ang2 = zeros(size(phi));

    for i=1:length(phi)
        ang1(i) = fun1(R,0)+phi(i);
        if (~isnan(ang1(i)))
            r = findZeroPrev(@(r) fun1(r,ang1(i)),ri,dr,R);
            ang2(i) = fun2(r,0);
            if (~isnan(r))
                if ( ang1(i) > ang1u )
                    ang1(i) = ang1u;
                    ang2(i) = ulim;
                elseif ( ang1(i) < ang1l )
                    ang1(i) = ang1l;
                    ang2(i) = llim;
                end   
            end
        else
            ang2(i) = NaN;
        end
    end
    
    global threshold;
    sp1= sfun(R,0)+threshold+phi;
    rsp1 = findZeroPrev(@(r) sfun(r,sp1),ri,dr,R);
    sm1 = sfun(R,0)+threshold-phi;
    rsm1 = findZeroPrev(@(r) sfun(r,sm1),ri,dr,R);
    sp2= sfun(R,0)-threshold+phi;
    rsp2 = findZeroPrev(@(r) sfun(r,sp2),ri,dr,R);
    sm2 = sfun(R,0)-threshold-phi;
    rsm2 = findZeroPrev(@(r) sfun(r,sm2),ri,dr,R);
    rsort1 = sort([R rsp1 rsp2 rsm1 rsm2]);
    rvalues1 = rsort1(cumsum(rsort1==R)==0);
    if (numel(rvalues1) == 1)
        rlims = [ri rvalues1];
    elseif (numel(rvalues1) > 1)
        rlims = [rvalues1(end-1) rvalues1(end)];
    else
        rlims = [NaN NaN];
    end

    ep=efun(R,0)+threshold;
    rp = findZeroPrev2(@(r) efun(r,ep),ri,rf,dr,R);
    rp2 = findZeroNext2(@(r) efun(r,ep),ri,rf,dr,R);
    rpo = rp;
    rp2o = rp2;
    if(abs(rp2o - rpo) < 0.01)
        rp2o = rf;
    end
    if (isnan(rpo))
        rpo = ri;
    end
    if (isnan(rp2o))
        rp2o = rf;
    end
    em=efun(R,0)-threshold;
    rm = findZeroPrev2(@(r) efun(r,em),ri,rf,dr,R);
    rm2 = findZeroNext2(@(r) efun(r,em),ri,rf,dr,R);
    rmo = rm;
    if (isnan(rmo))
        rmo = rp2o;
    end
    rm2o = rm2;
    rsort2 = sort([R rp rm rp2 rm2]);
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

    slims(1) = sfun(rlims(1),0);
    slims(2) = sfun(rlims(2),0);
end