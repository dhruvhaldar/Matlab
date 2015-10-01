function [er,et,s] = findLimitOld(ri, hi, dr, dh, R, phi)
    global BASE_HEIGHT HUMERUS ULNA;
    h = @(r)(dh/dr)*(r-ri)+hi;
    s2w_r = @(r)r;
    s2w_h = @(r)h(r)-BASE_HEIGHT;
    s2w = @(r)( s2w_h(r) * s2w_h(r) ) + ( s2w_r(r) * s2w_r(r) ); % (Length of line from shoulder to wrist (S-W))^2
    a1 = @(r) atan2( s2w_h(r),s2w_r(r) ); % Angle between S-W line and ground
    a2 = @(r) acos((( HUMERUS^2 - ULNA^2 ) + s2w(r) ) / ( 2 * HUMERUS * sqrt( s2w(r) ) )); % Angle between S-W line and humerus
    efun = @(r,C) acosd(( HUMERUS^2 + ULNA^2 - s2w(r) ) / ( 2 * HUMERUS * ULNA )) - C; % Angle between humerus and ulna
    sfun = @(r,C) radtodeg(a1(r)+a2(r))-C;
    s = sfun(R,0);
    e = efun(R,0);

    t=s+phi;
    sfun = @(r) sfun(r,t);

    skip=0;
    rtest = ri;
    while (sign(sfun(rtest)) == sign(sfun(R)))
        rtest = rtest+1;
        if(rtest >= R) 
            skip = 1;
            break;
        end
    end

    if (skip~=1)
        er = fzero(sfun,[rtest,R]);
        et = sfun(rtest);
    else
        er = NaN;
        et = NaN;
    end

end