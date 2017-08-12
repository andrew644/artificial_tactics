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

proc payBuildPoints*(player: Player, payment: int): int =
  player.buildPoints -= payment
  return player.buildPoints
  
proc getBuildPoints*(player: Player): int =
  return player.buildPoints


proc makeBasicBluePlayer*(): Player =
  var player = Player()
  for i in 0..handSize - 1:
    let unit = makeBasicUnit()
    unit.team = blue
    discard player.putUnit(unit, i)
  player.team = blue               
  player.buildPoints = 1
  return player

proc makeBasicRedPlayer*(): Player =
  var player = Player()
  for i in 0..handSize - 1:
    let unit = makeBasicUnit()
    unit.team = red
    discard player.putUnit(unit, i)
  player.team = red               
  player.buildPoints = 1
  return player

proc refreshUnits*(player: Player) =
  for i in 0..handSize - 1:
    player.hand[i].attacked = false
    player.hand[i].moved = false
    
