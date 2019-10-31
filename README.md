# PS-ServerAuto-Scripts
Homemade scripts in order to set CS labs over Win 2012 R2

Monolithic app.

+++++++++++++++++++++++++++++++++++++++++++
++
+     Comment added/edited on 31th of October
+     Happy spooktober (no I'm kdding I hate spooktober memes in Reddit) 
+     Version : 1.2
++
++++++++++++++++++++++++++++++++++++++++++

Launch "First Step.ps1" and be sure that all the other files are in the same directory

The Order of Execution :
1) First Step.ps1 (which will launch everything needed)
2) SRV Setup.ps1
3) Domain Merger.ps1
4) Role Installation.ps1

Your server will reboot on the end of SRV Setup and Domain Merger.

If you are not located in "your drive\Scripting\" don't worry, the script is meant to copy the files into the right path.
However be aware that the script won't launch if all the files does not have the exact name (located both on First Step as an array of file names and on scheduled tasks on SRV Setup and Domain Merger).
