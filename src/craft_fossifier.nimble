# Package

version       = "2.0.0"
author        = "FOSSifier Contributors"
description   = "Android debloat tool - Generate portable debloat scripts"
license       = "MIT"
srcDir        = "src"
bin           = @["craft_fossifier"]

# Dependencies

requires "nim >= 1.6.0"

# Tasks

task build, "Build the project":
  exec "nim c -d:release -o:craft_fossifier src/craft_fossifier.nim"

task debug, "Build with debug info":
  exec "nim c -o:craft_fossifier src/craft_fossifier.nim"

task clean, "Clean build artifacts":
  exec "rm -f craft_fossifier"
  exec "rm -rf nimcache"