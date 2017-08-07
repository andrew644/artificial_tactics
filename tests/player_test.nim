import unittest, ../src/player, ../src/unit

suite "player tests - empty hand":
  setup:
    let
      emptyHandPlayer = Player()

  test "get hand size":
    check emptyHandPlayer.getHandSize() == 10

  test "get unit from empty hand":
    check emptyHandPlayer.getUnit(0) == nil

  test "get unit from empty hand with invalid index":
    check emptyHandPlayer.getUnit(-1) == nil

  test "score 1 point":
    check emptyHandPlayer.scorePoints(1) == 1

  test "score 10 point":
    check emptyHandPlayer.scorePoints(10) == 10
