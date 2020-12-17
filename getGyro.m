function [ values ] = getGyro( s )
% Read values from gyro sensor.
% Gyro must be connected to ADC3 and ADC4 ports
% for further information on ADC ports see
% http://support.robotis.com/en/software/embeded_c/cm530/programming/hardware_port_map_cm530.htm

% empty serial port buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% create and send command packet
% command in packet is executed by CM530, packet is not pass to Dynamixel.
packet=[255, 255, 113, 2, 1];
packet = [packet 255-(mod(sum(packet(3:end)),256))];
fwrite(s,uint8(packet));

% read status packet with reply
% [255,255,113,5,val1_L,val1_H,val2_L,val2_H,checkSum]
% check sum is a konstant, it is not yet implemented in custom firmware
statusPacket=getStatusPacket(s);
if( ~isnan(statusPacket(1)))
    
	% convert two 8-bit numbers into one 16-bit number
    values(1)=typecast(uint8(statusPacket(5:6)),'int16');
    values(2)=typecast(uint8(statusPacket(7:8)),'int16');
else
    values=[NaN NaN];
end
end

