Param (
    [string]$config,
    [string]$backups
)

$TOOLS = Get-Content $config | ConvertFrom-Json
$BackupList = Get-Content $backups | ConvertFrom-Json

for ($i = 0; $i -lt $BackupList.Count; $i++) {

    $BackupItem = $BackupList[$i]
    $Connection = $TOOLS."$($BackupItem.'connection')-db"[$BackupItem.'connection-id']

    $user = $Connection.user
    $pass = $Connection.password
    $serv = $Connection.server
    $port = $Connection.port
    $db   = $BackupItem.'database'

    Write-Host "Backup: $($serv):$($db)"
    python.exe .\.tools\mysql_db_backup.py --source="$($user):$($pass)@$($serv):$($port)" --database=$db --path="$($TOOLS.'backups_dir')"

}