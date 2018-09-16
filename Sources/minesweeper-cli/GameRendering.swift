import Rainbow

private struct DisplayStrings {
  static let unknown = "#"
  static let flagged = "!"
  static let bomb = "*"
  static let empty = "·"
  static let space = " "
}

func printGameNoColors(_ game: Game) {
  printGameWith(game) {
    let baseCharacter = baseCoordToString(coord: $0, game: game)
    return game.cursorAt == $0
      ? baseCharacter + "<"
      : baseCharacter + " "
  }
}

func printGameWithFlip(_ game: Game) {
  printGameWith(game) {
    var char = baseCoordToString(coord: $0, game: game)
    if game.cursorAt == $0 {
      char = char.swap
    }
    return char + " "
  }
}

private func baseCoordToString(coord: Coord, game: Game) -> String {
  // not on grid
  if !game.grid.coords.contains(coord) {
    return DisplayStrings.space
  }
  // on grid, revealed
  // (we treat all spaces as revealed after the player loses)
  if game.revealed.contains(coord) || game.state == .lost {
    // bomb
    if game.grid[coord] {
      return DisplayStrings.bomb
    }
    // non-bomb
    let neighborCount = game.grid.adjacentMines(coord)
    return neighborCount == 0
      ? DisplayStrings.empty // neieghborless
      : String(neighborCount) // has neighbors
  }
  // on grid, not revealed
  return game.flagged.contains(coord)
    // flagged space
    ? DisplayStrings.flagged
    // unflagged space
    : DisplayStrings.unknown
}

private func printGameWith(_ game: Game, renderer: (Coord) -> String) {
  let b = Coord.Bounds(game.grid.coords)

  // we put an extra coord at the end of each row so that we can
  // split on it to get the individual rows
  let coordRows = Coord.rectangle(
    from: Coord(b.topBound, b.leftBound),
    to: Coord(b.bottomBound, b.rightBound + 1)
  ).split { $0.col > b.rightBound }

  for r in coordRows {
    let rowString = r.map(renderer).joined()
    print(rowString)
  }
}
