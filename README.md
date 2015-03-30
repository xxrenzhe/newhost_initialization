# newhost_initialization
Function : initial new host  
Author : Jason.Yu  
CTime : 2015-03-31  


Before Initialization
==================
ansible-play --ask-pass before_initialization.yml  
Notice:you must input ssh password


Generate random passwords list
=================
cd gen_random_pass  
sh gen_random_pass.sh


Initialization
==================
sh initial_random_password.sh
