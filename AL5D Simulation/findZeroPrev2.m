function r = findZeroPrev2(fun,ri,rf,dr)
    skip=0;
    rtest = ri;
    while (sign(fun(rtest)) == sign(fun(ri)))
        rtest = rtest+dr;
        if(dr*(rtest - rf) > 0) 
            skip = 1;
            break;
        end
    end
    
    if (skip~=1)
        r = fzero(fun,[ri,rtest]);    
    else
        r = NaN;
    end
end