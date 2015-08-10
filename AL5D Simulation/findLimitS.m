function [r,s,e,ep,em] = findLimitS(sfun, efun, ri, dr, R, phi)
    global threshold;
    t=sfun(R,0)+phi;
    ep=efun(R,0)+threshold;
    em=efun(R,0)-threshold;
    skip=0;
    rtest = ri;
    while (sign(sfun(rtest,t)) == sign(sfun(R,t)))
        rtest = rtest+dr;
        if(rtest >= R) 
            skip = 1;
            break;
        end
    end

    if (skip~=1)
        r = fzero(@(r) sfun(r,t),[rtest,R]);
        s = sfun(r,0);
        e = efun(r,0);
        if ( e > ep )
            e = ep;
            r = fzero(@(r) efun(r,e),R);
            s = sfun(r,0);
        elseif ( e < em )
            e = em;
            r = fzero(@(r) efun(r,e),R);
            s = sfun(r,0);
        end      
    else
        s = NaN;
        e = NaN;
        r = NaN;
        % TODO
    end
    
end