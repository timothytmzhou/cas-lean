import interpret
from evaluate import evaluate
from serialize import serialize

JSON = """
{
    "value": "roots",
    "children": 
    [
        {
            "value": "-",
            "children": [
                {
                    "value": "^",
                    "children": [
                        {"value": "x"}, 
                        {"value": 3}]
                },
                {
                    "value": "^",
                    "children": [
                        {"value": "a"}, 
                        {"value": 3}]
                }
            ]
        }, 
        {"value": "x"}, 
        {"value": ["a"]}
    ]
}
"""
cmd, args = interpret.interpret(JSON)
results = evaluate(cmd, args)
print(results)