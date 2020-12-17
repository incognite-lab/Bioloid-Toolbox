function [ statusPacket ] = getStatusPacket( s )
% read status packet from serial port buffer

try
    
    packet=zeros(1,1024);
    packet(4)=1018;
    i=1;
    
    % waiting time for first byte
    byteTime=0.5;
    
    % wait for the beginning of the packet
    tic_wait=tic;
    time=0;
    while (s.BytesAvailable < 1 && time<byteTime)
        time=toc(tic_wait);
    end
    
    % time out
    if (time>=byteTime)
        disp('Time out: first byte')
        statusPacket=NaN;
        return;
    end
    
    % waiting time for the whole packet
    timeOut=0.8;
    tic_wait=tic;
    time=0;
    
    % find the beginning of the packet
    while packet(2)~=255 && time<timeOut
        temp=fread(s,1);
        if temp==255
            packet(i)=temp;
            i=i+1;
        end
        time=toc(tic_wait);
    end
    
    % time out
    if (time>=timeOut)
        statusPacket=NaN;
        disp('Time out: beginning of the package')
        return;
    end
    
    % read the rest of the packet
    while i<packet(4)+6 && time<timeOut
        
        if s.BytesAvailable > 0
            packet(i)=fread(s,1);
            i=i+1;
        end
        
        time=toc(tic_wait);
    end
    
    % time out
    if (time>=timeOut)
        statusPacket=NaN;
        disp('Time out: whole package')
        return;
    end
    
    
    statusPacket=packet(1:packet(4)+4);
catch e
    disp(e)
end

end


%{
%OLD VERSION
% read status packet from serial port buffer

% waiting time for one byte
byteTime=0.10;

% wait for first four bytes (4th byte contains packet length)
tic_wait=tic;
time=0;
while (s.BytesAvailable<4 && time<4*byteTime)
    time=toc(tic_wait);
end

% time out
if (time>=4*byteTime)
    statusPacket=NaN;
    return;
end

% read first four bytes (255,255,ID, length)
statusPacket=fread(s, 4)';
length=statusPacket(4);

% check start of the packet
if (statusPacket(1)~=255 && statusPacket(2)~=255)
    statusPacket=NaN;
    return;
end

% waiting time for one byte
byteTime=0.02;

% wait for the rest of the packet
tic_wait=tic;
time=0;
while (s.BytesAvailable<length && time<length*byteTime)
    time=toc(tic_wait);
end

% time out
if (time>=length*byteTime)
    statusPacket=NaN;
    return;
end

% read the rest of the buffer
statusPacket=[ statusPacket, fread(s, s.BytesAvailable)'];

% terminating char '\n' at the end of the transmitted packet is removed
statusPacket=statusPacket(1:(length+4));

%}
