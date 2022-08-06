Param (
    [string]$config,
    [string]$migration
)

$TOOLS = Get-Content $config | ConvertFrom-Json
$MigrationList = Get-Content $migration | ConvertFrom-Json

for ($i = 0; $i -lt $MigrationList.Count; $i++) {

    $MigrationItem = $MigrationList[$i]
    $SourceConnection = $TOOLS."$($MigrationItem.'source-connection')-db"[$MigrationItem.'source-connection-id']
    $DestConnection = $TOOLS."$($MigrationItem.'dest-connection')-db"[$MigrationItem.'dest-connection-id']

    $userL = $SourceConnection.user
    $passL = $SourceConnection.password
    $servL = $SourceConnection.server
    $portL = $SourceConnection.port
    $dbL   = $MigrationItem.'source-db'

    $userR = $DestConnection.user
    $passR = $DestConnection.password
    $servR = $DestConnection.server
    $portR = $DestConnection.port
    $dbR   = $MigrationItem.'dest-db'

    Write-Host "Migration: $($servL):$($dbL) > $($servR):$($dbR)"
    python.exe .\.tools\mysql_db_migrate.py --source="$($userL):$($passL)@$($servL):$($portL)" --dest="$($userR):$($passR)@$($servR):$($portR)" --database="$($dbL):$($dbR)"

}