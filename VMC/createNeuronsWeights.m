function [ nw_center, nw_xy ] = createNeuronsWeights( siz, r )
%Returns the weights of the neurons for the two static neural networks

canvas=zeros(siz(1), siz(2));
[X Y]=meshgrid(1:siz(1),1:siz(2));
X=X'; Y=Y';
nw_center=zeros(siz(1),siz(2),siz(1)*siz(2));

for k=1:size(nw_center,3)
    x=X(k);
    y=Y(k);
    dist=canvas;
    for i=1:size(nw_center,1)
        for j=1:size(nw_center,2)
            dist(i,j)=sqrt((x-X(i,j))^2+(y-Y(i,j))^2);
        end
    end
    nw_center(:,:,k)=r-dist;
end

nw_center(nw_center<0)=0;

nw_xy(:,:,1)=X;
nw_xy(:,:,2)=Y;

end

