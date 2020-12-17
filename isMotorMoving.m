function [ out ] = isMotorMoving( s, id )
% Function returns 1 if motor is moving or 0 if motor is not moving.

% create a command packet
packet=[255, 255, id, 4, 2, 46, 1];
packet = [packet 255-(mod(sum(packet(3:end)),256))];

% number of trials
j=3;

while true
    
    % empty serial port buffer
    if(s.BytesAvailable~=0)
        fread(s, s.BytesAvailable);
    end
    
    % send the command packet
    fwrite(s,uint8(packet));
    
    % read status packet with reply
    status=getStatusPacket(s);
    
    % if checksum is OK, break out of the loop
    if CSCheck(status)
        break;
    else
        disp('isMotorMoving: CS is not correct!!!')
		disp(['trial number: ' num2str(j)])
        disp(status)
        if j<=1
            out=NaN;
            return;
        end
        j=j-1;
    end
    pause(0.3);
end

% get the answer
out=status(6);

if out~=0 && out ~=1
    disp('isMotorMoving: wrong output!!!')
	disp(['motors ID: ' num2str(id)])
end

end

