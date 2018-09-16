import Foundation

var g = Game.newBeginner()
let r = Renderer()

func refresh() {
  for _ in 1...30 {
    print()
  }
  print(r.render(g))
}

let commandDict = [
  Character("w"): { g.moveUp() },
  Character("d"): { g.moveRight() },
  Character("s"): { g.moveDown() },
  Character("a"): { g.moveLeft() },
  Character("r"): { g.reveal() },
  Character("f"): { g.flag() }
]

refresh()
while g.state != .won && g.state != .lost {
  if let commands = readLine() {
    for commandChar in commands {
      if let cmd = commandDict[commandChar] {
        cmd()
      }
    }
  }
  refresh()
}

// watch the computer play a randomized game
/*
let actions: [(name: String, do: () -> Void)] = [
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
  action.do()
  refresh()
  moveNum += 1
  print(String(moveNum) + ") " + action.name)
}
*/
