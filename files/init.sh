#!/usr/bin/env bash

SSH_KEYS=$(printenv| awk -F= '$1 ~ /SSH_KEY/ {print $1}' )
SSH_HOST_KEYS=$(ls /etc/ssh/ | grep ssh_host | wc -l)

if [[ $SSH_KEYS ]]; then
	# Check if host keys have been generated,
	# if not generate them.
	if [[ SSH_HOST_KEYS -eq 0 ]]; then
		echo "SSH Keys not found: generating"
		dpkg-reconfigure openssh-server
	fi

	if [[ ! -d /home/prx/.ssh ]]; then
		mkdir /home/prx/.ssh
	fi

	if [[ -f  /home/prx/.ssh/authorized_keys ]]; then
		rm /home/prx/.ssh/authorized_keys
	fi

	truncate -s 0 /home/prx/.ssh/authorized_keys
	for i in $SSH_KEYS; do printenv $i >> /home/prx/.ssh/authorized_keys; done

	chown -R prx /home/prx/.ssh
	chgrp -R prx /home/prx/.ssh

	/usr/sbin/sshd -D
else
	echo "You need to specify your ssh key(s) as environment variable(s): SSH_KEY*"
	exit 1
fi

