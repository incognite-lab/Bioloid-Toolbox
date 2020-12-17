function [  ] = saveData( num, distances, times, labels, data )
%Save data for further use.

save(['data/distances' num2str(num)], 'distances');
save(['data/times' num2str(num)], 'times');
save(['data/labels' num2str(num)], 'labels');
save(['data/data' num2str(num)], 'data');

end

