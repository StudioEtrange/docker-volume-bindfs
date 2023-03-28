lddtree
=======

Fork from https://github.com/ncopa/lddtree which is fork of pax-utils' lddtree.sh

This is a shell version of pax-utils' lddtree. This tool is useful for
resolving elf dependencies.


lddtree.sh depends on scanelf from pax-utils package or readelf from
binutils package.

```
Usage: lddtree.sh [options] ELFFILE...

Options:

  -a              Show all duplicated dependencies
  -x              Run with debugging
  -b <backend>    Force use of specific backend tools (scanelf or readelf)
  -R <root>       Use this ROOT filesystem tree
  --no-auto-root  Do not automatically prefix input ELFs with ROOT
  --no-recursive  Do not recursivly parse dependencies
  --no-header     Do not show header (binary and interpreter info)
  -l              Display a list of linked libraries in a flat format
  -m              Display a map of resolved linked libraries
  -h              Show this help output
  -V              Show version information
```
