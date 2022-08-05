import os
from libs import arg
from libs.replace_in_file import replace_in_file

def main(arg, file = '.cache/__migration_db_data__.sql'):
    databases = arg['database'].split(':',1)
    source = arg['source']
    user, host = source.split('@',1)
    user, password = user.split(':',1)
    host, port = host.split(':',1)
    os.system('mysqldump.exe '+databases[0]+' --result-file='+file+' --user='+user+' --host='+host+' --port='+port+' --password='+password)
    
    replace_in_file(file, lambda text: text.replace('utf8mb4_0900_ai_ci', 'utf8mb4_general_ci'))
    
    destination = arg['dest']
    user, host = destination.split('@',1)
    user, password = user.split(':',1)
    host, port = host.split(':',1)
    os.system('mysql --database='+databases[1]+' --user='+user+' --host='+host+' --port='+port+' --password='+password+' < '+file)

arg.load(['database', 'source', 'dest'], main, lambda x:
    print('python mysql_db_migrate.py --source=username:password@host:port --dest=username:password@host:port --database=source_db:dest_db'))