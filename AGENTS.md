# Downstream CI

So far these are just two standalone scripts `setup_downstream_ci.py` and `generate-workflows.py`.

## Test

- There are no tests yet 
- Verify via 
```
ruff check 
mypy .
```

## Code style

- Use `ruff format`
- Annotate with types and use `mypy` to check
- prefer pure functions and avoid side effects
- Use docstrings to explain the purpose of functions and classes
- Follow PEP 8 style guide for Python code
- Declare arguments generally as non-mutable, e.g. `Sequence` instead of `list`, `Mapping` instead of `dict`, etc.
- Don't use implicit optional arguments, e.g. `def foo(x: Optional[int] = None)` is not ideal, prefer `def foo(x: int | None = None)`
- Avoid using `Any` type. Better let it undeclared, than use `Any` just to silence type errors.
    It's borderline acceptable to use it for value in a dictionary, e.g. `Dict[str, Any]`, but even then it's better to be more specific if possible.
- Use 120 line length limit.
- Use specific error codes when ignoring linter errors, e.g. `# type: ignore[method-assign]` instead of just `# type: ignore`