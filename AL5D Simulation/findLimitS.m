function [sp1,sm1,sp2,sm2,ep,em,rmo,rm2o,rpo,rp2o,rlims,slims] = findLimitS(sfun, efun, ri, rf, dr, R, phi)
    global threshold;
    sp1= sfun(R,0)+threshold+phi;
    rsp1 = findZeroPrev(@(r) sfun(r,sp1),ri,dr,R);
    sm1 = sfun(R,0)+threshold-phi;
    rsm1 = findZeroPrev(@(r) sfun(r,sm1),ri,dr,R);
    sp2= sfun(R,0)-threshold+phi;
    rsp2 = findZeroPrev(@(r) sfun(r,sp2),ri,dr,R);
    sm2 = sfun(R,0)-threshold-phi;
    rsm2 = findZeroPrev(@(r) sfun(r,sm2),ri,dr,R);
    if (dr > 0)
        rsort1 = sort([R rsp1 rsp2 rsm1 rsm2]);
    else
        rsort1 = sort([R rsp1 rsp2 rsm1 rsm2],1,'descend');
    end
    rvalues1 = rsort1(cumsum(rsort1==R)==0);
    if (numel(rvalues1) == 1)
        rlims = [ri rvalues1];
    elseif (numel(rvalues1) > 1)
        rlims = [rvalues1(end-1) rvalues1(end)];
    else
        rlims = [NaN NaN];
    end

    ep=efun(R,0)+threshold;
    rp = findZeroPrev2(@(r) efun(r,ep),ri,rf,dr);
    rp2 = findZeroNext2(@(r) efun(r,ep),ri,rf,dr);
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
    rm = findZeroPrev2(@(r) efun(r,em),ri,rf,dr);
    rm2 = findZeroNext2(@(r) efun(r,em),ri,rf,dr);
    rmo = rm;
    if (isnan(rmo))
        rmo = rp2o;
    end
    rm2o = rm2;
    if (dr > 0)
        rsort2 = sort([R rp rm rp2 rm2]);
    else
        rsort2 = sort([R rp rm rp2 rm2],1,'descend');
    end
    rvalues2 = rsort2(cumsum(rsort2==R)==0);
    if (numel(rvalues2)>0)
        rlim = rvalues2(end);
    else
        rlim = ri;
    end
    
    if (dr*(rlim-rlims(1) > 0))
        if (dr*(rlim-rlims(2) < 0))
            rlims(1) = rlim;
        else
            rlims = [NaN NaN];
        end
    end

    slims(1) = sfun(rlims(1),0);
    slims(2) = sfun(rlims(2),0);
end