#!/bin/bash
set -e

echo "[*] Installing dependencies..."
sudo apt update
sudo apt install -y openvpn easy-rsa iptables iproute2 curl

echo "[*] Creating directories..."
mkdir -p ~/easy-rsa
cd ~/easy-rsa

echo "[*] Downloading Easy-RSA..."
wget -q https://github.com/OpenVPN/easy-rsa/releases/download/v3.1.7/EasyRSA-3.1.7.tgz
tar xvf EasyRSA-3.1.7.tgz > /dev/null
mv EasyRSA-3.1.7/* ./

echo "[*] Initializing PKI..."
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
./easyrsa sign-req server server
./easyrsa gen-dh
./easyrsa gen-crl
./easyrsa gen-req client1 nopass
./easyrsa sign-req client client1

echo "[*] Copying certificates and keys..."
sudo cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem pki/crl.pem /etc/openvpn/
sudo cp pki/issued/client1.crt pki/private/client1.key /etc/openvpn/

echo "[*] Done. Generate ta.key manually before starting OpenVPN."
