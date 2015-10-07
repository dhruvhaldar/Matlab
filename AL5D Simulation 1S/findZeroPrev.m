function t = findZeroPrev(fun,tvec,index)
    n = index;
    skip = 0;
    while (sign(fun(tvec(n))) == sign(fun(tvec(index))))
        n = n - 1;
        if(n < 1 ) 
            skip = 1;
            break;
        end
    end
    
    if (skip~=1)
        t = fzero(fun,[tvec(n),tvec(index)]);    
    else
        t = tvec(1);
    end
end