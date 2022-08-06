Param (
    [string]$config,
    [string]$restore
)

$TOOLS = Get-Content $config | ConvertFrom-Json
$RestoreList = Get-Content $restore | ConvertFrom-Json

$DIR = "$((Get-Item .).FullName)/$($TOOLS.'backups_dir')"

for ($i = 0; $i -lt $RestoreList.Count; $i++) {

    $RestoreItem = $RestoreList[$i]
    $LocalConnection = $TOOLS."$($RestoreItem.connection)-db"[$RestoreItem.'connection-id']
    $LocalDB = $RestoreItem.'database'

    $user = $LocalConnection.user
    $pass = $LocalConnection.password
    $serv = $LocalConnection.server
    $port = $LocalConnection.port
    $db   = $LocalDB

    $file = Get-ChildItem -Path $DIR -Filter $RestoreItem.filter | Sort-Object LastAccessTime -Descending | Select-Object -Last $RestoreItem.'backup-id'

    Write-Host "Restore: $($DIR)$($file.name)"
    python.exe .\.tools\mysql_db_restore.py --dest="$($user):$($pass)@$($serv):$($port)" --database=$db --file="$($DIR)$($file.name)"

}