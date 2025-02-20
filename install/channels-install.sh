#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/rjiraya/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y chromium
$STD apt-get install -y xvfb
msg_ok "Installed Dependencies"

msg_info "Installing Channels DVR Server (Patience)"
cd /opt
$STD bash <(curl -fsSL https://getchannels.com/dvr/setup.sh)
# adduser $(id -u -n) video && adduser $(id -u -n) render
msg_ok "Installed Channels DVR Server"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
