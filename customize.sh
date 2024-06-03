#!/bin/bash
# Version: 1.0

set -x
exec 2> /var/log/freeze.log

### ---------------------------- Pre-freeze ----------------------------
echo -e "\n=== Start Pre-Freeze ==="

echo -e "=== End of Pre-Freeze ===\n"



### ------------------------------ Freeze ------------------------------
echo -e "Freezing ...\n"
vmware-rpctool "instantclone.freeze"



### ---------------------------- Post-freeze ---------------------------
echo -e "\n=== Start Post-Freeze ==="

# Add services here that should be checked post-freeze
# Example: Services("x11vnc.service")
SERVICES=("x11vnc.service")
for SERVICE in "${SERVICES[@]}"
do
  if ! systemctl is-active --quiet $SERVICE; then
    systemctl restart $SERVICE
  fi
done


echo "=== End of Post-Freeze ==="
