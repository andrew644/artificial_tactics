import team

type Unit* = ref object of RootObj
  name*: string
  cost*: int
  attack*: int
  defense*: int
  damage*: int
  speed*: int
  range*: int
  attacked*: bool
  moved*: bool
  deployed*: bool
  team*: Team
# unitType - has unit name and special power info

proc makeBasicUnit*(): Unit =
   var unit = Unit()
   unit.name = "basic"
   unit.cost = 1
   unit.attack = 1
   unit.defense = 1
   unit.damage = 0
   unit.speed = 1
   unit.range = 1
   return unit

proc isDead*(unit: Unit): bool =
  return unit.damage >= unit.defense
