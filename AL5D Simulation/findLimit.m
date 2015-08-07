function [er,et,t] = findLimit(ri, hi, dr, dh, r, delta)
    global BASE_HEIGHT HUMERUS ULNA;
    h = @(r)(dh/dr)*(r-ri)+hi;
    s2w_r = @(r)r;
    s2w_h = @(r)h(r)-BASE_HEIGHT;
    s2w = @(r)( s2w_h(r) * s2w_h(r) ) + ( s2w_r(r) * s2w_r(r) ); % (Length of line from shoulder to wrist (S-W))^2
    a1 = @(r) atan2( s2w_h(r),s2w_r(r) ); % Angle between S-W line and ground
    a2 = @(r) acos((( HUMERUS^2 - ULNA^2 ) + s2w(r) ) / ( 2 * HUMERUS * sqrt( s2w(r) ) )); % Angle between S-W line and humerus
    fun = @(r,C) radtodeg(a1(r)+a2(r))-C;
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
            er = ri;
            et = fun(ri,0);
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