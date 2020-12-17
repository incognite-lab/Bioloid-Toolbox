function [ value  ] = getDMS( s )
% Read value from DMS (Distance Measure Sensor). 
% The sensor must be connected to ADC5 port.
% for further information on hardware port map see
% http://support.robotis.com/en/software/embeded_c/cm530/programming/hardware_port_map_cm530.htm

% empty serial port buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% create and send command packet
% command in packet is executed by CM530, packet is not pass to Dynamixel.
packet=[255, 255, 112, 2, 1];
packet = [packet 255-(mod(sum(packet(3:end)),256))];
fwrite(s,uint8(packet));

% get status packet with reply
% [255,255,112,5,val_L,val_H,checkSum]
% check sum is a konstant, it is not yet implemented in custom firmware
statusPacket=getStatusPacket(s);

if( ~isnan(statusPacket(1)))

    % convert two 8-bit number into one 16-bit
    value=typecast(uint8(statusPacket(5:6)),'int16');
else
    value=NaN;
end
end

