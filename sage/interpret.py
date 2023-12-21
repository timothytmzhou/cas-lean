import sage.all as sage
import operator
import json
from enum import Enum

class Command(Enum):
    ROOTS = 1

# ints and floats are interpreted as themselves, nothing else is supported currently
ops = {
    "+": operator.add,
    "-": operator.sub,
    "*": operator.mul,
    "/": operator.truediv,
    "^": operator.pow,
}

interpretations = {
    **ops,
    "log": sage.log,
    "sqrt": sage.sqrt,
    "pi": sage.pi,
    "e": sage.e
}

def interpret(query):
    """
    interprets a JSON representation of a query into SageMath.
    
    query: string with JSON representation of query (see below)

    expected JSON format:
        - tree where named fields are called value (value of current node) and children (list of child nodes)
        - top level is name of a command, children are SageMath expressions
    
    returns: tuple (cmd, exprs) where cmd is a Command enum and exprs is a[symbolic.expression.Expression]
    """
    d = json.loads(query)
    cmd = Command[d["value"].upper()]
    if cmd == Command.ROOTS:
        f, bv_node, fv_node = d["children"]
        bv = bv_node["value"]
        fvs = fv_node["value"]
        exprs = [interpret_expr(f, fvs + [bv]), sage.var(bv)]
    return (cmd, exprs)

def interpret_expr(expr, free_vars):
    v = expr["value"]
    if isinstance(v, (int, float)):
        return v
    elif v in free_vars:
        return sage.var(v)
    else:
        children = expr["children"]
        return interpretations[v](*[interpret_expr(c, free_vars) for c in children])
