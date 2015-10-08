function t = findZeroPrev(fun,ti)
    t = ti-1;
    skip = 0;
    while (sign(fun(t)) == sign(fun(ti)))
        t = t - 1;
        if(t < 0 ) 
            skip = 1;
            break;
        end
    end
    
    if (skip~=1)
        t = fzero(fun,[t,ti]);    
    else
        t = 0;
    end
end