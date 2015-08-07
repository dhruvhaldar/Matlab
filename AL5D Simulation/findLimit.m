function [er,et,t] = findLimit(ri, r, delta)
    fun = @(r,C) (1007958012753983*acos((10*((2*r - 1207/10)^2 + r^2 - 3782334602438243/274877906944))/(2921*((2*r - 1207/10)^2 + r^2)^(1/2))))/17592186044416 + (1007958012753983*angle(r*(1 - 2*i) + (1207*i)/10))/17592186044416-C;
    t = fun(r,0);

    ct=t+delta;
    dt=t-delta;
    func = @(r) fun(r,ct);
    fund = @(r) fun(r,dt);

    skip=0;
    rtest = ri;
    while (sign(func(rtest)) == sign(func(r)))
        rtest = rtest+1;
        if(rtest >= r) 
            skip = 1;
            break;
        end
    end

    if (skip~=1)
        cr = fzero(func,[rtest,r]);
    else
        cr = NaN;
    end

    skip=0;
    rtest = ri;
    while (sign(fund(rtest)) == sign(fund(r)))
        rtest = rtest+1;
        if(rtest >= r) 
            skip = 1;
            break;
        end
    end

    if (skip~=1)
        dr=fzero(fund,[rtest,r]);
    else
        dr = NaN;
    end

    if isnan(cr)
        if (isnan(dr))
            er = NaN;
            et = NaN;
        else
            er = dr;
            et = dt;
        end
    else
        if (isnan(dr))
            er = cr;
            et = ct;
        else
            if (ct > dt)
                er = cr;
                et = ct;
            else
                er = dr;
                et = dt;
            end
        end
    end
end