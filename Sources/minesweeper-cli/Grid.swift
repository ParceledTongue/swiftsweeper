struct Grid: Equatable {

  private var dict: [Coord: Bool]
  let coords: Set<Coord>

  // Creates an empty rectangular grid.
  init(width: Int, height: Int) {
    self.init(withCoords: Coord.rectangle(
      from: Coord(0, 0),
      to: Coord(height - 1, width - 1))
    )
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

  mutating func populateRandom(mines: Int, start: Coord) {
    // we never place a mine at or adjacent to the starting coord
    let invalidCoords = Set([start]) + neighborsOf(start)
    let validCoords = coords.subtracting(invalidCoords)
    assert(mines <= validCoords.count, "more mines than spaces")
    populate(mineCoords: validCoords.shuffled().prefix(mines))
  }

  mutating func populate<S: Sequence>(mineCoords: S) where S.Element == Coord {
    clearMines()
    for mineCoord in mineCoords {
      dict[mineCoord] = true
    }
  }

  func adjacentMines(_ c: Coord) -> Int {
    return neighborsOf(c).filter { self[$0] }.count
  }

  func neighborsOf(_ c: Coord) -> [Coord] {
    let neighborCoords = Coord.rectangle(
      from: Coord(c.row - 1, c.col - 1),
      to: Coord(c.row + 1, c.col + 1)
    )
    return neighborCoords.filter {
      $0 != c // the coord isn't its own neighbor
      && coords.contains($0) // only include coords in the grid
    }
  }
}
