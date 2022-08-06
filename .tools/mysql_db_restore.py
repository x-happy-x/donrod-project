import os
from libs import arg
from libs.replace_in_file import replace_in_file

def main(arg):
    database = arg['database']
    file = arg['file']
    destination = arg['dest']
    user, host = destination.split('@',1)
    user, password = user.split(':',1)
    host, port = host.split(':',1)
    os.system('mysql --database='+database+' --user='+user+' --host='+host+' --port='+port+' --password='+password+' < '+file)

arg.load(['database', 'dest', 'file'], main, lambda x:
    print('python mysql_db_restore.py --dest=username:password@host:port --database=db_name --file=path/to/file'))