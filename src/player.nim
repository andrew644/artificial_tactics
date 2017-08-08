import unit, team

const handSize = 10
const buildPointsPerTurn = 1

type
  Player* = ref object
    hand: array[handSize, Unit]
    victoryPoints: int
    buildPoints: int
    team: Team
               
proc getHandSize*(player: Player): int =
  return handSize

proc getUnit*(player: Player, unitIndex: int): Unit =
  if unitIndex < 0 or unitIndex >= handSize:
    return nil
  return player.hand[unitIndex]

proc putUnit*(player: Player, unit: Unit, unitIndex: int): bool =
  if unitIndex < 0 or unitIndex >= handSize:
    return false
  player.hand[unitIndex] = unit
  return true

proc scorePoints*(player: Player, points: int): int =
  player.victoryPoints += points
  return player.victoryPoints

proc accumulateBuildPoints*(player: Player): int =
  player.buildPoints += buildPointsPerTurn
  return player.buildPoints



proc makeBasicBluePlayer*(): Player =
  var player = Player()
  for i in 0..handSize:
    let unit = makeBasicUnit()
    unit.team = blue
    discard player.putUnit(unit, i)
  player.team = blue               
  return player

proc makeBasicRedPlayer*(): Player =
  var player = Player()
  for i in 0..handSize:
    let unit = makeBasicUnit()
    unit.team = red
    discard player.putUnit(unit, i)
  player.team = red               
  return player
