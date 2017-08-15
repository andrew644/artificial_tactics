import game, team
import jester, asyncdispatch, json, strutils

#TODO Warning: 'matchIter' is not GC-safe as it accesses 'g' which is a global using GC'ed memory
var g = makeGame()

routes:
  post "/deployUnit":
    let params = request.params

    try:
      let team = parseTeam(params["team"])
      let unitIndex = parseInt(params["unitIndex"])
      let x = parseInt(params["x"])
      let y = parseInt(params["y"])
      let success = g.deployUnit(team, unitIndex, x, y)
      if success:
        resp Http200, "OK"
      else:
        resp Http400, "Invalid params"
    except:
      resp Http400, "Invalid params"
    
  get "/validDeployments":
    let params = request.params
    try:
      let team = parseTeam(params["team"])
      let unitIndex = parseInt(params["unitIndex"])
      let deployments = g.getValidDeployments(team, unitIndex)
      resp Http200, deployments
    except:
      resp Http400, "Invalid params"


runForever()
