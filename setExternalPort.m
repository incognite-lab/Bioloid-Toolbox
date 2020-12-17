function [ statusValues ] = setExternalPort( s, id, value )
% Set pins of an external port to HIGH (3.3V) or LOW (0V) level.
% ID is a number of an external port (1-6).
% Value defines level combination for 2 pins of the external port.
%   0: OUT1(MOTx+)=LOW,  OUT2(MOTx-)=LOW
%   1: OUT1(MOTx+)=HIGH, OUT2(MOTx-)=LOW
%   2: OUT1(MOTx+)=LOW,  OUT2(MOTx-)=HIGH
% Function returns current combinatin of all external ports.

% check the input parameters
if (id>6 || id<0)
    error('Wrong id!');
end
if (value>2 || value<0)
    error('Wrong value!');
end

% empty serial port buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% create and send a command packet
% the command in the packet is executed by the CM530, the packet is not 
% redirected to the Dynamixel
packet = [255, 255, 114, 4, 3, id, value];
packet = [packet 255-(mod(sum(packet(3:end)),256))];
fwrite(s,uint8(packet));

%[255 255 114 7 port1 port2... port6 CS]
% check sum is a konstant, it is not yet implemented in the firmware
statusPacket=getStatusPacket(s);


statusValues=statusPacket(5:10);

end
