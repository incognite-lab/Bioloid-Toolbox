function [ response, value] = computeCentroidNNResponse( code, image )

distMatrix=zeros(size(image));
for k=1:size(code,3)
    distMatrix(k)=sum(sum(code(:,:,k).*image));
end

[val, pos]=max(distMatrix);
[~, pos2]=max(val);
x=pos(pos2);
y=pos2;

response=zeros(size(image));
response(x,y)=1;
value=distMatrix(x,y);

end

