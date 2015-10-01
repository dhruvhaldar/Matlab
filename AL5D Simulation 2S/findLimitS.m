function [sp,sm,ep,em,ro,rlim,slim] = findLimitS(sfun, efun, ri, rf, dr, R)
    global threshold;
    sp= sfun(R,0)+2*threshold;
    rsp = findZeroPrev(@(r) sfun(r,sp),ri,dr,R);
    sm = sfun(R,0)-2*threshold;
    rsm = findZeroPrev(@(r) sfun(r,sm),ri,dr,R);
    rval1 = [R rsp rsm];
    rval1 = rval1(~isnan(rval1));
    if (dr > 0)
        rval1 = sort(rval1);
    else
        rval1 = sort(rval1,'descend');
    end
    rval1 = rval1(cumsum(rval1==R)==0);
    if (numel(rval1) > 0)
        rlim1 = rval1;
    else
        rlim1 = ri;
    end

    ep=efun(R,0)+threshold;
    rp = findZeroPrev2(@(r) efun(r,ep),ri,rf,dr);
    rp2 = findZeroNext2(@(r) efun(r,ep),ri,rf,dr);
    rpo = rp;
    rp2o = rp2;
    
    em=efun(R,0)-threshold;
    rm = findZeroPrev2(@(r) efun(r,em),ri,rf,dr);
    rm2 = findZeroNext2(@(r) efun(r,em),ri,rf,dr);
    rmo = rm;
    rm2o = rm2;
    
    rvalo = [R rpo rmo rp2o rm2o];
    rvalo = sort(rvalo);
    rvalo(abs(diff(rvalo))<0.001) = NaN;
    rvalo = rvalo(~isnan(rvalo));
    if (dr > 0)
        rvalo = sort(rvalo);
    else
        rvalo = sort(rvalo,'descend');
    end
    ro = [NaN NaN NaN NaN];
    n = numel(rvalo);
    i = find(rvalo==R);
    switch(n)
        case 2,
            switch (i)
                case 1,
                    ro(1:2) = [ri rvalo(2)];
                case 2,
                    ro(1:2) = [rvalo(1) rf];
            end
        case 3,
            switch(i)
                case 1,
                    ro = [ri rvalo(2:3) rf];
                case 2,
                    ro(1:2) = rvalo([1 3]);
                case 3,
                    ro = [ri rvalo(1:2) rf];
            end
        case 4,
            switch(i)
                case 1,
                    ro = [ri rvalo(2:4)];
                case 2,
                    ro = [rvalo([1 3 4]) rf];
                case 3,
                    ro = [ri rvalo([1 2 4])];
                case 4,
                    ro = [rvalo(1:3) rf];
            end
        case 5
            ro = rvalo([1:i-1 i+1:end]);
    end
                    
    rval2 = [R rp rm rp2 rm2];
    rval2 = rval2(~isnan(rval2));
    if (dr > 0)
        rval2 = sort(rval2);
    else
        rval2 = sort(rval2,'descend');
    end
    rval2 = rval2(cumsum(rval2==R)==0);
    if (numel(rval2)>0)
        rlim2 = rval2(end);
    else
        rlim2 = ri;
    end

    if (dr*(rlim1 - rlim2) > 0)
        rlim = rlim1;
    else
        rlim = rlim2;
    end

    slim = sfun(rlim,0);
end