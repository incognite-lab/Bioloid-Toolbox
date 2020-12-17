function [ x, y, z ] = whereIsHand( s )
% Returns a position of the robots effector.

pause(0.5);
% READ SERVOS ANGLES
th=getPresentPositionMore(s,[2 4 6]);
th1=th(1);
th2=th(2);
th3=th(3);

% if th1<0 || th2<0 || th3<0 || th1>1024 || th2>1024 || th3>1024
%     disp('WTF')
% end

% ARM PARAMETERS
l1=75;
l2=84;
l3=185;

% ANGLE CONVERSION
r=300/1024;
th1=(-th1*r+240-90)*pi/180;
th2=(-th2*r+240)*pi/180;
th3=(-th3*r+240-90)*pi/180;

% COMPUTATION
a=l2*cos(th2)+l3*cos(th2+th3);
b=l2*sin(th2)+l3*sin(th2+th3);

x=a*sin(th1);
y=a*cos(th1);
z=b+l1;

end

