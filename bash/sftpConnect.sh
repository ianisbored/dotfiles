#!/bin/bash
#created by ianisbored on June 26, 2025 @ 9:30PM, PST
yellow=$'\e[33m'
reset=$'\e[0m'

defPort='8022'
defUser='u6_a690'

read -p "${yellow}*${reset} Insert port: " port
read -p "${yellow}*${reset} Insert user: " user
read -p "${yellow}*${reset} Insert IP: " ip

port=${port:-$defPort}
user=${user:-$defUser}

sftp -oPort=$port $user@$ip
