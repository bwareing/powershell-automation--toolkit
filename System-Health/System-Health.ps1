Write-Host "======== SYSTEM HEALTH CHECK ========="
Write-Host ""

Write-Host "Computer:
$env:COMPUTERNAME"
Write-Host ""

Write-Host "---------- Operating System -----------" -ForegroundColor DarkMagenta
$os = Get-CimInstance Win32_OperatingSystem

Write-Host "OS: $($os.Caption)"
Write-Host "Version: $($os.Version)"
Write-Host "Last Boot: $($os.LastBootUpTime)"

Write-Host ""
Write-Host "------------Disk-----------------------" -ForegroundColor DarkMagenta

$os = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" |
	Select-Object DeviceID,
	 @{Name="Total Space"; Expression={ "{0:N2}" -f ($_.Size / 1GB) + "GB" }},
         @{Name="Free Space";  Expression={ "{0:N2}" -f ($_.FreeSpace / 1GB) + "GB" }},
         @{Name="Percent Used"; Expression={ ("{0:N2}" -f (100 - ($_.FreeSpace / $_.Size * 100))) + "%" }}

if($os.'Percent Used' -le 80){
   Write-Host "<Disk space good>" -ForegroundColor Green
}
else{
   Write-Host "<Low Disk space>" -ForegroundColor Red
}


$os | Format-Table -AutoSize

Write-Host ""
Write-Host "----------Memory ---------------------" -ForegroundColor DarkMagenta

$memory = Get-CimInstance Win32_OperatingSystem

Write-Host "Free Memory: $([math]::Round($memory.FreePhysicalMemory / 1024 / 1024, 2)) GB"
Write-Host "Total Memory: $([math]::Round($memory.TotalVisibleMemorySize / 1024 / 1024, 2)) GB"

Write-Host ""
Write-Host "--------------Net Work-------------------" -ForegroundColor DarkMagenta
Test-Connection 8.8.8.8 -Count 2 | Format-Table -AutoSize

Write-Host ""
Write-Host "--------------Top CPU Processes------------" -ForegroundColor DarkMagenta
Get-Process |
    Sort-Object CPU -Descending |
    Select-Object -First 5 Name, CPU |
    Format-Table -AutoSize

Write-Host ""
Write-Host "================== Check Completed ==============="
