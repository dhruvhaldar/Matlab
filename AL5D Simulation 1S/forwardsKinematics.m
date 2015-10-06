function [elb, wri, tip] = forwardsKinematics(basAngle_d, shlAngle_d, elbAngle_d, handAngle_d )
   
   global BASE_HEIGHT HUMERUS ULNA HAND;

   elb_r = HUMERUS*cosd( shlAngle_d );
   
   elb_x = elb_r.*sind(basAngle_d);
   
   elb_y = elb_r.*cosd(basAngle_d);
   
   elb_z = BASE_HEIGHT + HUMERUS*sind( shlAngle_d );
   
   elb = [elb_x; elb_y; elb_z];
   
   wri_r = elb_r + ULNA*cosd( shlAngle_d + elbAngle_d - 180 );
   
   wri_x = wri_r.*sind(basAngle_d);
   
   wri_y = wri_r.*cosd(basAngle_d);
   
   wri_z = elb_z + ULNA*sind( shlAngle_d + elbAngle_d - 180 );
   
   wri = [wri_x; wri_y; wri_z];
   
   tip_r = wri_r + HAND*cosd( handAngle_d );
   
   tip_x = tip_r.*sind(basAngle_d);
   
   tip_y = tip_r.*cosd(basAngle_d);
   
   tip_z = wri_z + HAND*sind( handAngle_d );
   
   tip = [tip_x; tip_y; tip_z];
   
end