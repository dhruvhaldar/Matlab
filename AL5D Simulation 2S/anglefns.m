function [sfun, efun] = anglefns(ri, hi, dr, dh)
    global BASE_HEIGHT HUMERUS ULNA;
    h = @(r)(dh/dr)*(r-ri)+hi;
    s2w_r = @(r)r;
    s2w_h = @(r)h(r)-BASE_HEIGHT;
    s2w = @(r)( s2w_h(r) * s2w_h(r) ) + ( s2w_r(r) * s2w_r(r) ); % (Length of line from shoulder to wrist (S-W))^2
    a1 = @(r) atan2( s2w_h(r),s2w_r(r) ); % Angle between S-W line and ground
    a2 = @(r) acos((( HUMERUS^2 - ULNA^2 ) + s2w(r) ) / ( 2 * HUMERUS * sqrt( s2w(r) ) )); % Angle between S-W line and humerus
    efun = @(r,C) acosd(( HUMERUS^2 + ULNA^2 - s2w(r) ) / ( 2 * HUMERUS * ULNA )) - C; % Angle between humerus and ulna
    sfun = @(r,C) radtodeg(a1(r)+a2(r))-C;
end