#!/bin/sh

# EXAMPLE: This script would be executed during an update,
# even if the user selected "Keep settings".
# It retroactively adds a new firewall rule.

RULE_NAME="Allow-New-Service-Example"

# 1. Check if the rule already exists (Idempotency)
# We search the firewall config for a rule with this name.
if uci show firewall | grep -q "name='$RULE_NAME'"; then
    # Rule already exists, do nothing.
    exit 0
fi

# 2. Add rule
# We use 'uci batch' for multiple commands at once.
uci batch <<EOF
add firewall rule
set firewall.@rule[-1].name='$RULE_NAME'
set firewall.@rule[-1].src='netbird'
set firewall.@rule[-1].dest_port='8080'
set firewall.@rule[-1].proto='tcp'
set firewall.@rule[-1].target='ACCEPT'
EOF

# 3. Commit changes
uci commit firewall

# The script must end with exit 0 so that OpenWrt deletes it
# from /etc/uci-defaults/ after successful execution. It runs exactly once.
exit 0
