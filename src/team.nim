type Team* = enum blue, red
               
proc getTeamName*(team: Team): string =
  if team == red:
    return "red"
  else:
    return "blue"
