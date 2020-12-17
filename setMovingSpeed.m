function [ statusPacket ] = setMovingSpeed( s, ID, value)
% Set a moving speed to a motor with given id number (range of value 0-1023)

% empty buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% check range
if (value<0 || value>1024)
	disp('value out of range');
    statusPacket=NaN;
else
    value8 = [];
    
    % convert one integer into two 8-bit numbers
    for i = 1:length(value)
        value8 = [value8 mod(value(i)-floor(value(i)/256)*256,256) floor(value(i)/256)];
    end
    
	% create and send command packet
    packet = [255 255 ID 5 3 32 value8];
    packet = [packet 255-(mod(sum(packet(3:end)),256))];
    fwrite(s,uint8(packet));
    
    % read status paket
    statusPacket=getStatusPacket(s);
        
end
end

