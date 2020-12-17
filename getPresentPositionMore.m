function [ positions ] = getPresentPositionMore( s, ids )
% Function reads present position from servos with given ID numbers

% preallocate variable
positions=zeros(1,length(ids));
 
% read present position from servos
for i=1:length(ids)
    positions(i)=getPresentPosition(s,ids(i));
end

end

