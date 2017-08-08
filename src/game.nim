import unit, player, team, map
import json

type
  Game* = ref object
    players: array[Team, Player]
    map: Map
    turn: int
    activeTeam: Team

proc makeGame*(): Game =
  var game = Game()
  game.players[blue] = makeBasicBluePlayer()
  game.players[red] = makeBasicRedPlayer()
  game.map = Map()
  game.turn = 0
  game.activeTeam = red
  return game

proc getUnitJson(unit: Unit): JsonNode =
  var json = %*
    {
      "name": unit.name,
      "cost": unit.cost,
      "attack": unit.attack,
      "defense": unit.defense,
      "damage": unit.damage,
      "speed": unit.speed,
      "range": unit.range,
      "attacked": unit.attacked,
      "moved": unit.moved,
      "deployed": unit.deployed,
      "team": unit.team.getTeamName()
    }
  return json
  
proc getUnitFromMap*(game: Game, x: int, y: int): string =
  let unit = game.map.getUnit(x, y)
  return getUnitJson(unit).pretty()

proc getUnitFromHand*(game: Game, team: Team, unitIndex: int): string =
  let unit = game.players[team].getUnit(unitIndex)
  return getUnitJson(unit).pretty()

#TODO
proc getGameState*(game: Game): string =
  # json
  # location and team of each unit
  # which units are in hand and their deploy status
  # turn number
  # build points
  # victory points
  return "{}"
  
proc getActiveTeam*(game: Game): string =
  var json = %*
    {
      "activeTeam": game.activeTeam.getTeamName()
    }
  return json.pretty()

#TODO
proc isValidMove*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  return false
  
#TODO
proc getValidMoves*(game: Game, team: Team, x: int, y: int): string = 
  return "{}" 

#TODO
proc isValidAttack*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  return false
  
#TODO
proc getValidAttacks*(game: Game, team: Team, x: int, y: int): string =
  return "{}"

#TODO
proc isValidDeployment*(game: Game, team: Team, unitIndex: int, x: int, y: int): bool = 
  return true
  
#TODO
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

#TODO write unit test
proc moveUnit*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  if not game.isValidMove(team, fromX, fromY, toX, toY):
    return false
    
  return game.map.moveUnit(fromX, fromY, toX, toY);
  
#TODO write unit test
proc attackUnit*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  if not game.isValidAttack(team, fromX, fromY, toX, toY):
    return false
    
  var attackingUnit = game.map.getUnit(fromX, fromY)
  var defendingUnit = game.map.getUnit(toX, toY)
  defendingUnit.damage += attackingUnit.attack
  if not defendingUnit.isDead():
    attackingUnit.damage += defendingUnit.attack

  return true
  
proc endTurn*(game: Game, team: Team): bool =
  if game.activeTeam != team:
    return false
  
  game.turn += 1
  if game.activeTeam == red:
    game.activeTeam = blue
  else:
    game.activeTeam = red
  return true
