#!/bin/bash
RF24GIT=https://github.com/tmrh20
ALTGIT=https://github.com/ludiazv

RF24_VERSION="v1.3.2"
RF24N_VERSION="v1.0.9"
RF24M_VERSION="v1.0.6"
RF24G_VERSION="TODO"

#Libraries are allways rebuild as they require FAILURE_HANDLING enabled to operate
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed. git is required for installation of the module' >&2
  exit 1
fi
if ! [ -x "$(command -v sed)" ]; then
  echo 'Error: sed is not installed. sed is required for installation of the module' >&2
  exit 1
fi
if ! [ -x "$(command -v make)" ]; then
  echo 'Error: make is not installed. build-essential pkg is required for installation of the module' >&2
  exit 1
fi
if ! [ -x "$(command -v gcc)" ]; then
  echo 'Error: gcc is not installed. build-essential pkg is required for installation of the module' >&2
  exit 1
fi
if ! [ -x "$(command -v g++)" ]; then
  echo 'Error: g++ is not installed. build-essential pkg is required for installation of the module' >&2
  exit 1
fi

#echo "Check if RF24libs are installed..."
#ldconfig -p | grep librf24.so
#if [ $? -eq 0 ]; then
#  read -p "Library seems to be installed. Do you want to rebuild last master version? [Y/n]" choice
#  case "$choice" in
#    n|N ) exit 0 ;;
#    * ) echo "-----";;
#  esac
#fi

echo "Building RF24 libs..."
mkdir -p rf24libs
cd rf24libs
if [ -d RF24 ] ; then
cd RF24 ; git pull ; cd ..
else
git clone $RF24GIT/RF24.git RF24
fi
echo "=>RF24..."
cd RF24
git checkout ${RF24_VERSION}
git show --oneline -s
echo "===> Activate failure handling ....."
sed -i '/#define FAILURE_HANDLING/s/^\s.\/\///g' RF24_config.h && cat RF24_config.h | grep FAILURE
echo "===> Building..."
./configure --driver=SPIDEV
make
sudo make install
cd ..
rm -rf RF24
echo "==> RF24 installed / cleaned"
echo "=>RF24Network..."
if [ -d RF24Network ] ; then
cd RF24Network ; git pull ; cd ..
else
git clone $RF24GIT/RF24Network.git RF24Network
fi
cd RF24Network
git checkout ${RF24N_VERSION}
git show --oneline -s
make
sudo make install
cd ..
rm -rf RF24Network
echo "==> RF24Network installed / cleaned"
echo "=>RF24Mesh..."
if [ -d RF24Mesh ] ; then
cd RF24Mesh; git pull ; cd ..
else
git clone $RF24GIT/RF24Mesh.git RF24Mesh
fi
cd RF24Mesh
git checkout ${RF24M_VERSION}
git show --oneline -s
make
sudo make install
cd ..
rm -rf RF24Mesh
echo "==> RF24Mesh installed / cleaned"

# Do not build gateway until functional release
#echo "=>RF24Gateway..."
#if [ -d RF24Gateway ] ; then
#cd RF24Gateway; git pull ; cd ..
#else
#git clone $RF24GIT/RF24Gateway.git RF24Gateway
#fi
#cd RF24Gateway
#make
#sudo make install
#cd ..

cd ..
rm -fr rf24libs
echo "done!"
