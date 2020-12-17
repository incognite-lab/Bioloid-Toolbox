%% move servo from 0 to 1023 and read its position during the movement
 
% go to position 0
id=13;
setGoalPosition(s,id,0);
 
% wait until servo is in final position
while(isMotorMoving(s,id))
end
pause(0.5);
position=0;
tic_get=tic;
time=0;

% go to position 1023
setGoalPosition(s,id,1023);
 
% while servo is moving, read its position
while(true)%isMotorMoving(s,1))
   position=[position, getPresentPosition(s,id)];
   time=[time, toc(tic_get)];
   if (time(end)>1.2)
       break;
   end
end

% plot values
pos=double(position)./1023*300;
plot(time,pos)
hold on
plot(time,pos,'ro')
axis([0 1.2 0 320])
title('Závislost natoèení motoru na èase')
xlabel('èas [s]')
ylabel('úhel natoèení [°]')
hold off

%% For 10 seconds read values from IR sensors and print them on the screen
 
time=0;
timer=tic;
 
% read and print for 10 seconds
while time<10 
    time=toc(timer);
    
    ir=getIR(s1);
    fprintf('%4.0f %4.0f\n',ir(1), ir(2))
end
fprintf('***********\n')


%% create vector of positions of servos with ID=1,...,ID=18
 
% preallocate variable
positions=zeros(1,18);
 
% read present position from servos 1-18
for i=1:length(positions)
    positions(i)=getPresentPosition(s,i);
end

