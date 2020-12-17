function [ s ] = setSerialPort( varargin )
% Function sets serial port for communication with Robotis Bioloid (CM530)
% Example for Windows: s = setSerialPort(4)
% Example for Linux: s = setSerialPort('linux','/dev/ttyS0')
% automatically recognizes serial port names are /dev/ttyS[0-255]
%
% (execute function fopen(s) to open the created communication port)

if(length(varargin)==2)
    
   if(strcmpi(varargin{1},'linux'))
       com=varargin{2};
   else
       error('Unknown parameter in function setSerialPort')
   end
   
else
    com=['COM',num2str(varargin{1})];
end

s=serial(com,'BaudRate',115200,'DataBits',8,...
    'Parity','none','StopBits',1,'InputBufferSize', 1024);
end

