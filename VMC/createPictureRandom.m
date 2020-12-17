function [ img ] = createPictureRandom(obj_size)
%Returns picture with the object in it

size_x=720;
size_y=1280;

x=randi(size_x-obj_size(1),1);
y=randi(size_y-obj_size(2),1);

canvas=ones(size_x,size_y,3).*255;
obj=zeros(obj_size(1),obj_size(2),3);
obj(:,:,2)=255;

try
    canvas(x:x+obj_size(1)-1, y:y+obj_size(2)-1,:)=obj;
catch e
    disp(e);
end
img=canvas;

end