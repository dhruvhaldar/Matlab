function r = findZeroPrev(fun,ri,dr,R)
    skip=0;
    rtest = ri;
    while (sign(fun(rtest)) == sign(fun(R)))
        rtest = rtest+dr;
        if(rtest >= R) 
            skip = 1;
            break;
        end
    end
    
    if (skip~=1)
        r = fzero(fun,[rtest,R]);    
    else
        r = NaN;
    end
end