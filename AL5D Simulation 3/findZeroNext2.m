function r = findZeroNext2(fun,ri,rf,dr)
    skip=0;
    rtest = rf;
    while (sign(fun(rtest)) == sign(fun(rf)))
        rtest = rtest-dr;
        if(dr*(rtest - ri) < 0) 
            skip = 1;
            break;
        end
    end
    
    if (skip~=1)
        r = fzero(fun,[rtest,rf]);    
    else
        r = NaN;
    end
end