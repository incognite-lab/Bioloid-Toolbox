function [ img, label, position ] = createPicture(obj_size, division, rotate, select )
%Create picture with the object in it.

size_x=720;
size_y=1280;
canvas=ones(size_x,size_y,3).*255;
obj=zeros(obj_size(1),obj_size(2),3);
obj(:,:,2)=255;
if (rotate>0)
    obj_r=imrotate(obj,randi(181)-1);
else
    obj_r=obj;
end
obj_size=size(obj_r); obj_size(3)=[];
[ pos cell ] = generatePosition( division, obj_size, select );
x=pos(1);
y=pos(2);
for i=1:obj_size(1)
    for j=1:obj_size(2)
        if(obj_r(i,j,1)==0 && obj_r(i,j,2)==0 && obj_r(i,j,3)==0)
            obj_r(i,j,:)=[255 255 255];
        end
    end
end

try
    canvas(x:x+obj_size(1)-1, y:y+obj_size(2)-1,:)=obj_r;
catch e
    disp(e);
end
img=canvas;
position=cell;
label=[num2str(cell(1)), num2str(cell(2))];

end

function [ pos label ] = generatePosition( division, obj_size, select )

size=[720, 1280];
part_size=(size-obj_size-1)./(division-[1 1]);
if select>0
    select=select-1;
    pos=[mod(select,division(1))+1, floor(select/division(1))+1];
    pos=pos-1;
else
    pos=[randi(division(1))-1, randi(division(2))-1];
end
label=pos+1;

offset=[0 0];
pos=pos.*part_size+[1 1]+offset;
pos=floor(pos);

end


