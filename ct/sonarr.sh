#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/rjiraya/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/rjiraya/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
   _____                            
  / ___/____  ____  ____  __________
  \__ \/ __ \/ __ \/ __ `/ ___/ ___/
 ___/ / /_/ / / / / /_/ / /  / /    
/____/\____/_/ /_/\__,_/_/  /_/     
                                    
EOF
}
header_info
echo -e "Loading..."
APP="Sonarr"
var_disk="4"
var_cpu="2"
var_ram="1024"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -f /etc/apt/sources.list.d/sonarr.list ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
read -r -p "Are you updating Sonarr v4? <y/N> " prompt
if [[ "${prompt,,}" =~ ^(y|yes)$ ]]; then
  msg_info "Updating $APP v4"
  systemctl stop sonarr.service
  wget -q -O SonarrV4.tar.gz 'https://services.sonarr.tv/v1/download/develop/latest?version=4&os=linux'
  tar -xzf SonarrV4.tar.gz
  cp -r Sonarr/* /usr/lib/sonarr/bin
  rm -rf Sonarr SonarrV4.tar.gz
  systemctl start sonarr.service
  msg_ok "Updated $APP v4"
  exit
fi  
msg_info "Updating $APP LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated $APP LXC"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8989${CL} \n"
