#!/bin/bash
set -e
cd ~/easy-rsa

./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
./easyrsa sign-req server server
./easyrsa gen-dh
./easyrsa gen-crl
./easyrsa gen-req client1 nopass
./easyrsa sign-req client client1
