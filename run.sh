#!/bin/sh


#####################################################################################

clear
echo "###############################################################################"
echo "# The following script is to allow you to prepare a MSSP template             #"
echo "#                                                                             #"
echo "# You can upload the env.txt file to the 'XMLBuilder' folder or use the       #"
echo "# script to create a new env.txt file (option 7)                              #"
echo "#                                                                             #"
echo "#                                                                             #"
echo "#                                                                             #"
echo "###############################################################################"
echo " "
echo " "
echo " "

echo "###############################################################################"
echo "Enter the name of the customer for the backup"
echo "###############################################################################"
read name
	

while :
do
echo "###############################################################################"
echo "           Please select from the following options. "
echo "###############################################################################"
echo "           1.  Gold - XML only"
echo "           2.  Gold - ISO image"
echo "           3.  Silver - XML only"
echo "           4.  Silver - ISO image"
echo "           5.  Bronze - XML only"
echo "           6.  Bronze - ISO image"
echo "           7.  Create Env.txt"
echo "           8.  Change the customer"
echo "           9.  Set Esxi upload details"
echo "           10. Bootstrap base init.cfg only ISO (factory config)"
echo "           11. set the authcode for auto licencing if using the CSSP program"
echo "###############################################################################"
echo "Current customer is: $name "
echo ""
echo -n "           Please enter option [1 - 10] or x to exit :"
read opt

case $opt in

  1)
	source XMLBuilder/env.txt
	cd XMLBuilder
	export PATH=${PATH}:/usr/local/opt/gettext/bin
	envsubst < XML-Input-Files/MSSP-full-gold-input.xml > XML-configs/MSSP-full-gold.xml
	envsubst < XML-Input-Files/MSSP-partial-gold-input.xml > XML-configs/MSSP-partial-gold.xml
	envsubst < XML-Input-Files/MSSP-partial-base-input.xml > XML-configs/MSSP-partial-base.xml
	# create a local backup #
	cd ../Backups
	export backup=$name.backup.`date "+%Y%m%d-%H%M%S"`
	mkdir -p $backup
	cd $backup
	cp ../../XMLBuilder/env.txt ./
	cp ../../XMLBuilder/XML-configs/MSSP-full-gold.xml ./
	cp ../../XMLBuilder/XML-configs/MSSP-partial-gold.xml ./
	cp ../../XMLBuilder/XML-configs/MSSP-partial-base.xml ./


echo "###############################################################################"
echo "#                                                                             #"
echo "# output and backup stored in the Backups\\$backup folder"
echo "#                                                                             #"
ls 
echo "#                                                                             #"
echo "###############################################################################"
	cd ../../
echo ""
echo ""
echo ""
echo ""
	;;
	
	2)

	cd Build
	yes|rm -R *
	# copy the master image folder to the build directory #
	cp -R ../Master/*  ./
	# build the xml and init-cfg.txt files based on the variables #
	cd ..

	source XMLBuilder/env.txt
	cd XMLBuilder
	export PATH=${PATH}:/usr/local/opt/gettext/bin
	envsubst < XML-Input-Files/MSSP-full-gold-input.xml > XML-configs/MSSP-full-gold.xml
	
	echo "type=static" >Output/init-cfg.txt
	echo "ip-address=$MGMT_IP" >>Output/init-cfg.txt
	echo "default-gateway=$MGMT_DG" >>Output/init-cfg.txt
	echo "netmask=$MGMT_MASK" >>Output/init-cfg.txt
	echo "ipv6-address=2001:400:f00::1/64" >>Output/init-cfg.txt
	echo "ipv6-default-gateway=2001:400:f00::2" >>Output/init-cfg.txt
	echo "hostname=$FW_NAME" >>Output/init-cfg.txt
	# To enable Panorama uncomment the below 3 lines and set the values. #
	#echo "panorama-server=192.168.55.5" >>Output/init-cfg.txt
	#echo "tplname=VMSeries-template ">>Output/init-cfg.txt
	#echo "dgname=DeviceGroup1" >>Output/init-cfg.txt
	echo "dns-primary=$DNS_1" >>Output/init-cfg.txt
	echo "dns-secondary=$DNS_2" >>Output/init-cfg.txt
	echo "op-command-modes=multi-vsys,jumbo-frame" >>Output/init-cfg.txt
	echo "dhcp-send-hostname=no" >>Output/init-cfg.txt
	echo "dhcp-send-client-id=no" >>Output/init-cfg.txt
	echo "dhcp-accept-server-hostname=no" >>Output/init-cfg.txt
	echo "dhcp-accept-server-domain=no" >>Output/init-cfg.txt

	
	cp XML-configs/MSSP-full-gold.xml ../Build/config/bootstrap.xml
	cp Output/init-cfg.txt ../Build/config/init-cfg.txt
	cd ../Build/
	# build the ISO image #
	mkisofs -allow-lowercase -iso-level 4 -o  ../ISOImages/$name.iso ./
	# create a local backup #
	cd ../Backups
	export backup=$name.backup.`date "+%Y%m%d-%H%M%S"`
	mkdir -p $backup
	cd $backup
	cp ../../XMLBuilder/env.txt ./
	cp ../../XMLBuilder/Output/bootstrap.xml ./
	cp ../../XMLBuilder/Output/init-cfg.txt ./
	echo "###############################################################################"
echo "#                                                                             #"
echo "# output and backup stored in the Backups\\$backup folder                     #"
echo "#                                                                             #"
ls 
echo "#                                                                             #"
echo "###############################################################################"
	cd ../../
echo ""
echo ""
echo ""
echo ""	

	source XMLBuilder/VMserver.txt


	    echo "###############################################################################"
			echo "Do you wish to upload the image to the VMware ESXi datastore"
				echo "(y) Yes, (n) No."
				echo "###############################################################################"
				read confirm
				if [ $confirm == "y" ]; then
					# Copy the ISO image upto the datastore on the ESX server #
					runup="sshpass -p $ESX_pass scp ISOImages/$name.iso $ESX_name@$ESX_ip:$ESX_ds"
					$runup
					# recommend a clean up script to remove the old ISO images after a while as they contain any patches that are wanting to be deployed #
			   	fi

clear
  
	;;

	3)
	source XMLBuilder/env.txt
	cd XMLBuilder
	export PATH=${PATH}:/usr/local/opt/gettext/bin
	envsubst < XML-Input-Files/MSSP-full-silver-input.xml > XML-configs/MSSP-full-silver.xml
	envsubst < XML-Input-Files/MSSP-partial-silver-input.xml > XML-configs/MSSP-partial-silver.xml
	envsubst < XML-Input-Files/MSSP-partial-base-input.xml > XML-configs/MSSP-partial-base.xml
	# create a local backup #
	cd ../Backups
	export backup=$name.backup.`date "+%Y%m%d-%H%M%S"`
	mkdir -p $backup
	cd $backup
	cp ../../XMLBuilder/env.txt ./
	cp ../../XMLBuilder/XML-configs/MSSP-full-silver.xml ./
	cp ../../XMLBuilder/XML-configs/MSSP-partial-silver.xml ./
	cp ../../XMLBuilder/XML-configs/MSSP-partial-base.xml ./


echo "###############################################################################"
echo "#                                                                             #"
echo "# output and backup stored in the Backups\\$backup folder                     #"
echo "#                                                                             #"
ls 
echo "#                                                                             #"
echo "###############################################################################"
	cd ../../
echo ""
echo ""
echo ""
echo ""
	;;

	4)

	cd Build
	yes|rm -R *
	# copy the master image folder to the build directory #
	cp -R ../Master/*  ./
	# build the xml and init-cfg.txt files based on the variables #
	cd ..

	source XMLBuilder/env.txt
	cd XMLBuilder
	export PATH=${PATH}:/usr/local/opt/gettext/bin
	envsubst < XML-Input-Files/MSSP-full-silver-input.xml > XML-configs/MSSP-full-silver.xml
	
	echo "type=static" >Output/init-cfg.txt
	echo "ip-address=$MGMT_IP" >>Output/init-cfg.txt
	echo "default-gateway=$MGMT_DG" >>Output/init-cfg.txt
	echo "netmask=$MGMT_MASK" >>Output/init-cfg.txt
	echo "ipv6-address=2001:400:f00::1/64" >>Output/init-cfg.txt
	echo "ipv6-default-gateway=2001:400:f00::2" >>Output/init-cfg.txt
	echo "hostname=$FW_NAME" >>Output/init-cfg.txt
	# To enable Panorama uncomment the below 3 lines and set the values. #
	#echo "panorama-server=192.168.55.5" >>Output/init-cfg.txt
	#echo "tplname=VMSeries-template ">>Output/init-cfg.txt
	#echo "dgname=DeviceGroup1" >>Output/init-cfg.txt
	echo "dns-primary=$DNS_1" >>Output/init-cfg.txt
	echo "dns-secondary=$DNS_2" >>Output/init-cfg.txt
	echo "op-command-modes=multi-vsys,jumbo-frame" >>Output/init-cfg.txt
	echo "dhcp-send-hostname=no" >>Output/init-cfg.txt
	echo "dhcp-send-client-id=no" >>Output/init-cfg.txt
	echo "dhcp-accept-server-hostname=no" >>Output/init-cfg.txt
	echo "dhcp-accept-server-domain=no" >>Output/init-cfg.txt

	
	cp XML-configs/MSSP-full-silver.xml ../Build/config/bootstrap.xml
	cp Output/init-cfg.txt ../Build/config/init-cfg.txt
	cd ../Build/
	# build the ISO image #
	mkisofs -allow-lowercase -iso-level 4 -o  ../ISOImages/$name.iso ./
	# create a local backup #
	cd ../Backups
	export backup=$name.backup.`date "+%Y%m%d-%H%M%S"`
	mkdir -p $backup
	cd $backup
	cp ../../XMLBuilder/env.txt ./
	cp ../../XMLBuilder/Output/bootstrap.xml ./
	cp ../../XMLBuilder/Output/init-cfg.txt ./
	echo "###############################################################################"
echo "#                                                                             #"
echo "# output and backup stored in the Backups\\$backup folder                     #"
echo "#                                                                             #"
ls 
echo "#                                                                             #"
echo "###############################################################################"
	cd ../../
echo ""
echo ""
echo ""
echo ""	

	source XMLBuilder/VMserver.txt


	    echo "###############################################################################"
			echo "Do you wish to upload the image to the VMware ESXi datastore"
				echo "(y) Yes, (n) No."
				echo "###############################################################################"
				read confirm
				if [ $confirm == "y" ]; then
					# Copy the ISO image upto the datastore on the ESX server #
					runup="sshpass -p $ESX_pass scp ISOImages/$name.iso $ESX_name@$ESX_ip:$ESX_ds"
					$runup
					# recommend a clean up script to remove the old ISO images after a while as they contain any patches that are wanting to be deployed #
			   	fi

clear  
	;;
	
	
	
	5)
	source XMLBuilder/env.txt
	cd XMLBuilder
	export PATH=${PATH}:/usr/local/opt/gettext/bin
	envsubst < XML-Input-Files/MSSP-full-bronze-input.xml > XML-configs/MSSP-full-bronze.xml
	envsubst < XML-Input-Files/MSSP-partial-bronze-input.xml > XML-configs/MSSP-partial-bronze.xml
	envsubst < XML-Input-Files/MSSP-partial-base-input.xml > XML-configs/MSSP-partial-base.xml
	# create a local backup #
	cd ../Backups
	export backup=$name.backup.`date "+%Y%m%d-%H%M%S"`
	mkdir -p $backup
	cd $backup
	cp ../../XMLBuilder/env.txt ./
	cp ../../XMLBuilder/XML-configs/MSSP-full-bronze.xml ./
	cp ../../XMLBuilder/XML-configs/MSSP-partial-bronze.xml ./
	cp ../../XMLBuilder/XML-configs/MSSP-partial-base.xml ./


echo "###############################################################################"
echo "#                                                                             #"
echo "# output and backup stored in the Backups\\$backup folder                     #"
echo "#                                                                             #"
ls 
echo "#                                                                             #"
echo "###############################################################################"
	cd ../../
echo ""
echo ""
echo ""
echo ""
	;;
	
	
	6)

	cd Build
	yes|rm -R *
	# copy the master image folder to the build directory #
	cp -R ../Master/*  ./
	# build the xml and init-cfg.txt files based on the variables #
	cd ..

	source XMLBuilder/env.txt
	cd XMLBuilder
	export PATH=${PATH}:/usr/local/opt/gettext/bin
	envsubst < XML-Input-Files/MSSP-full-bronze-input.xml > XML-configs/MSSP-full-bronze.xml
	
	echo "type=static" >Output/init-cfg.txt
	echo "ip-address=$MGMT_IP" >>Output/init-cfg.txt
	echo "default-gateway=$MGMT_DG" >>Output/init-cfg.txt
	echo "netmask=$MGMT_MASK" >>Output/init-cfg.txt
	echo "ipv6-address=2001:400:f00::1/64" >>Output/init-cfg.txt
	echo "ipv6-default-gateway=2001:400:f00::2" >>Output/init-cfg.txt
	echo "hostname=$FW_NAME" >>Output/init-cfg.txt
	# To enable Panorama uncomment the below 3 lines and set the values. #
	#echo "panorama-server=192.168.55.5" >>Output/init-cfg.txt
	#echo "tplname=VMSeries-template ">>Output/init-cfg.txt
	#echo "dgname=DeviceGroup1" >>Output/init-cfg.txt
	echo "dns-primary=$DNS_1" >>Output/init-cfg.txt
	echo "dns-secondary=$DNS_2" >>Output/init-cfg.txt
	echo "op-command-modes=multi-vsys,jumbo-frame" >>Output/init-cfg.txt
	echo "dhcp-send-hostname=no" >>Output/init-cfg.txt
	echo "dhcp-send-client-id=no" >>Output/init-cfg.txt
	echo "dhcp-accept-server-hostname=no" >>Output/init-cfg.txt
	echo "dhcp-accept-server-domain=no" >>Output/init-cfg.txt

	
	cp XML-configs/MSSP-full-bronze.xml ../Build/config/bootstrap.xml
	cp Output/init-cfg.txt ../Build/config/init-cfg.txt
	cd ../Build/
	# build the ISO image #
	mkisofs -allow-lowercase -iso-level 4 -o  ../ISOImages/$name.iso ./
	# create a local backup #
	cd ../Backups
	export backup=$name.backup.`date "+%Y%m%d-%H%M%S"`
	mkdir -p $backup
	cd $backup
	cp ../../XMLBuilder/env.txt ./
	cp ../../XMLBuilder/Output/bootstrap.xml ./
	cp ../../XMLBuilder/Output/init-cfg.txt ./
	echo "###############################################################################"
echo "#                                                                             #"
echo "# output and backup stored in the Backups\\$backup folder                     #"
echo "#                                                                             #"
ls 
echo "#                                                                             #"
echo "###############################################################################"
	cd ../../
echo ""
echo ""
echo ""
echo ""	

	source XMLBuilder/VMserver.txt


	    echo "###############################################################################"
			echo "Do you wish to upload the image to the VMware ESXi datastore"
				echo "(y) Yes, (n) No."
				echo "###############################################################################"
				read confirm
				if [ $confirm == "y" ]; then
					# Copy the ISO image upto the datastore on the ESX server #
					runup="sshpass -p $ESX_pass scp ISOImages/$name.iso $ESX_name@$ESX_ip:$ESX_ds"
					$runup
					# recommend a clean up script to remove the old ISO images after a while as they contain any patches that are wanting to be deployed #
			   	fi

clear  
	;;
	
	7)
	clear
	source XMLBuilder/env.txt

	while :
	do

	echo "###############################################################################"
	echo "Manual creation of the env.txt file"
	echo "###############################################################################"
	echo "1. Version Tag            = $PANOS"
	echo "2. Template Tag           = $TEMPVER"
	echo "3. Firewall name          = $FW_NAME"
	echo "4. MSSP name              = $MSSP_NAME"
	echo ""
	echo "Device Settings: "
	echo "5. Management IP (IP/Mask/GW) = $MGMT_IP, $MGMT_MASK, $MGMT_DG"
	echo "6. DNS                    = $DNS_1 ,$DNS_2"
	echo "7. NTP                    = $NTP_1, $NTP_2"
	echo "8. Syslog                 = $MSSP_SYSLOG_1"
	echo "9. Sinkhole IP (IPv4/IPv6)= $SINKHOLE_IPV4 , $SINKHOLE_IPV6"
	echo ""
	echo "Network Settings: "
	echo "10. Trust network (name/IP/Mask)   = $ZONE_TRUST ,  $IP_11"
	echo "11. UnTrust network (name/IP/Mask) = $ZONE_UNTRUST ,  $IP_12, $ROUTING_DG"

	echo ""
	echo -n "           Please enter the line you want to edit [1 - 12] or s to save :"
	read opt2

	case $opt2 in
		1) 	echo "Enter the version of Code as a TAG :"
			echo "eg  PANOS-07.1"
			read PANOS
			clear	;;

		2)	echo "Enter the template version as a TAG :"
			echo "eg ver-1.1"
			read TEMPVER
			clear 	;;

		3) 	echo "Enter the Firewall name:"
			echo "eg VM-Host"
			read FW_NAME
			clear 	;;

		4) 	echo "Enter the MSSP service name:"
			echo "eg MSSP Company"
			read MSSP_NAME
			clear 	;;

		5)	echo "Enter the Management IP:"
			echo "eg 192.168.2.14"
			read MGMT_IP
			echo "Enter the Netmask:"
			echo "eg 255.255.255.0"
			read MGMT_MASK
			echo "Enter the Defualt Gateway"
			echo "eg 192.168.2.1"
			read MGMT_DG
			clear 	;;

		6) 	echo "Enter the Primary DNS IP:"
			echo "eg 8.8.8.8"
			read DNS_1
			echo "Enter the Secondary DNS IP:"
			echo "eg 8.8.4.4"
			read DNS_2
			clear 	;;
		7)	echo "Enter the Primary NTP Soucre name or IP:"
			echo "eg time.nist.gov"
			read NTP_1
			echo "Enter the Secondary NTP Soucre name or IP:"
			echo "eg time.nist.gov"
			read NTP_2
			clear 	;;
		8) 	echo "Enter the destination IP for all syslog forwarding:"
			echo "eg 192.168.2.5  "
			read MSSP_SYSLOG_1
			clear 	;;

		9) 	echo "Enter the IPv4 destination IP for sinkholinging if enabled:"
			echo "eg 192.168.2.5 or \"pan-sinkhole-default-ip\" "
			read SINKHOLE_IPV4
		 	echo "Enter the IPv6 destination IP for sinkholinging if enabled:"
			echo "eg ::1"
			read SINKHOLE_IPV6
			clear 	;;

		10)	echo "Enter name to be used on the Trust zone:"
			echo "eg L3-trust"
			read ZONE_TRUST
			
			echo "Enter the trust LAN side ip and mask:"
			echo "eg 192.168.34.1/24"
			read IP_11
			clear 	;;
	

		11)	echo "Enter name to be used on the Untrust zone:"
			echo "eg L3-untrust"
			read ZONE_UNTRUST
			
			echo "Enter the untrust LAN side ip and mask:"
			echo "eg 192.168.34.1/24"
			read IP_12

			echo "Enter the ip of the Default GW:"
			echo "eg 192.168.34.254"
			read ROUTING_DG
			clear 	;;
		
		s)
		echo "#Palo Alto Networks Variables "> XMLBuilder/env.txt
		echo "#Scott Shoaf & Toby Makepeace ">> XMLBuilder/env.txt
		echo "export PANOS=$PANOS">> XMLBuilder/env.txt
		echo "export TEMPVER=$TEMPVER">> XMLBuilder/env.txt
		echo "export FW_NAME=$FW_NAME">> XMLBuilder/env.txt
		echo "export MGMT_IP=$MGMT_IP">> XMLBuilder/env.txt
		echo "export MGMT_MASK=$MGMT_IP">> XMLBuilder/env.txt
		echo "export MGMT_DG=$MGMT_DG">> XMLBuilder/env.txt
		echo "export MSSP_NAME=$MSSP_NAME">> XMLBuilder/env.txt
		echo "export DNS_1=$DNS_1">> XMLBuilder/env.txt
		echo "export DNS_2=$DNS_2">> XMLBuilder/env.txt
		echo "export NTP_1=$NTP_1">> XMLBuilder/env.txt
		echo "export NTP_2=$NTP_2">> XMLBuilder/env.txt
		echo "export MSSP_SYSLOG_1=$MSSP_SYSLOG_1">> XMLBuilder/env.txt
		echo "export IP_11=$IP_11">> XMLBuilder/env.txt
		echo "export IP_12=$IP_12">> XMLBuilder/env.txt
		echo "export ZONE_TRUST=$ZONE_TRUST">> XMLBuilder/env.txt
		echo "export ZONE_UNTRUST=$ZONE_UNTRUST">> XMLBuilder/env.txt
		echo "export ROUTING_DG=$ROUTING_DG">> XMLBuilder/env.txt	
		echo "export SINKHOLE_IPV4=pan-sinkhole-default-ip ">> XMLBuilder/env.txt
		echo "export SINKHOLE_IPV6=::1">> XMLBuilder/env.txt
		echo "export MSSP_LOGGING=MSSP-logging">> XMLBuilder/env.txt

		clear
		break 1
		
	esac
	done
	;;


	8)
	echo "###############################################################################"
	echo "Enter the next name of the customer"
	echo "###############################################################################"
	read name
clear	
	;;
	
	9)
	echo "###############################################################################"
	echo "Set Esxi upload details"
	echo "###############################################################################"
	echo "Enter the IP of the ESXi server datastore :"
	read Esx_ip
	echo "Enter the username to be used to upload:"
	read Esx_user
	echo "Enter the password to be used to upload:"
	read Esx_pass
	echo "Enter the full path for the files to be uploaded to :"
	echo "eg. /vmfs/volumes/581b378d-eda49d3a-ac60-1c98ec0e8204/BootstrapTest/"
	read Esx_ds

	echo "#Palo Alto Networks Variables "> XMLBuilder/VMserver.txt
	echo "#Scott Shoaf & Toby Makepeace ">> XMLBuilder/VMserver.txt
	echo "export ESX_user=$Esx_user" >> XMLBuilder/VMserver.txt
	echo "export ESX_pass=$Esx_pass" >> XMLBuilder/VMserver.txt
	echo "export ESX_ip=$Esx_ip" >> XMLBuilder/VMserver.txt
	echo "export ESX_ds=$Esx_ds" >> XMLBuilder/VMserver.txt
clear
	;;


	10)
	
	cd Build
	yes|rm -R *
	# copy the master image folder to the build directory #
	cp -R ../Master/*  ./
	# build the xml and init-cfg.txt files based on the variables #
	cd ..

	source XMLBuilder/env.txt
	cd XMLBuilder
	
	echo "type=static" >Output/init-cfg.txt
	echo "ip-address=$MGMT_IP" >>Output/init-cfg.txt
	echo "default-gateway=$MGMT_DG" >>Output/init-cfg.txt
	echo "netmask=$MGMT_MASK" >>Output/init-cfg.txt
	echo "ipv6-address=2001:400:f00::1/64" >>Output/init-cfg.txt
	echo "ipv6-default-gateway=2001:400:f00::2" >>Output/init-cfg.txt
	echo "hostname=$FW_NAME" >>Output/init-cfg.txt
	
	echo "###############################################################################"
	echo "Include Panorama setting"
	echo "(y) Yes, (n) No"
	echo "###############################################################################"										
	read Enable
	if [ $Enable == "y" ]; then
		echo "###############################################################################"
		echo "Enter the IP of the Panorama server:"
		read PanS
		echo "Enter the name of the Panorama Template to be loaded:"
		read PanTem
		echo "Enter the name of the device group where the firewall to be deployed:"
		read PanDG
	
		# To enable Panorama uncomment the below 3 lines and set the values. #
		echo "panorama-server=$PanS" >>Output/init-cfg.txt
		echo "tplname=$PanTem ">>Output/init-cfg.txt
		echo "dgname=$PanDG" >>Output/init-cfg.txt
	fi
	

	echo "dns-primary=$DNS_1" >>Output/init-cfg.txt
	echo "dns-secondary=$DNS_2" >>Output/init-cfg.txt
	echo "op-command-modes=multi-vsys,jumbo-frame" >>Output/init-cfg.txt
	echo "dhcp-send-hostname=no" >>Output/init-cfg.txt
	echo "dhcp-send-client-id=no" >>Output/init-cfg.txt
	echo "dhcp-accept-server-hostname=no" >>Output/init-cfg.txt
	echo "dhcp-accept-server-domain=no" >>Output/init-cfg.txt

	
	cp Output/init-cfg.txt ../Build/config/init-cfg.txt
	cd ../Build/
	# build the ISO image #
	mkisofs -allow-lowercase -iso-level 4 -o  ../ISOImages/$name.iso ./
	# create a local backup #
	cd ../Backups
	export backup=$name.backup.`date "+%Y%m%d-%H%M%S"`
	mkdir -p $backup
	cd $backup
	cp ../../XMLBuilder/env.txt ./
	cp ../../XMLBuilder/Output/init-cfg.txt ./
	echo "###############################################################################"
echo "#                                                                             #"
echo "# output and backup stored in the Backups\\$backup folder                     #"
echo "#                                                                             #"
ls 
echo "#                                                                             #"
echo "###############################################################################"
	cd ../../
echo ""
echo ""
echo ""
echo ""	

	source XMLBuilder/VMserver.txt


	    echo "###############################################################################"
			echo "Do you wish to upload the image to the VMware ESXi datastore"
				echo "(y) Yes, (n) No."
				echo "###############################################################################"
				read confirm
				if [ $confirm == "y" ]; then
					# Copy the ISO image upto the datastore on the ESX server #
					runup="sshpass -p $ESX_pass scp ISOImages/$name.iso $ESX_user@$ESX_ip:$ESX_ds"
	echo				$runup
$runup
					# recommend a clean up script to remove the old ISO images after a while as they contain any patches that are wanting to be deployed #
			   	fi
clear
  
	;;

	11)
	
file="Master/license/authcodes"
	if [ -f "$file" ]
	then
		authcodes=`cat $file`
		echo "###############################################################################"
		echo "Current Authcode is $authcodes"
		echo "###############################################################################"
		echo "Do you wish to update the authcode"
		echo "(y) Yes, (n) No."
		echo "###############################################################################"
		read confirm
		if [ $confirm == "y" ]; then
			echo "Enter the new authcode"
			echo "###############################################################################"
			read authcode
			echo $authcode > $file
		fi 
	else
		echo "###############################################################################"
		echo "There is no current authcodes file"
		echo "###############################################################################"
		echo "Do you wish create a authcodes"
		echo "(y) Yes, (n) No."
		echo "###############################################################################"
		read confirm
		if [ $confirm == "y" ]; then
			echo "Enter the new authcode"
			echo "###############################################################################"
			read authcode
			echo $authcode > $file
		fi 
		echo "no Authcodes file."
	fi
clear
	;;
	


  x) 
			echo "###############################################################################"
			echo "Thanks, Please report any issues with the tool to tmakepeace@paloaltonetworks.com"
			echo "or sshoaf@paloaltonetworks.com"
			echo "The tools is to demonstrate the simplicy of deployment of the template model "
			echo "is can easily be adjusted to any template model the customer uses "
			echo "should you discover a issue, please raise with tmakepeace@paloaltonetworks.com "
			echo "or sshoaf@paloaltonetworks.com who will endeveor to assist."
			echo "###############################################################################"
			echo "Bye $USER";

	exit 1;;

  *) echo "$opt is an invaild option. Please select option between 1-6 only";

     echo "Press [enter] key to continue. . .";

     read enterKey;;

esac

done

