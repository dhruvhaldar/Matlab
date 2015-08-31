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
    rval1 = [R rsp1 rsp2 rsm1 rsm2];
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

    ep=efun(R,0)+threshold;
    rp = findZeroPrev2(@(r) efun(r,ep),ri,rf,dr);
    rp2 = findZeroNext2(@(r) efun(r,ep),ri,rf,dr);
    rpo = rp;
    rp2o = rp2;
    if(abs(rp2o - rpo) < 0.01)
        if (abs(rpo-ri) < abs(rpo-rf))
            rp2o = rf;
        else
            rpo = ri;
        end
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
    rval2 = [R rp rm rp2 rm2];
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

    slims(1) = sfun(rlims(1),0);
    slims(2) = sfun(rlims(2),0);
end