sudo mkdir /usr/local/include/json &&
cd /usr/local/include/json &&
sudo curl -O -J -L https://github.com/nlohmann/json/releases/download/v3.5.0/json.hpp &&
sudo mv json.hpp json.h
