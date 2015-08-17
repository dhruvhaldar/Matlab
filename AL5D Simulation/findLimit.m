function [ang1,ang2] = findLimit(fun1, fun2, phi, ri, dr, R)
    global threshold deltamax;
    t=fun1(R,0)+phi;
    ulim=fun2(R,0)+(threshold+deltamax);
    llim=fun2(R,0)-(threshold+deltamax);
    r = findZeroPrev(@(r) fun1(r,t),ri,dr,R);

    if (~isnan(r))
        ang2 = fun2(r,0);
        if ( ang2 > ulim )
            ang2 = ulim;
            r = findZeroPrev(@(r) fun2(r,ang2),ri,dr,R);
        elseif ( ang2 < llim )
            ang2 = llim;
            r = findZeroPrev(@(r) fun2(r,ang2),ri,dr,R);
        end   
        ang1 = fun1(r,0);
    else
        rp = findZeroPrev(@(r) fun2(r,ulim),ri,dr,R);
        rm = findZeroPrev(@(r) fun2(r,llim),ri,dr,R);
        if(isnan(rp))
            if(isnan(rm))
                r = ri;
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
        ang1 = fun1(r,0);
        ang2 = fun2(r,0);
    end
end