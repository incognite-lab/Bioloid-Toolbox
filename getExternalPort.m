function [ statusValues ] = getExternalPort( s )
% Get current level combinatin of all external ports.
% Output is an array containing a combination for each port
% [port1 port2... port6]
% Level combinations are:
%   0: OUT1(MOTx+)=LOW,  OUT2(MOTx-)=LOW
%   1: OUT1(MOTx+)=HIGH, OUT2(MOTx-)=LOW
%   2: OUT1(MOTx+)=LOW,  OUT2(MOTx-)=HIGH

% empty serial port buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% create and send command packet
% the command in the packet is executed by the CM530, the packet is not 
% redirected to Dynamixel
packet = [255, 255, 114, 2, 2];
packet = [packet 255-(mod(sum(packet(3:end)),256))];
fwrite(s,uint8(packet));

%[255 255 114 7 port1 port2... port6 CS]
% check sum is a konstant, it is not yet implemented in the firmware
statusPacket=getStatusPacket(s);

statusValues=statusPacket(5:10);

end

