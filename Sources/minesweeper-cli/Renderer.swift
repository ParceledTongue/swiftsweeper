import Rainbow

struct Renderer {
  var style: Style
  var cursorMode: CursorMode

  enum CursorMode {
    case swap
    case highlight
    case character(String)
    case noCursor
  }

  init(style: Style = BasicStyles.color, cursorMode: CursorMode = .swap) {
    self.style = style
    self.cursorMode = cursorMode
  }

  func render(_ game: Game) -> String {
    let b = Coord.Bounds(game.grid.coords)

    // we put an extra coord at the end of each row so that we can
    // split on it to get the individual rows
    let coordRows = Coord.rectangle(
      from: Coord(b.topBound, b.leftBound),
      to: Coord(b.bottomBound, b.rightBound + 1)
    ).split { $0.col > b.rightBound }

    return coordRows.map { row in
      // map each coord in the row to its proper string,
      // then join them to get the complete row string
      row.map { coord in render(coord, game) }.joined()
    }.joined(separator: "\n") // join all the row strings together
  }

  private func render(_ coord: Coord, _ game: Game) -> String {
    // get the base character for this coord from the style
    var str = style.render(coord: coord, game: game)
    // apply the cursor mode
    let isCursor = coord == game.cursorAt
    switch cursorMode {
    case .swap:
      if isCursor { str = str.swap }
      str += " "
    case .highlight:
      if !isCursor { str = str.dim }
      str += " "
    case let .character(using):
      str += (isCursor ? using : " ")
    case .noCursor:
      str += " "
    }

    return str
  }
}
