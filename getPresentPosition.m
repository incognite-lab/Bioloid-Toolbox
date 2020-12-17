function [ out ] = getPresentPosition( s, id )
%Function reads present position of a servo with the given id number.

% create a command packet
packet=[255, 255, id, 4, 2, 36, 2];
packet = [packet 255-(mod(sum(packet(3:end)),256))];

% number of trials
j=3;

while true
    
    % empty serial port buffer
    if(s.BytesAvailable~=0)
        fread(s, s.BytesAvailable);
    end
    
    % send the command packet
    fwrite(s,uint8(packet));
    
    % read status packet with reply
    status=getStatusPacket(s);
    
    % if checksum is OK, break out of the loop
    if CSCheck(status)
        break;
    else
        disp('getPresentPosition: CS is not correct!!!')
		disp(['trial number: ' num2str(j)])
        disp(status)
        if j<=1
            out=NaN;
            return;
        end
        j=j-1;
    end
    pause(0.3)
end

% convert two 8-bit numbers into one 16-bit number
position=uint8(status(6:7));
out=typecast(position,'int16');

if out<0 || out >4096
    disp('getPresentPosition: wrong output!!!')
	disp(['motors ID: ' num2str(id)])
end

end

