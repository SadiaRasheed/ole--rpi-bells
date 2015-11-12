#!/bin/bash

# default settings
#update=true
repository='ole--rpi-bells'
user='SadiaRasheed'
directory='qa'
network=''
password=''
script='2nations-autorunonce.sh'

function pass {
passwd pi << EOF
$1
$1
EOF
}

# load local settings from qa.config file
if [[ -r ./qa.config ]] ; then
    source ./qa.config
fi

if [[ ! -e /boot/autorun.sh ]] ; then
  # set password
  if [[ $password != "" ]] ; then
    pass $password
  fi

  # set network
  if [[ $network != "" ]] ; then
    $network
    sleep 15
  fi
  
  # repository
  if [[ ! -d $repository ]] ; then
    git clone 'https://github.com/'$user'/'$repository'.git'
    cd $repository
  else
    cd $repository
    git pull
  fi
  sync
  
  # newer autorun.sh?
  if ! diff $directory/autorun.sh ../autorun.sh ; then
    cp $directory/autorun.sh ../autorun.sh
  fi
  
  # wget qa content
  cd ..
  wget -c -r -l 1 -nc -np -A "*.couch" -e robots=off http://download.ole.org/.qa/.content/
  
  
  # start script
  $repository/$directory/$script
fi
/boot/autorun.sh
