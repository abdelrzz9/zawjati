import ast
import operator

from .base import BaseTool

ALLOWED_OPERATORS = {
    ast.Add: operator.add,
    ast.Sub: operator.sub,
    ast.Mult: operator.mul,
    ast.Div: operator.truediv,
    ast.Pow: operator.pow,
    ast.USub: operator.neg,
    ast.Mod: operator.mod,
    ast.FloorDiv: operator.floordiv,
}


class CalculatorTool(BaseTool):
    name = "calculator"
    description = "Evaluate a mathematical expression"
    parameters = {
        "type": "object",
        "properties": {
            "expression": {
                "type": "string",
                "description": "Mathematical expression, e.g. '2 + 2' or 'sqrt(16)'",
            }
        },
        "required": ["expression"],
    }

    async def execute(self, expression: str) -> str:
        try:
            tree = ast.parse(expression.strip(), mode="eval")
            result = self._eval(tree.body)
            return str(result)
        except Exception as e:
            return f"Error evaluating expression: {e}"

    def _eval(self, node):
        if isinstance(node, ast.Constant):
            return node.value
        elif isinstance(node, ast.BinOp):
            op = ALLOWED_OPERATORS.get(type(node.op))
            if op is None:
                raise ValueError(f"Unsupported operator: {type(node.op).__name__}")
            return op(self._eval(node.left), self._eval(node.right))
        elif isinstance(node, ast.UnaryOp):
            op = ALLOWED_OPERATORS.get(type(node.op))
            if op is None:
                raise ValueError(f"Unsupported unary operator: {type(node.op).__name__}")
            return op(self._eval(node.operand))
        elif isinstance(node, ast.Call):
            import math
            func = getattr(math, node.func.id, None)
            if func is None:
                raise ValueError(f"Unknown function: {node.func.id}")
            args = [self._eval(a) for a in node.args]
            return func(*args)
        else:
            raise ValueError(f"Unsupported expression: {type(node).__name__}")
