function r = findZeroPrev2(fun,ri,rf,dr,R)
    skip=0;
    rtest = ri;
    while (sign(fun(rtest)) == sign(fun(ri)))
        rtest = rtest+dr;
        if(rtest > rf) 
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