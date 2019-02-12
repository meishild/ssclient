#!/usr/bin

echo '=================[CHECK]======================'

if [ "$(whoami)" != "root" ]
then
    echo "need root user run. exit!"
    exit;
fi

echo "install tools"
echo '=================[INSTALL]======================'

yum update -y
yum install epel-release -y
yum install python36 -y
yum install python36-pip -y
yum install libsodium -y
pip3.6 install https://github.com/shadowsocks/shadowsocks/archive/master.zip -U
mkdir -p /etc/shadowsocks/

echo '=================[CONFIG]======================'

if [ ! -f "config.json" ]; then
  echo "can't find config file."
  echo "remote server ip: "
  read remote_ip

  echo "remote server port: "
  read remote_port

  echo "remote server password: "
  read password

  echo "remote server method:"
  read method

  echo "{
    \"server\":\"$remote_ip\",
    \"server_port\":$remote_port,
    \"local_address\":\"127.0.0.1\",
    \"local_port\":1080,
    \"password\":\"$password\",
    \"timeout\":300,
    \"method\":\"$method\",
    \"fast_open\":false,
    \"workers\":1
}" > /etc/shadowsocks/config.json
else
  echo "find config file."
  cp config.json /etc/shadowsocks/config.json
fi

echo '=================[START SS CLIENT]======================'

/usr/local/bin/sslocal -c /etc/shadowsocks/config.json -d start

yum install privoxy -y
echo "forward-socks5 / 127.0.0.1:1080 ." >> /etc/privoxy/config

echo '=================[START privoxy]======================'

service privoxy restart

echo "config cmd"

echo 'onproxy() {
  export http_proxy="127.0.0.1:8118"
  export https_proxy="127.0.0.1:8118"
  curl https://api.ip.sb/geoip
}
offproxy() {
  unset http_proxy
  unset https_proxy
  curl https://api.ip.sb/geoip
}

' >> /etc/profile

export http_proxy="127.0.0.1:8118"
export https_proxy="127.0.0.1:8118"
curl https://api.ip.sb/geoip

echo '=================[FINISH]======================'

echo '". /etc/profile" refresh env"'
echo "use onproxy to proxy"
echo "use offproxy to exit proxy"
