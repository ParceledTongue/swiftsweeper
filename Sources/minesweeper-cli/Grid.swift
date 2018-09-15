struct Grid {
  private var dict: [Coord: Bool]
  let coords: Set<Coord>

  // Creates an empty rectangular grid.
  init(width: Int, height: Int) {
    let rectangleCoords = (0..<height).flatMap { row in
      (0..<width).map { col in Coord(row, col) }
    }
    self.init(withCoords: rectangleCoords)
  }

  // Creates an empty grid of an arbitrary shape.
  init<S: Sequence>(withCoords: S) where S.Element == Coord {
    dict = Dictionary()
    for c in withCoords {
      dict[c] = false
    }
    coords = Set(dict.keys)
  }

  subscript(c: Coord) -> Bool {
    return dict[c] ?? false // not a mine if it's not on the grid
  }

  mutating func clearMines() {
    for c in coords {
      dict[c] = false
    }
  }

  mutating func populate(mines: Int, start: Coord) {
    clearMines()
    // we never place a mine at or adjacent to the starting coord
    let invalidCoords = Set([start]) + neighborsOf(start)
    let validCoords = coords.subtracting(invalidCoords)
    assert(mines <= validCoords.count, "more mines than spaces")

    for mineCoord in validCoords.shuffled().prefix(mines) {
      dict[mineCoord] = true
    }
  }

  func countNeighbors(_ c: Coord) -> Int {
    return neighborsOf(c).filter { self[$0] }.count
  }

  private func neighborsOf(_ c: Coord) -> [Coord] {
    let neighborCoords = ((c.row - 1)...(c.row + 1)).flatMap { row in
      ((c.col - 1)...(c.col + 1)).map { col in Coord(row, col) }
    }
    return neighborCoords.filter {
      $0 != c // the coord isn't its own neighbor
      && coords.contains($0) // only include coords in the grid
    }
  }
}
