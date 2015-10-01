function [r,s,sp,sm,e,ep,em] = findLimitE(sfun, efun, ri, dr, R, phi)
    global threshold;
    t=sfun(R,0)+phi;
    sp= sfun(R,0)+phi;
    sm = sfun(R,0)-phi;
    ep=efun(R,0)+threshold;
    em=efun(R,0)-threshold;
    r = findZeroPrev(@(r) sfun(r,t),ri,dr,R);

    if (~isnan(r))
        e = efun(r,0);
        if ( e > ep )
            e = ep;
            r = findZeroPrev(@(r) efun(r,e),ri,dr,R);
        elseif ( e < em )
            e = em;
            r = findZeroPrev(@(r) efun(r,e),ri,dr,R);
        end   
        s = sfun(r,0);
    else
        rp = findZeroPrev(@(r) efun(r,ep),ri,dr,R);
        rm = findZeroPrev(@(r) efun(r,em),ri,dr,R);
        if(isnan(rp))
            if(isnan(rm))
                r = NaN;
            else
                r = rm;
            end
        else
            if(isnan(rm))
                r = rp;
            else
                if (abs(R-rp) < abs(R-rm))
                    r = rp;
                else
                    r = rm;
                end
            end
        end
        s = sfun(r,0);
        e = efun(r,0);
    end
    
end