function [ values ] = getIR( s )
% Read values from IR sensors.
% IR sensors must be connected to ADC1 and ADC6 ports.
% for further information on ADC ports see
% http://support.robotis.com/en/software/embeded_c/cm530/programming/hardware_port_map_cm530.htm
% IR light is turned on only while CM530 reading sensors voltages

% empty serial port buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% create and send a command packet
% the command in the packet is executed by CM530, it is not passed to Dynamixel
packet=[255, 255, 111, 2, 1];
packet = [packet 255-(mod(sum(packet(3:end)),256))];
fwrite(s,uint8(packet));

% read status packet with reply
% [255,255,111,5,val1_L,val1_H,val2_L,val2_H,checkSum]
% check sum is a konstant, it is not yet implemented in the custom firmware
statusPacket=getStatusPacket(s);
if( ~isnan(statusPacket(1)))
    values=[0 0];
	% convert two 8-bit numbers into one 16-bit number
    values(1)=typecast(uint8(statusPacket(5:6)),'int16');
    values(2)=typecast(uint8(statusPacket(7:8)),'int16');
else
    values=[NaN NaN];
end

end

