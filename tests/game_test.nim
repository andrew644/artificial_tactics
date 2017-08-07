import unittest, ../src/game

#TODO chnage name
suite "game tests - combat":
  setup:
    let
      game = makeGame()
      
  test "test1":
    check:
      game.getGameState() == "{}"
      #TODO
