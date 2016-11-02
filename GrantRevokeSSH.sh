#!/bin/bash
#1= userName
#2= privilege (grant/revoke)

if  [ "$2" = "grant" ];
then 
	if grep -Pq "^AllowUsers.* $1( |$)" /etc/ssh/sshd_config;
	then
		#User is already included in  Allowed Users so don't add again
		echo ERROR: User Already Has Permissions

	elif grep -Pq "^AllowUsers " /etc/ssh/sshd_config; 
	
	then
		#Finds line starting with AllowUsers and appends username to it
		awk -v var=$1 '{if (/AllowUsers /) {$0=$0 " "'var'}; print}' /etc/ssh/sshd_config>/etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config
		sudo restart ssh
	else
		#IF AllowUsers is not found in sshd_config append AllowUsers username to sshd_config
		echo AllowUsers $1>>/etc/ssh/sshd_config
		sudo restart ssh
		
	fi
elif [ "$2" = "revoke" ]; 
then
	if grep -Pq "^AllowUsers.* $1( |$)" /etc/ssh/sshd_config;
	then
		sed -i "/^AllowUsers/ s/ $1//" /etc/ssh/sshd_config
		sudo restart ssh
	else
		#user not found in list of AllowedUsers 
		echo ERROR: User Does Not Have Permissions
	fi
else
	echo ERROR: Invalid Argument
fi
