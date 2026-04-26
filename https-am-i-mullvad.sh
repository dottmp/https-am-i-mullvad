#!/bin/bash

# @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @
# Mullvad VPN Status Checker (Router-Compatible)
#
# Checks Mullvad VPN connectivity via am.i.mullvad.net API
# Perfect when you dont run mullvad cli but are sill connected to mullvad e.g. vpn 
# on router situation.
# 
# Integrates nicely with waybar for status display and tooltip info, and allows copying the current VPN IP to clipboard.


# @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @
# Mullvad Methods
#
# [vpn_check_connection] Check if connected to Mullvad VPN using their API
vpn_check_connection() {
  # Check if connected via Mullvad using their API
  local response
  response=$(curl -s --max-time 5 https://am.i.mullvad.net/connected 2>/dev/null)
  
  if [[ "$response" == *"You are connected to Mullvad"* ]]; then
    echo "Connected"
  else
    echo "Disconnected"
  fi
}

#[get_raw_json] Get detailed VPN info from Mullvad API
vpn_get_json() {
  # Get detailed info from Mullvad API (JSON format)
  curl -s --max-time 5 https://am.i.mullvad.net/json 2>/dev/null
}


# @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @
# Vars
VPN_CONNECTION=$(vpn_check_connection)
VPN_DETAILS=$(vpn_get_json)

# Parse JSON details 
VPN_IP=$(echo "$VPN_DETAILS" | grep -o '"ip":"[^"]*"' | cut -d'"' -f4)
VPN_COUNTRY=$(echo "$VPN_DETAILS" | grep -o '"country":"[^"]*"' | cut -d'"' -f4)
VPN_CITY=$(echo "$VPN_DETAILS" | grep -o '"city":"[^"]*"' | cut -d'"' -f4)
VPN_MULLVAD_EXIT=$(echo "$VPN_DETAILS" | grep -o '"mullvad_exit_ip":true' | wc -l)

if [ "$VPN_MULLVAD_EXIT" -eq 1 ]; then
  VPN_SERVER=$(echo "$VPN_DETAILS" | grep -o '"mullvad_exit_ip_hostname":"[^"]*"' | cut -d'"' -f4)
else
  VPN_SERVER="N/A"
fi


# @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @
# Actions
#
# [get_module_data] Get data for custom module in waybar. Returns waybar JSON
get_module_data() {
  local class alt tooltip
  local timestamp=$(date '+%H:%M:%S')

  if [ "$VPN_CONNECTION" = "Connected" ]; then
    tooltip="Mullvad VPN\n\nStatus: Connected\nServer: $VPN_SERVER\nLocation: $VPN_CITY, $VPN_COUNTRY\nIP: $VPN_IP\n\nLast updated: $timestamp"
    class="connected"
    alt="connected"
  else
    tooltip="Mullvad VPN (Router)\n\nStatus: Disconnected\nIP: $VPN_IP\n\nLast updated: $timestamp"
    class="disconnected"
    alt="disconnected"
  fi

  echo "{\"text\": \"$VPN_CONNECTION\", \"tooltip\": \"$tooltip\", \"alt\": \"$alt\", \"class\": \"$class\"}"
}


# [copy_ip] Copy IP address to clipboard
copy_ip() {
  if [ -n "$VPN_IP" ]; then
    echo -n "$VPN_IP" | wl-copy
    echo "IP copied: $VPN_IP"
  else
    echo "No IP available"
  fi
}


# @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @ @
# Input
case "$1" in
copy) copy_ip ;;
json) vpn_get_json ;;
status) vpn_check_connection ;;
waybar) get_module_data ;;
*) get_module_data ;;
esac
