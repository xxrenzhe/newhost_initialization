#!/bin/bash
# Function : Genarate random password to initialize a new host
# Author : Jason.Yu
# CTime : 2015-03-30

# Ensure ansible installed
yum -y install ansible

# Generate random password
while read line
do
macaddress=`ansible $line -m setup -a 'filter=ansible_default_ipv4' |grep macaddress | awk -F'"' '{print $4}'`
num1_root=`echo $macaddress | sha256sum |head -c 32|tr -d '[a-z]'|tr -d '0'|head -c 10`
num1_wenba=`echo $macaddress | sha256sum |head -c 32|tr -d '[a-z]'|tr -d '0'|head -c 09`
total_line=`wc -l gen_random_pass/random_pass.txt |awk '{print $1}'`
args_root=$((num1_root%total_line+1))
args_wenba=$((num1_wenba%total_line+1))

if [ $((args_root%2)) -eq 0 ]
then
	if [ $((args_wenba%2)) -eq 0 ]
	then
		password_encrypt_root=`head -$args_root gen_random_pass/random_pass.txt|tail -1`
		password_root=`head -$((args_root-1)) gen_random_pass/random_pass.txt|tail -1`
		echo $line >> gen_random_pass/pass_list_root.txt
		echo $password_root >> gen_random_pass/pass_list_root.txt
		echo $password_encrypt_root >> gen_random_pass/pass_list_root.txt

		password_encrypt_wenba=`head -$args_wenba gen_random_pass/random_pass.txt|tail -1`
		password_wenba=`head -$((args_wenba-1)) gen_random_pass/random_pass.txt|tail -1`
		echo $line >> gen_random_pass/pass_list_wenba.txt
		echo $password_wenba >> gen_random_pass/pass_list_wenba.txt
		echo $password_encrypt_wenba >> gen_random_pass/pass_list_wenba.txt
	else
		password_encrypt_root=`head -$args_root gen_random_pass/random_pass.txt|tail -1`
		password_root=`head -$((args_root-1)) gen_random_pass/random_pass.txt|tail -1`
		echo $line >> gen_random_pass/pass_list_root.txt
		echo $password_root >> gen_random_pass/pass_list_root.txt
		echo $password_encrypt_root >> gen_random_pass/pass_list_root.txt

		password_encrypt_wenba=`head -$((args_wenba+1)) gen_random_pass/random_pass.txt|tail -1`
		password_wenba=`head -$args_wenba gen_random_pass/random_pass.txt|tail -1`
		echo $line >> gen_random_pass/pass_list_wenba.txt
		echo $password_wenba >> gen_random_pass/pass_list_wenba.txt
		echo $password_encrypt_wenba >> gen_random_pass/pass_list_wenba.txt
	fi
else
	if [ $((args_wenba%2)) -eq 0 ]
	then
		password_encrypt_root=`head -$((args_root+1)) gen_random_pass/random_pass.txt|tail -1`
		password_root=`head -$args_root gen_random_pass/random_pass.txt|tail -1`
		echo $line >> gen_random_pass/pass_list_root.txt
		echo $password_root >> gen_random_pass/pass_list_root.txt
		echo $password_encrypt_root >> gen_random_pass/pass_list_root.txt

		password_encrypt_wenba=`head -$args_wenba gen_random_pass/random_pass.txt|tail -1`
		password_wenba=`head -$((args_wenba-1)) gen_random_pass/random_pass.txt|tail -1`
		echo $line >> gen_random_pass/pass_list_wenba.txt
		echo $password_wenba >> gen_random_pass/pass_list_wenba.txt
		echo $password_encrypt_wenba >> gen_random_pass/pass_list_wenba.txt
	else
		password_encrypt_root=`head -$((args_root+1)) gen_random_pass/random_pass.txt|tail -1`
		password_root=`head -$args_root gen_random_pass/random_pass.txt|tail -1`
		echo $line >> gen_random_pass/pass_list_root.txt
		echo $password_root >> gen_random_pass/pass_list_root.txt
		echo $password_encrypt_root >> gen_random_pass/pass_list_root.txt

		password_encrypt_wenba=`head -$((args_wenba+1)) gen_random_pass/random_pass.txt|tail -1`
		password_wenba=`head -$args_wenba gen_random_pass/random_pass.txt|tail -1`
		echo $line >> gen_random_pass/pass_list_wenba.txt
		echo $password_wenba >> gen_random_pass/pass_list_wenba.txt
		echo $password_encrypt_wenba >> gen_random_pass/pass_list_wenba.txt
	fi

fi

	# Deploy initialization by ansible
	sed -i "s@ffm_root_password:\(.*\)@ffm_root_password: \'$password_encrypt_root\'@" /etc/ansible/roles/initialization/defaults/main.yml 
	sed -i "s@ffm_deployuser_password:\(.*\)@ffm_deployuser_password: \'$password_encrypt_wenba\'@" /etc/ansible/roles/initialization/defaults/main.yml 
	sed -i "s@hosts.*@hosts: $line@" /etc/ansible/initialization.yml
	ansible-playbook /etc/ansible/initialization.yml

done < hosts.txt
