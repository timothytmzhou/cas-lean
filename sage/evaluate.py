from interpret import Command

def evaluate(cmd, args):
    if cmd == Command.ROOTS:
        f = args[0]
        v = args[1]
        return f.solve(v)