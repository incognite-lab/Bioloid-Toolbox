function [  ] = setTorque( s, IDs, value )
% Turn off/on a torque in servos with the given IDs.
% All torques are set to the same value.
% The possible values are 1 and 0 (1 = turn on; 0 = turn off).

% check the input
if(value~=1 && value~=0)
    error('Value must be 1 or 0.')
end

% empty buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

for i=1:length(IDs)
    
    % create and send a packet
    packet = [255 255 IDs(i) 4 3 24 value];
    packet = [packet 255-(mod(sum(packet(3:end)),256))];
    fwrite(s,uint8(packet));
end

% empty buffer
if(s.BytesAvailable~=0)
    fread(s, s.BytesAvailable);
end

end


