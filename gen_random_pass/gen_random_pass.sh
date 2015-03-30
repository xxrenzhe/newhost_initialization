#!/bin/bash
# Function : Creates crypted password 
# CTime : 2014.08.25
# Author : Jason.Yu
#

: > random.txt
: > random_pass.txt

count=1000
for i in `seq 1 $count`
do
	echo `strings /dev/urandom | grep -o [[:alnum:]] | head -n 32 | tr -d "\n"` >> random.txt
done

sleep 2

while read line
do 
	echo -e $line >> random_pass.txt
	python -c "import crypt, getpass, random, string;print crypt.crypt('$line', '\$6\$%s\$' % \"\".join(random.sample(string.letters+string.digits, 8)))" | tee -a random_pass.txt

done < random.txt
