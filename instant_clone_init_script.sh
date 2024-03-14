#!/bin/bash
 
set -x
exec 2>/root/ic-customization.log
 
echo -e "\n=== Start Pre-Freeze ==="
 
# Disable assignment of fixed names https://askubuntu.com/a/834201
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
 
# Disable primary network interface (ens160, this may differ from your OS installation)
CURRENT_PRIMARY_INTERFACE_NAME="eth0"
DESIRED_PRIMARY_INTERFACE_NAME="eth0"
echo "Disabling ${CURRENT_PRIMARY_INTERFACE_NAME} interface ..."
ip addr flush dev ${CURRENT_PRIMARY_INTERFACE_NAME}
ip link set ${CURRENT_PRIMARY_INTERFACE_NAME} down
 
echo -e "=== End of Pre-Freeze ===\n"
 
echo -e "Freezing ...\n"
 
vmware-rpctool "instantclone.freeze"
 
echo -e "\n=== Start Post-Freeze ==="
 
 
echo "Updating MAC Address ..."
for NETDEV in /sys/class/net/e*
do
        DEVICE_LABEL=$(basename $(readlink -f "$NETDEV/device"))
        DEVICE_DRIVER=$(basename $(readlink -f "$NETDEV/device/driver"))
        echo $DEVICE_LABEL > /sys/bus/pci/drivers/$DEVICE_DRIVER/unbind
        echo $DEVICE_LABEL > /sys/bus/pci/drivers/$DEVICE_DRIVER/bind
done
 
echo "Updating IP Address ..."
# Rename interface to eth0 (not necessary)
sed -i "s/${CURRENT_PRIMARY_INTERFACE_NAME}/${DESIRED_PRIMARY_INTERFACE_NAME}/" /etc/network/interfaces
 
 
echo "Restart networking ..."
systemctl restart networking.service
systemctl restart resolvconf.service
 
echo "Updating Hardware Clock on the system ..."
hwclock --hctosys
 
echo "=== End of Post-Freeze ==="
 
echo -e "\nCheck /root/ic-customization.log for details\n\n"
 
clear
