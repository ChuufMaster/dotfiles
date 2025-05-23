
#!/usr/bin/env bash

# Copyright (C) 2021  Damien Cassou

# Author: Damien Cassou <damien@cassou.me>
# Url: https://gitlab.com/DamienCassou/rofi-vpn
# Version: 0.2.0

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Commentary:

# This program uses rofi and nmcli to let the user enable/disable VPN
# connections.

# Code:

# What to show in front of an active VPN connection:
ACTIVE_PREFIX="  ✓ "

# What to show in front of an inactive VPN connection:
INACTIVE_PREFIX="    "

# Display on standard output all VPN connections, one per line. An
# active VPN connection is prefixed with `ACTIVE_PREFIX` and an inactive
# one is prefixed with `INACTIVE_PREFIX`.
function list_vpn_connections() {
    nmcli --get-values ACTIVE,NAME,TYPE connection show \
        | grep ':vpn$' \
        | sed \
              -e "s/^no:/${INACTIVE_PREFIX}/" \
              -e "s/^yes:/${ACTIVE_PREFIX}/" \
              -e 's/:vpn$//'
}

# Take a line as displayed by `list_vpn_connections()` as argument and
# use nmcli to toggle the corresponding connection.
function toggle_vpn_connection() {
    local result="$1"
    local connection

    connection=$(extract_connection_name_from_result "${result}")

    if [[ $result = ${ACTIVE_PREFIX}* ]]; then
        nmcli connection down "$connection"
    else
        nmcli connection up "$connection"
    fi
}

# Take a line as displayed by `list_vpn_connections()` as argument and
# remove `ACTIVE_PREFIX` or `INACTIVE_PREFIX` to only display the
# connection name.
function extract_connection_name_from_result() {
    local result="$1"

    # I don't know how to use plain bash to remove the prefix so I'm
    # using sed:
    # shellcheck disable=SC2001
    sed -e 's/^.* \([^ ]\+\)$/\1/' <<< "$result"
}

# Execute the `rofi` command. The first argument of the function is
# used as lines to select from.
function start_rofi() {
    local content="$1"
    echo -e "$content" | rofi -dmenu
}

# List the VPN connections and let the user toggle one using rofi.
function main() {
    local connections
    local result

    connections=$(list_vpn_connections)
    result=$(start_rofi "$connections")

    toggle_vpn_connection "$result"
}

main

# Local Variables:
# eval: (flycheck-mode)
# End:
