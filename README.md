## Build ABI Test Ben

This is a repo of little tests and snippets which I (@woodard)
wrote to demonstrate particular abi compatibility problems.
It's moved here and changed to an installable library so it can be created
as a package for [build-abi-containers](https://github.com/buildsi/build-abi-containers).

# Tests

## swap-underlink

Swapping the two underlinked libraries demonstrations that the ABI
compatibility that abicompat professed is in fact a false positive.
It shows that the two libraries are in fact not ABI compatible due the
fact that their return value is not the same size. This causes the the
stack to become corrupted.

## swap-execption

Swapping the two libraries with different internal representations
demonstrates that exceptions need to be included in the ABI specification
The types that must be considered are not part of symbol table but they
are thrown out of the library and can be caught in a scope beyond the
library itself. Therefore, their internal representation matters. 
