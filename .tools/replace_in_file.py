import arg

def replace_in_file(file, func, opcodec='utf-8', clcodec='utf-8', end='\n'):
    import os
    path, file = os.path.splitdrive(file)
    orig_file = os.path.join(path, file)
    tmp_file = os.path.join(path, 'tmp_'+file)
    with open(orig_file, 'r', encoding=opcodec,) as fr:
        with open(tmp_file, 'w', encoding=clcodec) as fw:
            for line in fr:
                fw.write(func(line.rstrip()) + end)
    os.remove(orig_file)
    os.rename(tmp_file, orig_file)

def main(arg):
    replace_in_file(arg['file'], lambda text: text.replace(arg['search'], arg['replace']), 'cp1251')

if __name__ == '__main__':
    arg.load(['file', 'search', 'replace'], main, lambda x: 
        print('python replace_in_file.py --file=/path/to/file --search=search_text --replace=replace_text'))