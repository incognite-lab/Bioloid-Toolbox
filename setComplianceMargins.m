function [ statusPacket ] = setComplianceMargins( s, id, margin )
% Set CW and CCW Compliance Margin of a servo with the given id.
% Margin must be in range <0; 254>

% empty data buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% check range
if (margin<0 || margin>254)
    error('Margin out of range');
end

% create and send command packet
packet = [255, 255, id, 5, 3, 26, margin, margin];
packet = [packet 255-(mod(sum(packet(3:end)),256))];
fwrite(s,uint8(packet));

% read status packet (it contains motors error)
statusPacket=getStatusPacket(s);

end

