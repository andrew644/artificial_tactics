# Package

version           = "0.1"
author            = "andrew644"
description       = "A turn based tactics game"
license           = "MIT"

srcDir            = "src"
bin               = @["artificial_tactics"]


# Dependencies

task tests, "Run unit tests":
  exec "nim c -r tests/all"
