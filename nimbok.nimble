# Package

version       = "0.0.3"
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


task build_debug, "Build debug nimbok":
    exec ("nim c src/nimbok.nim")


task build_release, "Build release nimbok":
    exec ("nim c -d:release src/nimbok.nim")
