# PS-ServerAuto-Scripts
Homemade scripts in order to set CS labs over Win 2012 R2, however this has been tested on WS2016 and on WS2019 (whose have PS 4.0.30319, 5.1.14393 and 5.1.17763 versions)  

Monolithic app.

+++++++++++++++++++++++++++++++++++++++++++
++
+     Comment edited on 11/08/2019 (US Date)
+
+     Version : 1.2.1
++
++++++++++++++++++++++++++++++++++++++++++

Launch "First Step.ps1" and be sure that all the other files are in the same directory

The Order of Execution :
1) First_Step.ps1 (which will launch everything needed)
2) Server_Setup.ps1
3) Domain_Merger.ps1
4) Role_Installation.ps1

Your server will reboot on the end of Server Setup and Domain Merger.

If you are not located in "your drive\Scripting\" don't worry, the script is meant to copy the files into the right path.
However be aware that the script won't launch if all the files does not have the exact name (located both on First Step as an array of file names and on scheduled tasks on SRV Setup and Domain Merger).

File names are now without space to fix some preventable issues.

Next step : create a "CMD" environment variable called Scripting in order to have the ```%SCRIPTING%``` path instead of ```%HOMEDRIVE%\Scripting```
