import os
from libs import arg
from datetime import datetime
from libs.replace_in_file import replace_in_file

def main(arg):
    database = arg['database']
    source = arg['source']
    user, host = source.split('@',1)
    user, password = user.split(':',1)
    host, port = host.split(':',1)
    file = datetime.now().strftime('./backups/db/'+database+'_(%Y-%m-%d_%H-%M-%S).sql')
    os.system('mysqldump.exe '+database+' --result-file='+file+' --user='+user+' --host='+host+' --port='+port+' --password='+password)
    replace_in_file(file, lambda text: text.replace('utf8mb4_0900_ai_ci', 'utf8mb4_general_ci'))

arg.load(['database', 'source'], main, lambda x:
    print('python mysql_db_backup.py --source=username:password@host:port --database=db_name'))