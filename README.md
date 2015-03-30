# newhost_initialization
Function : initial new host  
Author : Jason.Yu  
CTime : 2015-03-31  


Before Initialization
==================
ansible-play --ask-pass before_initialization.yml  
Notice : You must input ssh password (refer to user root,generally)


Generate random passwords list
=================
cd gen_random_pass  
sh gen_random_pass.sh


Initialization New Host
==================
sh initial_random_password.sh
