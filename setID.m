function [ statusPacket ] = setID( s, id, new_id )

% empty data buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% check range
if (id<1 || id>255)
	disp('value out of range');
    statusPacket=NaN;
else

	% create and send command packet
    packet = [255 255 id 4 3 3 new_id];
    packet = [packet 255-(mod(sum(packet(3:end)),256))];
    fwrite(s,uint8(packet));
    
    % read status packet (it contains motors error)
    statusPacket=getStatusPacket(s);
        
end
end

