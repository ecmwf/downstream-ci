from typing import Any, TypeVar, Type, cast, get_origin
from collections.abc import Sequence, Mapping

PackageVariable = str | bool | Sequence[str] | Sequence[bool] | Mapping[str, str]
T_PackageVariable = TypeVar("T_PackageVariable", bound=PackageVariable)

T = TypeVar("T")


def ensure_type(T_: Type[T], x: Any) -> T:
    type_to_test = get_origin(T_) or T_
    if not isinstance(x, type_to_test):
        raise TypeError(f"Expected type {T_}, got {type(x)}")
    return x


def ensure_not_none(var: T | None) -> T:
    if var is None:
        raise ValueError("Expected variable to be not None")
    return var


def get_optional_package_var(
    var_name: str,
    dep_tree: dict,
    package: str,
    wf_name: str,
    default: PackageVariable | None = None,
) -> PackageVariable | None:
    """Get package variable from dep tree, preferring workflow-specific values.

    Lookup order: workflow-specific value, package value, then default.

    Can return none if variable is not found and no default is provided.
    """
    try:
        return dep_tree[package][wf_name][var_name]
    except KeyError:
        return dep_tree[package].get(var_name, default)


def get_required_package_var(
    var_name: str,
    dep_tree: dict,
    package: str,
    wf_name: str,
    default: T_PackageVariable | None = None,
) -> T_PackageVariable:
    """Get package variable from dep tree, preferring workflow-specific values.

    Lookup order: workflow-specific value, package value, then default.

    Fails if variable is not found and no default is provided.

    Deduces the type from the default value if provided, otherwise returns a union of all possible types.
    """
    return cast(
        T_PackageVariable,
        ensure_not_none(get_optional_package_var(var_name, dep_tree, package, wf_name, default)),
    )
