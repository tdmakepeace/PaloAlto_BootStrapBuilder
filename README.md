# PaloAlto_BootStrapBuilder

The following has been built to demo how to use the Bootstraping process for the Palo Alto Networks NGFW.

After deploying the image, check the permission on the following files.
#following permissions should be checked.

chmod 744 XMLBuilder/env.txt
chmod 744 XMLBuilder/VMserver.txt
chmod 744 run.sh


# the tool is designed to demonstrate the simplicity or reusing a template model to speed up the deployment.
# a few things like the deployment of the ISO images to the ESXi server are never expected to be deployed in 
# live. but highlight the fact the bootstrapping process can be used to speed up the deployments.
# the ISO images will work with VM or hardware.

# if you aim to use panorama to configure the servers. Option 10 is to build the bootstrap file to get the 
# device on the network, and connect to the Panorama server.
# you still need to configure the panorama server to accept the connection and deploy a configuration.

## Notes on how to adjust ##
The XMLBuilder folder is where the env.txt file is to be uploaded to to build a config.
A sub folder of the XMLBuilder is the XML-Input-Files. This is where you would upload your own templates to be 
used.

You would need to make sure you edit the XML to contain the variable that would be reconfigured dynamically by 
the script.


The Build folder is a temp location to do the building of the ISO from.
The Backups is as is, and the sub folder is based on the company-name (provided as the time of running)
and the date. In the backup is the env.txt,bootstrap.xml, init-cfg.txt, config.xml. so it could all be 
re-run again, or dropped manually on a new ISO image.

The Master folder, is where the ISO structure is taken from, so if you want to include updates to the 
package and updates to the contents this is where you would do it.
