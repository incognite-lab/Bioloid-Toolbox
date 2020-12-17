function [ statusPacket ] = setBaudRate( s, id, baudRate )

% empty data buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% create and send command packet
packet = [255 255 id 4 3 4 baudRate];
packet = [packet 255-(mod(sum(packet(3:end)),256))];
fwrite(s,uint8(packet));

% read status packet (it contains motors error)
statusPacket=getStatusPacket(s);

end

