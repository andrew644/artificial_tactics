import unit

const mapWidth = 20
const mapHeight = 10

type
  UnitMap = array[mapHeight, array[mapWidth, Unit]]
  Map* = ref object
    unitMap: UnitMap
  Point* = object
    x: int
    y: int

proc newPoint*(x: int, y: int): Point =
  return Point(x: x, y: y)
    
proc insideMap*(map: Map, x: int, y: int): bool =
  return x >= 0 and y >= 0 and x < mapWidth and y < mapHeight

proc getMapWidth*(map: Map): int =
   return mapWidth

proc getMapHeight*(map: Map): int =
   return mapHeight

proc getUnit*(map: Map, x: int, y: int): Unit =
  if not map.insideMap(x, y):
    return nil
  return map.unitMap[y][x]

proc putUnit*(map: Map, unit: Unit, x: int, y: int): bool =
  if not map.insideMap(x, y):
    return false
  if map.unitMap[y][x] != nil:
    # There is already something here
    return false

  map.unitMap[y][x] = unit
  return true

proc removeUnit*(map: Map, x: int, y: int): bool =
  if not map.insideMap(x, y):
    return false
  if map.unitMap[y][x] == nil:
    # There is nothing to remove at this space
    return false

  map.unitMap[y][x] = nil
  return true

proc moveUnit*(map: Map, fromX: int, fromY: int, toX: int, toY: int): bool =
  if not map.insideMap(fromX, fromY) or not map.insideMap(toX, toY):
    return false

  let unit = map.getUnit(fromX, fromY)
  if unit == nil:
    # There is not unit to move
    return false

  if not map.putUnit(unit, toX, toY):
    # The location we are trying to move to is not valid
    return false

  # If we get here we should always succeed return true.
  # If this fails we could be in an inconsistent state with
  # a unit in two locations at once.
  return map.removeUnit(fromX, fromY)
