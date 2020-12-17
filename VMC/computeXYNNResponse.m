function [ response ] = computeXYNNResponse( code, centroid )

response=zeros(1,2);
for k=1:size(code,3)
    response(k)=sum(sum(code(:,:,k).*centroid));
end

end

