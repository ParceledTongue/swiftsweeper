import Foundation

// watch the computer play a randomized circular game

var g = Game.newCircular(radius: 8, mines: 35)

func refresh() {
  for _ in 1...30 {
    print()
  }
  printGameWithFlip(g)
}

let actions: [(name: String, move: () -> Void)] = [
  ("Up", { g.moveUp() }),
  ("Right", { g.moveRight() }),
  ("Down", { g.moveDown() }),
  ("Left", { g.moveLeft() }),
  ("Reveal", { g.reveal() }),
  ("Flag", { g.flag() })
]

refresh()
var moveNum = 0
while g.state != .lost {
  sleep(UInt32(1))
  let action = actions.randomElement()!
  action.move()
  refresh()
  moveNum += 1
  print(String(moveNum) + ") " + action.name)
}
