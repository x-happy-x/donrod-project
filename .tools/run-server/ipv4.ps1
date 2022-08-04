$HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress
$config = Get-Content .\configs\tools.json | ConvertFrom-Json
php -S "$($HostIP):$($config.port)"