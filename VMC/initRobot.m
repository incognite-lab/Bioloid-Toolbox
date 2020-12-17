function [  ] = initRobot( s )
%Set servos parameters.

speed=30;
marg=2;
servos=[2 4 6];

for i=servos
    setMovingSpeed(s,i,speed);
    setComplianceMargins(s,i,marg);
end
setMovingSpeed(s,6,round(speed*0.8));
end

