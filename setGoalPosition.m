function [ statusPacket ] = setGoalPosition( s, ID, value)
% Rotate a motor with given id number to a given position (position range 0-1023)

% empty data buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% check range
if (value<0 || value>5024)
	disp('value out of range');
    statusPacket=NaN;
else
        
    % convert value to two 8-bit numbers
    value8 = [mod(value,256), floor(value/256)];
    
	% create and send command packet
    packet = [255 255 ID 5 3 30 value8];
    packet = [packet 255-(mod(sum(packet(3:end)),256))];
    fwrite(s,uint8(packet));
    
    % read status packet (it contains motors error)
    statusPacket=getStatusPacket(s);
        
end
end

