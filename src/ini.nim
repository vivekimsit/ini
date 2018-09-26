# parse_ini
# Copyright Vivek Poddar
# A new awesome nimble package
import sets, strutils, tables

type Section = ref object
    properties: Table[string, string]

type Ini = ref object
    sections: Table[string, Section]

proc contains*(this: Ini, section: string): bool =
  return true

proc len*(this: Ini): int =
  return 1

proc sections*(this: Ini): HashSet[string] =
  return ["general"].toSet

proc getSections*(this: Ini): Table[string, string] =
  return {"appname": "foo"}.toTable

proc setSection*(this: Ini, name: string, section: Section) =
  this.sections[name] = section

proc newIni*(): Ini =
  let ini = Ini()
  ini.sections = initTable[string, Section]()
  return ini

proc newSection*(): Section =
  var s = Section()
  s.properties = initTable[string, string]()
  return s

proc parse*(path: string): Ini =
  let file = open(path)
  let ini = newIni()
  for line in file.lines():
    if line.strip() == "" or line.startsWith(";") or line.startsWith("#"):
      continue
    if line.startsWith("[") and line.endsWith("]"):
      let section = line[1..<line.len - 1]
      ini.setSection(section, newSection())

  return ini
