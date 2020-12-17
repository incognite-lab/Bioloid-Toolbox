function [ s ] = setBTPort( )
% nastavi COM port pro komunikaci s Robotis Bioloid (CM530) pres bluetooth
% musi byt nastevno COM1, zmenit cislo portu lze ve spravci zarizeni

s=serial('COM1','BaudRate',57600,'DataBits',8,...
'Parity','none','StopBits',1,'InputBufferSize', 1024);
end

