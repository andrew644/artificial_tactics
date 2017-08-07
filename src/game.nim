import unit, player, map

type
  Game* = ref object
    players: array[Team, Player]
    map: Map
    turn: int

proc makeGame*(): Game =
  var game = Game()
  game.players[blue] = makeBasicBluePlayer()
  game.players[red] = makeBasicRedPlayer()
  game.map = Map()
  game.turn = 0


proc getUnitFromMap*(game: Game, x: int, y: int): string =
  return "{}"

proc getUnitFromHand*(game: Game, team: Team, unitIndex: int): string =
  return "{}"

proc getGameState*(game: Game): string =
  # json
  # location and team of each unit
  # which units are in hand and their deploy status
  # turn number
  # build points
  # victory points
  return "{}"

proc isValidMove*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  return false
  
proc getValidMoves*(game: Game, team: Team, x: int, y: int): string = 
  return "{}" 

proc isValidAttack*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  return false
  
proc getValidAttacks*(game: Game, team: Team, x: int, y: int): string =
  return "{}"

proc isValidDeployment*(game: Game, team: Team, unitIndex: int, x: int, y: int): bool = 
  return false
  
proc getValidDeployments*(game: Game, team: Team, unitIndex: int): string =
  return "{}"

  
proc deployUnit*(game: Game, team: Team, unitIndex: int, x: int, y: int): bool =
  if not game.isValidDeployment(team, unitIndex, x, y):
    return false
  
  var unit = game.players[team].getUnit(unitIndex)
  let success = game.map.putUnit(unit, x, y)
  if success:
    unit.deployed = true
  return success

proc moveUnit*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  return false
  
proc attackUnit*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
#  defendingUnit.damage += attackingUnit.attack
#  if not defendingUnit.isDead():
#    attackingUnit.damage += defendingUnit.attack

  return false
  
proc endTurn*(game: Game, team: Team): bool =
  return false
