function [ img_out ] = preprocessImage( img_in, size_out )
%Returns prepocessed image. 
%Output image resolution 18x32, 1-object, 0-background

picD=double(img_in);
picD=imresize(picD, size_out);
picG=2.*picD(:,:,2)-picD(:,:,1)-picD(:,:,3);

%mi=min(min(picG));
ma=max(max(picG));
qq=zeros(size(picG));
if(ma>100)
    tr=ma*0.5;
    qq(picG>tr)=1;
end
%picC=picG; picC(picC<100)=0;

img_out=qq;

end

