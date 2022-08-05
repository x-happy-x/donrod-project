Param (
    [string]$config
)
$HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress
$TOOLS = Get-Content $config | ConvertFrom-Json
php -S "$($HostIP):$($TOOLS.port)"