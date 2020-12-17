function []=moveHand(s,x,y,z)
%Move robots effector to the given position

[th1, th2, th3]=iktHand(x,y,z);

setGoalPosition(s,2,th1);
setGoalPosition(s,4,th2);
setGoalPosition(s,6,th3);

end

function [th1, th2, th3]=iktHand(x,y,z)
l1=75;
l2=84;
l3=185;

if (sqrt(x^2+y^2+(z-l1)^2)>(l2+l3) || sqrt(x^2+y^2+(z-l1)^2)<(l3-l2))
    error('Unreachable position!')
end

Px=sqrt(x^2+y^2)+10^-10;
Py=z-l1;

% analytic solution of an intersection of two circles
Cx=(Px^2 + Py^2 + l2^2 - l3^2 - (Py*(Px*((- Px^2 - Py^2 + l2^2 +...
    2*l2*l3 + l3^2)*(Px^2 + Py^2 - l2^2 + 2*l2*l3 - l3^2))^(1/2) +...
    Px^2*Py + Py*l2^2 - Py*l3^2 + Py^3))/(Px^2 + Py^2))/(2*Px);
Cy=(Px*((- Px^2 - Py^2 + l2^2 + 2*l2*l3 + l3^2)*(Px^2 + Py^2 -...
    l2^2 + 2*l2*l3 - l3^2))^(1/2) + Px^2*Py + Py*l2^2 - Py*l3^2 +...
    Py^3)/(2*(Px^2 + Py^2));

th1=atan2(x,y);
th1=512-th1*307.2*2/pi;
th2=atan2(-Cx,Cy);
th2=512-th2*307.2*2/pi;
th3=atan2(-(Px-Cx),Py-Cy);
th3=512-th3*307.2*2/pi+512-th2;

if(th2>850 || th2<220)
    error('Angle th2 is out of range!')
end
if(th3>980 || th3<470)
    error('Angle th3 is out of range!')
end

end