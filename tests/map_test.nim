import unittest, ../src/map, ../src/unit

suite "map tests - empty map":
  setup:
    let
      emptyMap = Map()

  test "get map height":
    check emptyMap.getMapHeight == 10

  test "get map widht":
    check emptyMap.getMapWidth == 20

  test "get unit on empty map":
    check emptyMap.getUnit(0, 0) == nil

  test "get unit from off the edge of the map":
    check emptyMap.getUnit(-1, -1) == nil
    
suite "map tests - manipulate unit on empty map":
  proc isMapEmpty(map: Map): bool =
    for y in 0..map.getMapHeight():
      for x in 0..map.getMapWidth():
        if map.getUnit(x, y) != nil:
          return false
    return true

  setup:
    let
      emptyMap = Map()
      unit = Unit()

  test "put unit on empty map":
    check:
      emptyMap.putUnit(unit, 0, 0) == true
      emptyMap.getUnit(0, 0) == unit

  test "remove unit from map":
    check:
      emptyMap.putUnit(unit, 0, 0) == true
      emptyMap.removeUnit(0, 0) == true
      emptyMap.getUnit(0, 0) == nil

  test "move unit on map":
    check:
      emptyMap.putUnit(unit, 0, 0) == true
      emptyMap.moveUnit(0, 0, 1, 1) == true
      emptyMap.getUnit(0, 0) == nil
      emptyMap.getUnit(1, 1) == unit

  test "move unit off of the map":
    check:
      emptyMap.putUnit(unit, 0, 0) == true
      emptyMap.moveUnit(0, 0, -1, 1) == false
      emptyMap.getUnit(0, 0) == unit
      emptyMap.getUnit(1, 0) == nil
      emptyMap.getUnit(0, 1) == nil
      emptyMap.getUnit(1, 1) == nil

  test "put unit off the left of the map":
    check:
      emptyMap.putUnit(unit, -1, 0) == false
      isMapEmpty(emptyMap) == true

  test "put unit off the top of the map":
    check:
      emptyMap.putUnit(unit, 0, -5) == false
      isMapEmpty(emptyMap) == true

  test "put unit off the bottom of the map":
    check:
      emptyMap.putUnit(unit, 0, emptyMap.getMapHeight()) == false
      isMapEmpty(emptyMap) == true

  test "put unit off the top of the map":
    check:
      emptyMap.putUnit(unit, emptyMap.getMapWidth(), 0) == false
      isMapEmpty(emptyMap) == true
