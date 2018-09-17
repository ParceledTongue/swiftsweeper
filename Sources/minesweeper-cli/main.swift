import Foundation

// MARK: Setup

// var g = Game.newCircular(radius: 8, mines: 35)
var g = Game.newBeginner()
var r = Renderer()

let blankLines = String(repeating: "\n", count: 20)
func refresh() {
  print(blankLines + r.render(g))
}

let stdIn = FileHandle.standardInput
let originalTerm = enableRawMode(fileHandle: stdIn)

// MARK: Command Dicts

let vimStyleCommandDict: [UInt8: () -> Void] = [
  0x6b: { g.moveUp() },    // k
  0x6c: { g.moveRight() }, // l
  0x6a: { g.moveDown() },  // j
  0x68: { g.moveLeft() },  // h
  0x66: { g.reveal() },    // f
  0x64: { g.flag() }       // d
]

let wasdStyleCommandDict: [UInt8: () -> Void] = [
  0x77: { g.moveUp() },    // w
  0x64: { g.moveRight() }, // d
  0x73: { g.moveDown() },  // s
  0x61: { g.moveLeft() },  // a
  0x2e: { g.reveal() },    // .
  0x2f: { g.flag() }       // /
]

// MARK: Main Loop

refresh()
var char: UInt8 = 0
while read(stdIn.fileDescriptor, &char, 1) == 1 {
    // detect EOF (Ctrl+D)
    if char == 0x04 { break }
    // run command if we recognize the key
    if let cmd = wasdStyleCommandDict[char] {
      cmd()
      refresh()
    }
    // quit if the game is over
    if g.state == .won || g.state == .lost {
      // print one last time without the cursor
      r.cursorMode = .noCursor
      refresh()
      break
    }
}

// It would be also nice to disable raw input when exiting the app.
restoreRawMode(fileHandle: stdIn, originalTerm: originalTerm)

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
