import json
from interpret import ops


op_names = {v: k for k, v in ops.items()}


def serialize_const(expr):
    # this conversion is kind of hacky, there is probably a more idiomatic way to do this
    if expr.is_integer():
        return str(expr)
    try:
        r = QQ(expr)
        return {"op": "div", "data": [int(r.numerator()), int(r.denominator())] }
    except ValueError:
        pass

def _serialize(expr):
    # we assume that constants are in QQbar, the field of algebraic numbers
    if isinstance(expr, AlgebraicNumber):
        return serialize_const(expr)
    op = expr.operator()
    operands = expr.operands()
    return {"op": op_names[op], "data": [_serialize(e) for e in operands]}

def serialize(expr):
    return json.dumps(_serialize(expr))
