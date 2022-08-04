import arg, os
import replace_in_file

def main(arg, file = '__migration_db_data__.sql'):
    databases = arg['database'].split(':',1)
    source = arg['source']
    user, host = source.split('@',1)
    user, password = user.split(':',1)
    host, port = host.split(':',1)
    os.system('mysqldump.exe '+databases[0]+' --result-file='+file+' --user='+user+' --host='+host+' --port='+port+' --password='+password)
    
    replace_in_file.replace_in_file(file, lambda text: text.replace('utf8mb4_0900_ai_ci', 'utf8mb4_general_ci'))
    
    destination = arg['dest']
    user, host = destination.split('@',1)
    user, password = user.split(':',1)
    host, port = host.split(':',1)
    os.system('mysql --database='+databases[1]+' --user='+user+' --host='+host+' --port='+port+' --password='+password+' < '+file)

arg.load(['database', 'source', 'dest'], main, lambda x:
    print('mysqldbcopy --file=/path/to/file --search=search_text --replace=replace_text'))