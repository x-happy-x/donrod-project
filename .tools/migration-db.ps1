Param (
    [string]$config,
    [string]$migration
)

$TOOLS = Get-Content $config | ConvertFrom-Json
$MigrationList = Get-Content $migration | ConvertFrom-Json

for ($i = 0; $i -lt $MigrationList.Count; $i++) {

    $MigrationItem = $MigrationList[$i]
    $LocalConnection = $TOOLS.'local-db'[$MigrationItem.'local-connection-id']
    $RemoteConnection = $TOOLS.'remote-db'[$MigrationItem.'remote-connection-id']
    $LocalDB = $MigrationItem.'local-db'
    $RemoteDB = $MigrationItem.'remote-db'

    $userL = $LocalConnection.user
    $passL = $LocalConnection.password
    $servL = $LocalConnection.server
    $portL = $LocalConnection.port
    $dbL   = $LocalDB

    $userR = $RemoteConnection.user
    $passR = $RemoteConnection.password
    $servR = $RemoteConnection.server
    $portR = $RemoteConnection.port
    $dbR   = $RemoteDB

    Write-Host "Migration: $($servL):$($dbL) > $($servR):$($dbR)"
    python.exe .\.tools\mysql_db_migrate.py --source="$($userL):$($passL)@$($servL):$($portL)" --dest="$($userR):$($passR)@$($servR):$($portR)" --database="$($dbL):$($dbR)"

}