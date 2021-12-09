# Package

version       = "0.1.0"
author        = "Nikita Bliznyuk"
description   = "Lombok for nim!"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.0"


proc executeTest(file: string) =
    exec ("nim c -r " & file)


task runtest, "Run particular test":
    for i in 9 .. paramCount(): executeTest(paramStr(i))


task build_debug, "Build nimbok":
    exec ("nim c src/nimbok.nim")
