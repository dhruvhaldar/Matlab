function [shlAngle_d, elbAngle_d, wriAngle_d] = inverseKinematics(radius_mm, height_mm, handAngle_d )
   
    global BASE_HEIGHT HUMERUS ULNA HAND;

    s2w_h = height_mm - BASE_HEIGHT - HAND*sind( handAngle_d );
    s2w_r = radius_mm - HAND*cosd( handAngle_d );
    
    s2w = ( s2w_h * s2w_h ) + ( s2w_r * s2w_r ); % (Length of line from shoulder to wrist (S-W))^2
    
    if ( sqrt( s2w ) > HUMERUS + ULNA )
        error('Error, out of range');
    end
    
    a1 = atan2( s2w_h, s2w_r ); % Angle between S-W line and ground
    a2 = acos((( HUMERUS^2 - ULNA^2 ) + s2w ) / ( 2 * HUMERUS * sqrt( s2w ) )); % Angle between S-W line and humerus
    
    shlAngle_d = radtodeg(a1 + a2);
    elbAngle_d = acosd(( HUMERUS^2 + ULNA^2 - s2w ) / ( 2 * HUMERUS * ULNA )); % Angle between humerus and ulna
    wriAngle_d = 360 + handAngle_d - shlAngle_d - elbAngle_d;
    
end