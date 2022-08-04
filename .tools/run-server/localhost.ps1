$config = Get-Content .\configs\tools.json | ConvertFrom-Json
php -S "localhost:$($config.port)"