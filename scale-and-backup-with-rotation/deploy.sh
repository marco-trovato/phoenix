#!/bin/bash
apt update -y && apt upgrade -y
apt install git nodejs npm -y
git clone https://github.com/claranet-ch/cloud-phoenix-kata.git
cd cloud-phoenix-kata/
npm update -g
npm install
npm start