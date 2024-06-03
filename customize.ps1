# Version: 1.0

### ---------------------------- Pre-freeze ----------------------------
Write-Output "=== Start Pre-Freeze ==="

Write-Output "=== End of Pre-Freeze ==="


### ------------------------------ Freeze ------------------------------
Write-Output "Freezing ...\n"
& "C:\Program Files\VMware\VMware Tools\vmtoolsd.exe" --cmd "instantclone.freeze"


### ---------------------------- Post-freeze ---------------------------
Write-Output "=== Start Post-Freeze ==="

Write-Output "=== End of Post-Freeze ==="
