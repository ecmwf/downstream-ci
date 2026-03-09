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