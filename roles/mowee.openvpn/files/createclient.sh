#!/bin/bash
# {{ ansible_managed }}

VPN_DIR="/etc/openvpn/"

# if [ 1 == 1 ]; then
# echo $1 $2 $3 ${VPN_DIR}
#   exit 1
# fi

if [ $EUID -ne 0 ]; then
echo "Script must be launch as root" 1>&2
  exit 1
fi

# Test parameters
if [ $# -ne 3 ]; then
echo "Missing parameters: <node> <openvpn_ip> <openvpn_port>" 1>&2
  exit 1
fi

cd ${VPN_DIR}easy-rsa/

# Create client without password
source vars
KEY_CN=$1 ./pkitool $1

sudo mkdir -p ${VPN_DIR}clientconf/
sudo mkdir -p ${VPN_DIR}clientconf/$1
sudo cp keys/ca.crt keys/ta.key keys/$1.crt keys/$1.key ${VPN_DIR}clientconf/$1/
touch ${VPN_DIR}clientconf/$1/$1.conf
cat >> ${VPN_DIR}clientconf/$1/$1.conf << EOF
# Client
client
dev tun
proto tcp
remote $2 $3
resolv-retry infinite
cipher AES-256-CBC
# Keys
ca ca.crt
cert $1.crt
key $1.key
tls-auth ta.key 1
# Security
nobind
persist-key
persist-tun
comp-lzo
verb 3
script-security 3
EOF
