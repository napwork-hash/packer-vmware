$vmrun    = "D:\VMware\vmrun.exe"
$template = "D:\ISO Data\ubuntu-lab-template\ubuntu-lab-template.vmx"
$baseDir  = "D:\ISO Data"

foreach ($i in 10..13) {
    $name    = "Ubuntu Lab - $i"
    $vmxPath = "$baseDir\$name\$name.vmx"

    Write-Host "[+] Cloning $name ..." -ForegroundColor Cyan
    & $vmrun clone $template $vmxPath full -cloneName $name

    Write-Host "[+] Starting $name ..." -ForegroundColor Green
    & $vmrun start $vmxPath nogui

    Write-Host "[✓] $name done`n" -ForegroundColor Yellow
}

Write-Host "=== Running VMs ===" -ForegroundColor Magenta
& $vmrun list