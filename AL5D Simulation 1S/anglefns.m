function [rfn, afn, zfn, dfn, sfn, efn, wfn, deltafn] = anglefns(pos1, pos2, duration)
    global BASE_HEIGHT HUMERUS ULNA;
    rfn = @(t) (pos2(1)-pos1(1))*t/duration + pos1(1);
    afn = @(t) (pos2(2)-pos1(2))*t/duration + pos1(2);
    zfn = @(t) (pos2(3)-pos1(3))*t/duration + pos1(3);
    dfn = @(t) (pos2(4)-pos1(4))*t/duration + pos1(4);
    s2w_r = @(t)rfn(t);
    s2w_h = @(t)zfn(t)-BASE_HEIGHT;
    s2w = @(t)( s2w_h(t) .* s2w_h(t) ) + ( s2w_r(t) .* s2w_r(t) ); % (Length of line from shoulder to wrist (S-W))^2
    a1 = @(t) atan2( s2w_h(t),s2w_r(t) ); % Angle between S-W line and ground
    a2 = @(t) acos((( HUMERUS^2 - ULNA^2 ) + s2w(t) ) ./ ( 2 * HUMERUS * sqrt( s2w(t) ) )); % Angle between S-W line and humerus
    sfn = @(t,C) radtodeg(a1(t)+a2(t))-C;
    efn = @(t,C) acosd(( HUMERUS^2 + ULNA^2 - s2w(t) ) ./ ( 2 * HUMERUS * ULNA )) - C; % Angle between humerus and ulna
    wfn = @(t,Ce,Cs) 360-sfn(t,Ce)-efn(t,Cs)+dfn(t);
    deltafn = @(t,ti,C) real(acosd(cosd(afn(t) - afn(ti)).*cosd(sfn(ti,0)).*cosd(sfn(t,0))+sind(sfn(ti,0)).*sind(sfn(t,0)))-C);
end