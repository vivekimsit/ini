import ini

var result = parse("tests/fixtures/foo.ini")

doAssert(result["appname"])
