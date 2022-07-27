def load(wait_arg, success, error):
    import sys
    get_arg = {}
    for arg in sys.argv:
        arg_parts = arg.split('=',1)
        for warg in wait_arg:
            if len(arg_parts) > 1 and arg_parts[0][2:] == warg and len(arg_parts[-1]) > 0:
                get_arg[warg] = arg_parts[-1]

    not_args = False
    for warg in wait_arg:
        if warg not in get_arg:
            not_args = True
            break

    if not_args:
        return error(get_arg)
    return success(get_arg)