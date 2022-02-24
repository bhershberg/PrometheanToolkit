****************************************************
* USB_NOC interface v1.1 ***************************
****************************************************

Hi,

You came across this document because you probably want to use the UCB_NOC
interface in your measurements. IMPORTANT! A list of known problems is at the end of this file!
Here is how to use the board and the drivers:

1. Connect the USB_NOC interface board to your computer
2. Check that the device appeared as being ready to use, otherwise:
  2b. install drivers for the ftdi board. You can find them on FTDI website or just ask Lab responsible. It is also possible
      that the drivers are in subfolder "CDM 2.08.24 WHQL Certified", just plug the device to usb port and point windows to this location.
3. Copy (or extract) he directory "USB_NOC" to your project site.
4. From MATLAB add this directory to path (addpath('./USB_NOC') or similar)
    WARNING! The difference in scripts for the USB_NOC board and the NI-6221 (white) box are 
	made based on the execution path! So if you want to use the NI-6221 box, remove the
	directory containing USB_NOC drivers from the path!

** IMPORTANT! **
5. Check voltages! To do that, put a multimeter to the header (two holes if not installed) in the middle of the
 board. It is the voltage  that will become your I/O levels voltage. Adjust using the onboard potentiometer.
** /IMPORTANT! **

6. You can check if the board reacts to commands by running the 'kitt' demo :)

7. Connect the board to the chip carrier board.
8. Program as usual: eg. NoCCtrl('RF1_Gain',10);
9. Notice that the RST line should stay high (LED burning on the interface board).
10. If you want to use direct control of the pins of the board, you can use the 'usb_noc.m' function.
  It accepts a vector of decimals, where each decimal value is a state of the bus.
	** IMPORTANT **
	In the current revision of the board the order of pins on the header does not follow the order of data lines.
	Here is the pinout of the board:
	DATA line:    HEADER pin (left/right)  
	             -------------
	D0           | 1       2 |     GND
	D3           | 3       4 |     GND
	D2           | 5       6 |     GND
	D6           | 7       8 |     GND
	D5           | 9      10 |     GND
	D7           | 11     12 |     GND
	D1           | 13     14 |     GND
	D4           | 15     16 |     GND
	D2           | 17     18 |     GND
	NC           | 19     20 |     GND
	             -------------
				 

For more information go to http://imecwww.imec.be/~raczko/?page_id=226
				 
Kuba Raczkowski @imec 2012


KNOWN ISSUES
1. If the drivers are located on a unix shared folder (like \\unix\somethingsomething) and you get an error about 'Permission denied', please copy the drivers to a local drive. It happens on some computers only and is difficult to track what's actually happening.


