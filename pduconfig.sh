#!/bin/bash
#variables
HOST="pduips.txt"
CONFIG="bulk_config_cleartext.txt"

#check if pduip file exists
if [ ! -f $HOST ]; then
	echo "PDU IP file $HOST not found!"
	exit 1
fi

#check if config file exists
if [ ! -f $CONFIG ]; then
	echo "Config file $CONFIG not found"
	exit 1
fi

#asks for password and verifies they match, used for sshpass later
get_input() {
        local input1 input2
        while true; do
                read -sp "Enter your password: " input1
                read -sp "Re-enter your password: " input2
                if [ "$input1" == "$input2" ]; then
                        break
                else
                        echo "Passwords do not match, try again"
                fi
        done
        echo "$input1"
}
PASS="$(get_input)"

#upload loop
echo "Starting upload process..."
sleep 0.5
while IFS= read -r ip || [[ -n "$ip" ]]; do
	echo "Attempting to upload to $ip"
	#we use sshpass to avoid having to upload ssh keys every pdu first
	sshpass -p "$PASS" scp -o StrictHostKeyChecking=no "$CONFIG" "admin@${ip}:/bulk_restore" &
	#progress spinner
	pid=$!
	spin='-\|/-'
	i=0
	while kill -0 $pid 2>/dev/null; do
		i=$(( (i+1) % 4 ))
		printf "\r${spin:$i:1}"
		sleep .1
	done
	wait $pid
	#checks if upload finished
	if [ $? -eq 0 ]; then
		echo -e "\rUpload to $ip completed."
	else
		echo -e "\rUpload to $ip failed."
	fi
done < "$HOST"
echo "Upload process complete"
