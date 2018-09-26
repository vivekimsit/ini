import ini, unittest, sets

suite "ini":
  test "should parse ini":
    var parsedIni = parse("tests/fixtures/foo.ini")
    check:
      parsedIni.contains("general") == true
      parsedIni.len() == 1
      parsedIni.sections().len == 1
