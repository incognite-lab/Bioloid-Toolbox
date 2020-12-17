# Bioloid Toolbox

The Matlab toolbox that allows to fully control Bioloid Premium robot.
Toolbox for communication between Robotis Bioloid, CM530 and Matlab that allows to fully control all the robot sensors and efectors. 

## Example

 The code is in the robotic visuomotor coordination is in the VMC folder. The video shows the Bioloid robot equipped with the Havimo 2.0 camera looking at the computer screen. There are several objects presented (left part of the screen), robot captures these images and sent them to Matlab (upper right window shows the actual view). The unsupervised algorithm (SOM) learns to clusterize these objects and there is also motor response in the testing stage (hand in several positions) that allows to visualize error rate. The SOM is presented at the right bottom of the monitor.
 
 [![Video1](https://img.youtube.com/vi/TLYiwIx8c28/maxresdefault.jpg)](https://youtu.be/TLYiwIx8c28)
 
 [![Video1](https://img.youtube.com/vi/xhiK3uCGrTE/maxresdefault.jpg)](https://youtu.be/xhiK3uCGrTE)


## How to install custom firmware

1. Connect your controller to a computer by an USB cable and turn on the controller.

2. Open RoboPlus Terminal and make sure it is connected to the controller. You should see „Connected“ in the right bottom corner. If it is not connected select Connect in Setup menu and then select appropriate serial port and set communication speed to 57600bps.

3. a) Enter into the bootloader. While pressing the „#“ button turn on the controller (or press down the reset switch).
   b) Press Enter.
   c) Input „L“ command (erasing will start).
   d) In the Files menu select Transmit Files. Navigate to the custom firmware binary file and click send (transmission will start).
   e) Once the firmware is loaded in the controller, you can start it by command „go“ or by restarting the controller.

4. Turn off the Terminal, it is not needed anymore.



Full version guide on installing custom firmware is available on Robotis web site:
http://support.robotis.com/en/software/embeded_c/cm530/programming/bootloader/program_install_cm530.htm

How to restore default firmware is also described on Robotis web site:
http://support.robotis.com/en/software/roboplus/roboplus_manager/firmwaremanagement/roboplus_manager_fwrecovery.htm
