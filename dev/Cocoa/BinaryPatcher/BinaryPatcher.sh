#!/bin/bash           
E_NO_ARGS=65   

echo "::::::::::::::::::::::::::::::::::::"  
echo " SWF Screensaver for Mac Binary Patcher"  
echo "::::::::::::::::::::::::::::::::::::" 
echo ""
echo "Please define an individual name with 18 characters:"              
read -e NEWNAME
 
typeset -i var02=$(echo ${#NEWNAME})
if [[ var02 -eq 18 ]] ;  # Must have command-line args to demo script.
then                                             
  cp source-binary-0.9.3 ./"SWF Screensaver for Mac"
  perl -pi -e 's/SWFScreensaverView/'$1'/g' ./"SWF Screensaver for Mac"    
  echo ""
  echo "ScreenSaver binary has been patched!"  
  echo "The new file has been created. It's called: SWF Screensaver for Mac. "
  echo "Please copy it to the /Contents/MacOS folder of your screensaver and replace the existing file"
  echo ""
else
	echo "Sorry, your name was too short/long ($var02). It has to have 18 characters." 
	exit $E_NO_ARGS                    
fi

    
