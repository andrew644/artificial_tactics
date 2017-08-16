import unit, player, team, map
import json
import marshal

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
  if unit == nil:
    return "{}"
  else:
    return getUnitJson(unit).pretty()

proc getUnitFromHand*(game: Game, team: Team, unitIndex: int): string =
  let unit = game.players[team].getUnit(unitIndex)
  if unit == nil:
    return "{}"
  else:
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

#TODO write unit test
proc isValidMove*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  if not (game.map.insideMap(fromX, fromY) and game.map.insideMap(toX, toY)):
    return false

  #TODO take unit speed into account
  var north = fromY == toY + 1 and fromX == toX
  var south = fromY == toY - 1 and fromX == toX
  var east = fromY == toY and fromX == toX - 1
  var west = fromY == toY and fromX == toX + 1
  if not (north or south or east or west):
    return false

  let unit = game.map.getUnit(fromX, fromY)
  if unit == nil or unit.team != team or unit.moved:
    return false
  
  if game.map.getUnit(toX, toY) != nil:
    return false

  return true
  
#TODO write unit test
proc getValidMoves*(game: Game, team: Team, x: int, y: int): string = 
  var points = newSeq[Point]()

  #TODO take unit speed into account
  if game.isValidMove(team, x, y, x, y - 1):
    points.add(newPoint(x, y - 1))
  if game.isValidMove(team, x, y, x, y + 1):
    points.add(newPoint(x, y + 1))
  if game.isValidMove(team, x, y, x + 1, y):
    points.add(newPoint(x + 1, y))
  if game.isValidMove(team, x, y, x - 1, y):
    points.add(newPoint(x - 1, y))

  return $$points 

#TODO write unit tests
proc isValidAttack*(game: Game, team: Team, fromX: int, fromY: int, toX: int, toY: int): bool =
  if not (game.map.insideMap(fromX, fromY) and game.map.insideMap(toX, toY)):
    return false

  #TODO take unit range into account
  var north = fromY == toY + 1 and fromX == toX
  var south = fromY == toY - 1 and fromX == toX
  var east = fromY == toY and fromX == toX - 1
  var west = fromY == toY and fromX == toX + 1
  if not (north or south or east or west):
    return false

  let attacker = game.map.getUnit(fromX, fromY)
  if attacker == nil or attacker.team != team or attacker.attacked:
    return false

  let defender = game.map.getUnit(toX, toY)
  if defender == nil or defender.team == team:
    return false

  return true
  
#TODO write unit tests
proc getValidAttacks*(game: Game, team: Team, x: int, y: int): string =
  var points = newSeq[Point]()

  #TODO take unit range into account
  if game.isValidAttack(team, x, y, x, y - 1):
    points.add(newPoint(x, y - 1))
  if game.isValidAttack(team, x, y, x, y + 1):
    points.add(newPoint(x, y + 1))
  if game.isValidAttack(team, x, y, x + 1, y):
    points.add(newPoint(x + 1, y))
  if game.isValidAttack(team, x, y, x - 1, y):
    points.add(newPoint(x - 1, y))

  return $$points

#TODO write unit test
proc isValidDeployment*(game: Game, team: Team, unitIndex: int, x: int, y: int): bool = 
  let player = game.players[team]
  let unit = player.getUnit(unitIndex)
  if player.getBuildPoints() < unit.cost:
    return false
  
  if unit == nil or unit.deployed:
    return false

  if y < 0 or y >= game.map.getMapHeight():
    return false

  if team == red:
    if x != 0:
      return false
        
  if team == blue:
    if x != game.map.getMapWidth - 1:
      return false 

  if game.map.getUnit(x, y) != nil:
    return false

  return true
  
proc getValidDeployments*(game: Game, team: Team, unitIndex: int): string =
  var x = 0
  if team == blue:
    x = game.map.getMapWidth() - 1
    
  var points = newSeq[Point]()
    
  let height = game.map.getMapHeight()
  for y in 0..height - 1:
    if game.isValidDeployment(team, unitIndex, x, y):
        points.add(newPoint(x, y))
  return $$points
  
proc deployUnit*(game: Game, team: Team, unitIndex: int, x: int, y: int): bool =
  if not game.isValidDeployment(team, unitIndex, x, y):
    return false
  
  var unit = game.players[team].getUnit(unitIndex)
  let player = game.players[team]
  let success = game.map.putUnit(unit, x, y)
  if success:
    unit.deployed = true
    discard player.payBuildPoints(unit.cost)
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
  
proc startTurn(game: Game, team: Team) =
  var player = game.players[team]
  player.refreshUnits()
  discard player.accumulateBuildPoints()

proc endTurn*(game: Game, team: Team): bool =
  if game.activeTeam != team:
    return false
    
  game.turn += 1
  if game.activeTeam == red:
    game.activeTeam = blue
  else:
    game.activeTeam = red

  game.startTurn(team)

  return true
