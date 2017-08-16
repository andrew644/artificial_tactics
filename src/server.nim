import game, team
import jester, asyncdispatch, json, strutils

#TODO Warning: 'matchIter' is not GC-safe as it accesses 'g' which is a global using GC'ed memory
var g = makeGame()

routes:
    
  get "/validDeployments":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let unitIndex = parseInt(params["unit"])
      let deployments = g.getValidDeployments(team, unitIndex)
      resp(Http200, deployments)
    except:
      resp(Http400, "Invalid params")

  get "/unitFromMap":
    let params = request.params
    try:
      let x = parseInt(params["x"])
      let y = parseInt(params["y"])
      let unit = g.getUnitFromMap(x, y)
      resp(Http200, unit)
    except:
      resp(Http400, "Invalid params")

  get "/unitFromHand":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let unitIndex = parseInt(params["unit"])
      let unit = g.getUnitFromHand(team, unitIndex)
      resp(Http200, unit)
    except:
      resp(Http400, "Invalid params")

  get "/getActiveTeam":
    resp(Http200, g.getActiveTeam())

  get "/isValidMove":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let fromX = parseInt(params["fromX"])
      let fromY = parseInt(params["fromY"])
      let toX = parseInt(params["toX"])
      let toY = parseInt(params["toY"])
      let valid = g.isValidMove(team, fromX, fromY, toX, toY)
      let json = %* { "valid": valid }
      resp(Http200, json.pretty())
    except:
      resp(Http400, "Invalid params")

  get "/validMoves":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let x = parseInt(params["x"])
      let y = parseInt(params["y"])
      let moves = g.getValidMoves(team, x, y)
      resp(Http200, moves)
    except:
      resp(Http400, "Invalid params")

  get "/isValidAttack":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let fromX = parseInt(params["fromX"])
      let fromY = parseInt(params["fromY"])
      let toX = parseInt(params["toX"])
      let toY = parseInt(params["toY"])
      let valid = g.isValidAttack(team, fromX, fromY, toX, toY)
      let json = %* { "valid": valid }
      resp(Http200, json.pretty())
    except:
      resp(Http400, "Invalid params")

  get "/validAttacks":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let x = parseInt(params["x"])
      let y = parseInt(params["y"])
      let attacks = g.getValidAttacks(team, x, y)
      resp(Http200, attacks)
    except:
      resp(Http400, "Invalid params")

  get "/isValidDeployment":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let unitIndex = parseInt(params["unit"])
      let x = parseInt(params["x"])
      let y = parseInt(params["y"])
      let valid = g.isValidDeployment(team, unitIndex, x, y)
      let json = %* { "valid": valid }
      resp(Http200, json.pretty())
    except:
      resp(Http400, "Invalid params")

  get "/validDeployments":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let unitIndex = parseInt(params["unit"])
      let deployments = g.getValidDeployments(team, unitIndex)
      resp(Http200, deployments)
    except:
      resp(Http400, "Invalid params")
      
  post "/deployUnit":
    let params = request.params

    try:
      let team = parseTeam(params["team"])
      let unitIndex = parseInt(params["unit"])
      let x = parseInt(params["x"])
      let y = parseInt(params["y"])
      let success = g.deployUnit(team, unitIndex, x, y)
      if success:
        resp(Http200, "OK")
      else:
        resp(Http400, "Invalid params")
    except:
      resp(Http400, "Invalid params")

  post "/moveUnit":
    let params = request.params

    try:
      let team = parseTeam(params["team"])
      let fromX = parseInt(params["fromX"])
      let fromY = parseInt(params["fromY"])
      let toX = parseInt(params["toX"])
      let toY = parseInt(params["toY"])
      let success = g.moveUnit(team, fromX, fromY, toX, toY)
      if success:
        resp(Http200, "OK")
      else:
        resp(Http400, "Invalid params")
    except:
      resp(Http400, "Invalid params")

  post "/attackUnit":
    let params = request.params

    try:
      let team = parseTeam(params["team"])
      let fromX = parseInt(params["fromX"])
      let fromY = parseInt(params["fromY"])
      let toX = parseInt(params["toX"])
      let toY = parseInt(params["toY"])
      let success = g.attackUnit(team, fromX, fromY, toX, toY)
      if success:
        resp(Http200, "OK")
      else:
        resp(Http400, "Invalid params")
    except:
      resp(Http400, "Invalid params")
      
  post "/endTurn":
    let params = request.params

    try:
      let team = parseTeam(params["team"])
      let success = g.endTurn(team)
      if success:
        resp(Http200, "OK")
      else:
        resp(Http400, "Invalid params")
    except:
      resp(Http400, "Invalid params")

runForever()
