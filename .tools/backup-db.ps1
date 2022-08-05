Param (
    [string]$config,
    [string]$backups
)

$TOOLS = Get-Content $config | ConvertFrom-Json
$BackupList = Get-Content $backups | ConvertFrom-Json

for ($i = 0; $i -lt $BackupList.Count; $i++) {

    $BackupItem = $BackupList[$i]
    $LocalConnection = $TOOLS.'local-db'[$BackupItem.'connection-id']
    $LocalDB = $BackupItem.'database'

    $user = $LocalConnection.user
    $pass = $LocalConnection.password
    $serv = $LocalConnection.server
    $port = $LocalConnection.port
    $db   = $LocalDB

    Write-Host "Backup: $($serv):$($db)"
    python.exe .\.tools\mysql_db_backup.py --source="$($user):$($pass)@$($serv):$($port)" --database=$db

}