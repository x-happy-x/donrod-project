Param (
    [string]$config
)
$TOOLS = Get-Content $config | ConvertFrom-Json
php -S "localhost:$($TOOLS.port)"