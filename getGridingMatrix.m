function [ colors, counts] = getGridingMatrix( s )
% Invoke griding algorithm and read grid of colors and counts
% For more information see datasheet for HaViMo 2
tic_capture=tic;

% send command for invoking griding algorithm
% there is no status packet
packet=[255, 255, 100, 2, 21];
packet = [packet 255-(mod(sum(packet(3:end)),256))];
fwrite(s,uint8(packet));

% empty serial port buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

% prepare vector for data
M=zeros(1,768);

% number of data bytes in received packet
l=128;

for i=0:l:767
    
    packet=[255, 255, 100, 4, 22, i/16, l];
    packet = [packet 255-(mod(sum(packet(3:end)),256))];
    fwrite(s,uint8(packet));
    
    tic_time=tic;
    time=0;
	
    while (s.BytesAvailable<(6+l) && time<3)
        time=toc(tic_time);
    end
	
	% if receiving time is bigger then 3 seconds
    if (time>=3)
        colors=NaN;
        counts=NaN;
        disp('time out in function getGridingMatrix')
        return;
    end
    % read status packet from serial port buffer
    statusPacket=fread(s, s.BytesAvailable)';
    
    % parse image data
    M((i+1):(i+1+l))=statusPacket(6:(l+6));
end

%fprintf('time of capturing the image: %.2fs\n',toc(tic_capture))

tic_processing=tic;

colors=zeros(1,768);
counts=zeros(1,768);

for i=1:length(M)-1
    
    if M(i)~=0
        % convert 8-bit number to a bit vector
        bitArr=bitget(M(i),1:8);
        
        % convert lower 4-bit to a number
        colors(i)=bin2dec(num2str(fliplr(bitArr(1:4))));
        
        % convert upper 4-bit to a number
        counts(i)=bin2dec(num2str(fliplr(bitArr(5:8))));
    else
        colors(i)=0;
        counts(i)=0;
    end
end

% convert vectors to matrices
colors=vec2mat(colors,32);
counts=vec2mat(counts,32);

%fprintf('time of processing image: %.2fs\n',toc(tic_processing))

end

