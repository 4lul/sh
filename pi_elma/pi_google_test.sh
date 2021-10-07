cd /usr/src &&
sudo git clone https://github.com/google/googletest.git &&
cd googletest &&
sudo mkdir install &&
cd install &&
sudo cmake ../ &&
sudo make &&
sudo make install
