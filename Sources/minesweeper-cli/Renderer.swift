import Rainbow

struct Renderer {
  let style: Style
  let cursorMode: CursorMode

  private var cache: Cache = Cache()
  private class Cache {
    var game: Game?
    var coordStrings: [Coord: String] = [:]
  }

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

  func using(newCursorMode: CursorMode) -> Renderer {
    return Renderer(style: style, cursorMode: newCursorMode)
  }

  func render(_ game: Game) -> String {
    // clear the cache if the grid or mine layout has changed
    // (in theory we could have a dict of caches to cache several games at
    // once, but it's hard to imagine a renderer being used in parallel for
    // multiple games...)
    if let cachedGame = cache.game {
      if game.grid != cachedGame.grid {
        cache.coordStrings = [:]
      }
    }

    let b = Coord.Bounds(game.grid.coords)

    // we put an extra coord at the end of each row so that we can
    // split on it to get the individual rows
    let coordRows = Coord.rectangle(
      from: Coord(b.topBound, b.leftBound),
      to: Coord(b.bottomBound, b.rightBound + 1)
    ).split { $0.col > b.rightBound }

    let rowStrings = coordRows.map { rowCoords in
      rowCoords.map { coord in render(coord, game) }.joined()
    }

    cache.game = game // must happen after we render the coord strings

    // join all the row strings together
    return rowStrings.joined(separator: "\n")
  }

  private func render(_ coord: Coord, _ game: Game) -> String {
    if needsRerender(coord, game) {
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
      cache.coordStrings[coord] = str
    }

    return cache.coordStrings[coord]!
  }

  private func needsRerender(_ coord: Coord, _ game: Game) -> Bool {
    if cache.coordStrings[coord] == nil {
      // no cached info for this coord yet
      return true
    }
    if let cachedGame = cache.game {
      // if the cursor either is or was here and it has moved, rerender
      let isCursorCoord =
        game.cursorAt == coord || cachedGame.cursorAt == coord
      if isCursorCoord && game.cursorAt != cachedGame.cursorAt {
        return true
      }
      // otherwise, only rerender if revealed or flagged state changed
      let revealedChanged =
        game.revealed.contains(coord) != cachedGame.revealed.contains(coord)
      let flaggedChanged =
        game.flagged.contains(coord) != cachedGame.flagged.contains(coord)
      return revealedChanged || flaggedChanged
    } else {
      // if we don't have a game cached, we definitely need to render
      return true
    }
  }
}
