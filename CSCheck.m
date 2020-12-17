function [ is_ok ] = CSCheck( packet )
% This function checks if a packet is without error.
% Output is boolean value.

if 255-(mod(sum(packet(3:end-1)),256))==packet(end)
    is_ok=true;
else
    is_ok = false;
end

end

