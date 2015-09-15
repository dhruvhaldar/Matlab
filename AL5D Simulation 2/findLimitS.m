function [sp1,sm1,sp2,sm2,ep,em,ro,rlims,slims] = findLimitS(sfun, efun, ri, rf, dr, R, phi)
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