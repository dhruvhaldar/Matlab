function [elb_r, elb_h, wri_r, wri_h, tip_r, tip_h, handAngle_d] = forwardsKinematics(shlAngle_d, elbAngle_d, wriAngle_d )
   
   global BASE_HEIGHT HUMERUS ULNA HAND s e w;

   s = shlAngle_d;
   e = elbAngle_d - 180;
   w = wriAngle_d - 180;
   
   handAngle_d = s + e + w;
   
   elb_r = HUMERUS*cosd( s );
   
   elb_h = BASE_HEIGHT + HUMERUS*sind( s );
   
   wri_r = elb_r + ULNA*cosd( s + e );
   
   wri_h = elb_h + ULNA*sind( s + e );
   
   tip_r = wri_r + HAND*cosd( handAngle_d );
   
   tip_h = wri_h + HAND*sind( handAngle_d );
   
end