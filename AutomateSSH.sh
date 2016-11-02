#!/bin/bash
#Get name of user to grant/revoke
echo "Enter Username:"
read user
#Enter Desired action
echo "Enter grant or revoke:"
read permission

#loop through servers, ssh into them and then run script.
for host in $(cat servers.txt); do ssh "$host" "bash -s" < ./GrantRevokeSSH.sh "$user" "$permission"; done
