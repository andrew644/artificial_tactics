# Package

version           = "0.1"
author            = "andrew644"
description       = "A turn based tactics game"
license           = "MIT"

srcDir            = "src"
bin               = @["artificial_tactics"]


# Dependencies
requires "nim >= 0.16.0"
requires "jester >= 0.1.1"

task tests, "Run unit tests":
  exec "nim c -r tests/all"
