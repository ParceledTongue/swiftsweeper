import Rainbow

struct Grid: Sequence {
  let width: Int
  let height: Int
  let allPositions: [Position]
  private var grid: [[Bool]]

  typealias Iterator = IndexingIterator<[Grid.Position]>

  func makeIterator() -> Grid.Iterator {
    return allPositions.makeIterator()
  }

  struct Position: Equatable, Hashable {
    let row: Int
    let col: Int

    init(_ row: Int, _ col: Int) {
      self.row = row
      self.col = col
    }
  }

  init(width: Int, height: Int) {
    self.width = width
    self.height = height
    // array of all positions for sequencing
    // (left to right and then top to bottom)
    let allRows = Array(0..<height)
    let allCols = Array(0..<width)
    allPositions = allRows.flatMap { r in
      allCols.map { c in Position(r, c) }
    }
    // start with an empty grid
    let emptyRow = Array(repeating: false, count: width)
    self.grid = Array(repeating: emptyRow, count: height)
  }

  mutating func clear() {
    for p in self {
      setMine(p, false)
    }
  }

  mutating func populate(mines: Int, start: Position) {
    clear()
    let invalidPositions = [start] + neighborsOf(start)
    var openPositions = Set(self).subtracting(invalidPositions)
    assert(mines <= openPositions.count, "more mines than spaces")

    for _ in 0..<mines {
      let minePosition = openPositions.randomElement()!
      setMine(minePosition, true)
      openPositions.remove(minePosition)
    }
  }

  func countNeighbors(_ p: Position) -> Int {
    return neighborsOf(p).filter { isMine($0) }.count
  }

  func isMine(_ p: Position) -> Bool {
    return grid[p.row][p.col]
  }

  private mutating func setMine(_ p: Position, _ state: Bool) {
    grid[p.row][p.col] = state
  }

  private func neighborsOf(_ p: Position) -> [Position] {
    let neighborRows = ((p.row - 1)...(p.row + 1))
      .clamped(to: 0...(height - 1)) // don't include out-of-bounds rows
    let neighborCols = ((p.col - 1)...(p.col + 1))
      .clamped(to: 0...(width - 1)) // don't include out-of-bounds cols
    return neighborRows.flatMap { r in
      neighborCols.map { c in Position(r, c) }
    }.filter { $0 != p } // the position isn't its own neighbor
  }

  // TODO move everything below to a renderer

  private struct DisplayStrings {
    static let bomb = "*".lightBlack.bold
    static let space = "·"
  }

  func prettyPrint() {
    printWith {
      return isMine($0) ? DisplayStrings.bomb : DisplayStrings.space
    }
  }

  func prettyPrintWithHints() {
    printWith {
      if isMine($0) {
        return DisplayStrings.bomb
      } else {
        let neighborCount = countNeighbors($0)
        return neighborCount == 0
          ? DisplayStrings.space
          : Grid.coloredNumberString(neighborCount)
      }
    }
  }

  private func printWith(renderer: (Position) -> String) {
    for p in self {
      let endOfRow = (p.col == width - 1)
      print(renderer(p), terminator: endOfRow ? "\n" : " ")
    }
  }

  private static func coloredNumberString(_ num: Int) -> String {
    let str = String(num)
    switch num {
    case 1: return str.lightBlue
    case 2: return str.green
    case 3: return str.lightRed
    case 4: return str.blue
    case 5: return str.red
    case 6: return str.cyan
    case 7: return str.black
    case 8: return str.lightBlack
    default: return str
    }
  }
}
