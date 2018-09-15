struct Game {
  var grid: Grid
  let mines: Int
  var cursorAt: Coord
  var revealed: Set<Coord>
  var flagged: Set<Coord>

  private init(grid: Grid, mines: Int, cursorStart: Coord) {
    self.grid = grid
    self.mines = mines
    self.cursorAt = cursorStart
    self.revealed = Set()
    self.flagged = Set()
  }

  // MARK: Game State

  enum State {
    case new, playing, won, lost
  }

  var state: State {
    if revealed.isEmpty {
      // revealed nothing
      return .new
    } else if revealed.contains(where: { grid[$0] }) {
      // revealed a mine
      return .lost
    } else {
      let allSafe = grid.coords.filter { !grid[$0] }
      return revealed == allSafe
        // revealed all safe spots
        ? .won
        // revealed some safe spots
        : .playing
    }
  }

  // MARK: Cursor Movement

  mutating func moveUp() {
    moveCursorIfInBounds(to: cursorAt.north)
  }

  mutating func moveRight() {
    moveCursorIfInBounds(to: cursorAt.east)
  }

  mutating func moveDown() {
    moveCursorIfInBounds(to: cursorAt.south)
  }

  mutating func moveLeft() {
    moveCursorIfInBounds(to: cursorAt.west)
  }

  private mutating func moveCursorIfInBounds(to: Coord) {
    if grid.coords.contains(to) {
      cursorAt = to
    }
  }

  // MARK: Revealing

  mutating func reveal() {
    if flagged.contains(cursorAt) {
      return // never reveal a flagged spot
    }

    if state == .new {
      // populate the grid if this is our first reveal
      grid.populateRandom(mines: mines, start: cursorAt)
    }

    reveal(cursorAt)
    // if you've already flagged the right number of a coord's neighbors,
    // you can reveal all the rest by revealing the coord itself
    let neighbors = grid.neighborsOf(cursorAt)
    let flaggedNeighborCount = neighbors.filter { flagged.contains($0) }.count
    if grid.adjacentMines(cursorAt) == flaggedNeighborCount {
      for neighbor in neighbors {
        reveal(neighbor)
      }
    }
  }

  private mutating func reveal(_ c: Coord) {
    revealed.insert(c)

    if grid.adjacentMines(c) == 0 {
      for neighbor in grid.neighborsOf(c) {
        reveal(neighbor)
      }
    }
  }

  // MARK: Flagging

  mutating func flag() {
    if flagged.contains(cursorAt) {
      flagged.remove(cursorAt)
    } else {
      flagged.insert(cursorAt)
    }
  }

  // MARK: Game Initializers

  static func newBeginner() -> Game {
    return newRectangular(width: 8, height: 8, mines: 10)
  }

  static func newIntermediate() -> Game {
    return newRectangular(width: 16, height: 16, mines: 40)
  }

  static func newExpert() -> Game {
    return newRectangular(width: 24, height: 24, mines: 99)
  }

  static func newRectangular(width: Int, height: Int, mines: Int) -> Game {
    let topLeft = Coord(0, 0)
    let grid = Grid(width: width, height: height)
    return Game(grid: grid, mines: mines, cursorStart: topLeft)
  }

  static func newCircular(radius: Int, mines: Int) -> Game {
    let center = Coord(radius, radius)

    // We create the square of coords that bounds the circle, then filter out
    // all the coords too far from the center to be in the circle. Math!
    let distToCenter = { (c: Coord) -> Float in
      let xDist = Float(c.col - center.col)
      let yDist = Float(c.row - center.row)
      return (xDist * xDist + yDist * yDist).squareRoot()
    }
    let circle = Coord.rectangle(
      from: Coord(0, 0), to: Coord(radius * 2, radius * 2)
    ).filter { distToCenter($0) <= Float(radius) }

    let circleGrid = Grid(withCoords: circle)
    return Game(grid: circleGrid, mines: mines, cursorStart: center)
  }
}
