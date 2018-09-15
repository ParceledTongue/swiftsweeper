struct Game {
  let grid: Grid
  var cursorAt: Coord
  var revealed: Set<Coord>
  var flagged: Set<Coord>

  private init(gameGrid: Grid, cursorStart: Coord) {
    grid = gameGrid
    cursorAt = cursorStart
    revealed = Set()
    flagged = Set()
  }

  // cursor movement

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

  // revealing

  mutating func reveal() {
    if flagged.contains(cursorAt) {
      // TODO maybe provide some kind of bell feedback
      return
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

  // flagging

  mutating func flag() {
    if flagged.contains(cursorAt) {
      flagged.remove(cursorAt)
    } else {
      flagged.insert(cursorAt)
    }
  }

  // game initializers

  static func newBeginner() -> Game {
    let topLeft = Coord(0, 0)
    var beginnerGrid = Grid(width: 8, height: 8)
    beginnerGrid.populateRandom(mines: 10, start: topLeft)
    return Game(gameGrid: beginnerGrid, cursorStart: topLeft)
  }

  static func newIntermediate() -> Game {
    let topLeft = Coord(0, 0)
    var intermediateGrid = Grid(width: 16, height: 16)
    intermediateGrid.populateRandom(mines: 40, start: topLeft)
    return Game(gameGrid: intermediateGrid, cursorStart: topLeft)
  }

  static func newExpert() -> Game {
    let topLeft = Coord(0, 0)
    var expertGrid = Grid(width: 24, height: 24)
    expertGrid.populateRandom(mines: 99, start: topLeft)
    return Game(gameGrid: expertGrid, cursorStart: topLeft)
  }

  static func newCircular(radius: Int, mines: Int) -> Game {
    let center = Coord(radius, radius)
    let distToCenter = { (c: Coord) -> Float in
      let xDist = Float(c.col - center.col)
      let yDist = Float(c.row - center.row)
      return (xDist * xDist + yDist * yDist).squareRoot()
    }
    let circle = Coord.rectangle(
      from: Coord(0, 0), to: Coord(radius * 2, radius * 2)
    ).filter { distToCenter($0) <= Float(radius) }

    var circleGrid = Grid(withCoords: circle)
    circleGrid.populateRandom(mines: mines, start: center)
    return Game(gameGrid: circleGrid, cursorStart: center)
  }
}
