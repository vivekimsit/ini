# parse_ini
# Copyright Vivek Poddar
# A new awesome nimble package
import sets, strutils, tables

type Section = ref object
    properties: Table[string, string]

type Ini = ref object
    sections: Table[string, Section]

type ParserState = enum
    readSection, readKV

proc newIni*(): Ini =
  let ini = Ini()
  ini.sections = initTable[string, Section]()
  return ini

proc newSection*(): Section =
  var s = Section()
  s.properties = initTable[string, string]()
  return s

proc contains*(this: Ini, section: string): bool =
  return true

proc len*(this: Ini): int =
  return this.sections.len

proc setProperty(this: Section, name: string, value: string) =
  this.properties[name] = value

proc getSection*(this: Ini, name: string): Section =
  return this.sections.getOrDefault(name, newSection())

proc getProperty*(this: Section, name: string): string =
  return this.properties.getOrDefault(name)

proc setSection(this: Ini, name: string, section: Section) =
  this.sections[name] = section

proc setProperty(this: Ini, section: string, key: string, val: string) =
  if this.contains(section):
    this.sections[section].setProperty(key, val)
  else:
    raise newException(ValueError, "Ini doesn't have section " & section)

proc parse*(path: string): Ini =
  let file = open(path)
  let ini = newIni()
  var state: ParserState = readSection
  var currentSectionName: string = ""
  var currentSection: Section = newSection()
  for line in file.lines():
    if line.strip() == "" or line.startsWith(";") or line.startsWith("#"):
      continue
    if line.startsWith("[") and line.endsWith("]"):
      state = readSection
    if state == readSection:
      currentSectionName = line[1..<line.len - 1]
      ini.setSection(currentSectionName, currentSection)
      state = readKV
      continue
    if state == readKV:
      let parts = line.split({'='})
      if len(parts) == 2:
        let key = parts[0].strip()
        let val = parts[1].strip()
        ini.setProperty(currentSectionName, key, val)

  return ini
