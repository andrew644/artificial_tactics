import unittest, ../src/game, ../src/team
import json

suite "game tests - turn order":
  setup:
    let
      game = makeGame()

  test "starting turn team":
    let jsonNode = parseJson(game.getActiveTeam())
    check:
      jsonNode.kind == JObject
      jsonNode["activeTeam"].kind == JString
      jsonNode["activeTeam"].getStr() == "red"

  test "second turn team":
    check game.endTurn(red) == true
    let jsonNode = parseJson(game.getActiveTeam())
    check:
      jsonNode.kind == JObject
      jsonNode["activeTeam"].kind == JString
      jsonNode["activeTeam"].getStr() == "blue"

  test "third turn team":
    check:
      game.endTurn(red) == true
      game.endTurn(blue) == true
    let jsonNode = parseJson(game.getActiveTeam())
    check:
      jsonNode["activeTeam"].getStr() == "red"

suite "game tests - json unit getter":
  setup:
    let
      game = makeGame()
    discard game.deployUnit(red, 0, 0, 0)

  test "red player has basic unit in hand and the unit is deployed":
    let jsonNode = parseJson(game.getUnitFromHand(red, 0))
    check:
      jsonNode["name"].getStr() == "basic"
      jsonNode["cost"].getNum() == 1
      jsonNode["attack"].getNum() == 1
      jsonNode["defense"].getNum() == 1
      jsonNode["damage"].getNum() == 0
      jsonNode["speed"].getNum() == 1
      jsonNode["range"].getNum() == 1
      jsonNode["attacked"].getBVal() == false
      jsonNode["moved"].getBVal() == false
      jsonNode["deployed"].getBVal() == true
      jsonNode["team"].getStr() == "red"

  test "red player has basic unit on field":
    let jsonNode = parseJson(game.getUnitFromMap(0, 0))
    check:
      jsonNode["name"].getStr() == "basic"
      jsonNode["cost"].getNum() == 1
      jsonNode["attack"].getNum() == 1
      jsonNode["defense"].getNum() == 1
      jsonNode["damage"].getNum() == 0
      jsonNode["speed"].getNum() == 1
      jsonNode["range"].getNum() == 1
      jsonNode["attacked"].getBVal() == false
      jsonNode["moved"].getBVal() == false
      jsonNode["deployed"].getBVal() == true
      jsonNode["team"].getStr() == "red"

suite "game tests - empty map":
  setup:
    let
      game = makeGame()

  test "list valid deployments for red team":
    let jsonNode = parseJson(game.getValidDeployments(red, 0))
    check:
      jsonNode[0]["x"].getNum() == 0
      jsonNode[0]["y"].getNum() == 0
      jsonNode[1]["x"].getNum() == 0
      jsonNode[1]["y"].getNum() == 1
      jsonNode[9]["x"].getNum() == 0
      jsonNode[9]["y"].getNum() == 9
    
suite "game tests - valid moves":
  setup:
    let
      game = makeGame()
    discard game.deployUnit(red, 0, 0, 0)

  test "list valid moves for unit in the top left corner":
    let jsonNode = parseJson(game.getValidMoves(red, 0, 0))
    check:
      jsonNode[0]["x"].getNum() == 0
      jsonNode[0]["y"].getNum() == 1
      jsonNode[1]["x"].getNum() == 1
      jsonNode[1]["y"].getNum() == 0
    
