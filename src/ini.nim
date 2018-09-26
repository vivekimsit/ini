# parse_ini
# Copyright Vivek Poddar
# A new awesome nimble package
import tables

proc parse*(path: string): Table[string, string] =
  let file = open(path)
  return {"appname": "foo"}.toTable
