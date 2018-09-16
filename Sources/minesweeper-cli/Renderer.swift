import Rainbow

struct Renderer {
  let style: (StyleCase) -> String
  let cursorMode: CursorMode

  enum CursorMode {
    case swap
    case highlight
    case character(String)
  }

  init(
    style: @escaping (StyleCase) -> String = basicStyleWithColor,
    cursorMode: CursorMode = .swap
  ) {
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
    var str = basicCoordToString(coord: coord, game: game)

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
    }

    return str
  }

  private func basicCoordToString(coord: Coord, game: Game) -> String {
    // not on grid
    if !game.grid.coords.contains(coord) {
      return style(.icon(.space))
    }
    // on grid, revealed
    // (we treat all spaces as revealed after the player loses)
    if game.revealed.contains(coord) || game.state == .lost {
      // bomb
      if game.grid[coord] {
        return style(.icon(.bomb))
      }
      // non-bomb
      let neighborCount = game.grid.adjacentMines(coord)
      return neighborCount == 0
        ? style(.icon(.empty)) // neieghborless
        : style(.number(neighborCount)) // has neighbors
    }
    // on grid, not revealed
    return game.flagged.contains(coord)
      // flagged space
      ? style(.icon(.flagged))
      // unflagged space
      : style(.icon(.unknown))
  }

  // MARK: Styles

  enum StyleCase {
    case icon(SpaceType)
    case number(Int)
  }

  enum SpaceType {
    case unknown, flagged, bomb, empty, space
  }

  static func basicStyle(_ styleCase: StyleCase) -> String {
    switch styleCase {
    case let .icon(spaceType):
      switch spaceType {
      case .unknown: return "#"
      case .flagged: return "X"
      case .bomb:    return "*"
      case .empty:   return "·"
      case .space:   return " "
      }
    case let .number(n):
      return String(n)
    }
  }

  static func basicStyleWithColor(_ styleCase: StyleCase) -> String {
    switch styleCase {
    case let .icon(spaceType):
      switch spaceType {
      case .unknown: return "#"
      case .flagged: return "#".red
      case .bomb:    return "*".lightBlack
      case .empty:   return "·"
      case .space:   return " "
      }
    case let .number(n):
      let str = String(n)
      switch n {
      case 1:  return str.lightBlue
      case 2:  return str.lightGreen
      case 3:  return str.lightYellow
      case 4:  return str.lightMagenta
      case 5:  return str.lightCyan
      case 6:  return str.lightRed
      case 7:  return str.lightBlack
      case 8:  return str.black
      default: return str
      }
    }
  }

  // surprisingly playable!
  // doesn't do well with .swap
  static func mahjongStyle(_ styleCase: StyleCase) -> String {
    switch styleCase {
    case let .icon(spaceType):
      switch spaceType {
      case .unknown: return "🀫"
      case .flagged: return "🀃".red
      case .bomb:    return "🀅".lightBlack
      case .empty:   return "🀆"
      case .space:   return " "
      }
    case let .number(n):
      switch n {
      case 1:  return "🀙"
      case 2:  return "🀚"
      case 3:  return "🀛"
      case 4:  return "🀜"
      case 5:  return "🀝"
      case 6:  return "🀞"
      case 7:  return "🀟"
      case 8:  return "🀠"
      default: return "🀪"
      }
    }
  }

  // this is the best one
  // emojis aren't affected by .swap or .highlight
  static func clockStyle(_ styleCase: StyleCase) -> String {
    switch styleCase {
    case let .icon(spaceType):
      switch spaceType {
      case .unknown: return "🕰 "
      case .flagged: return "⏳"
      case .bomb:    return "⏰"
      case .empty:   return "🕛"
      case .space:   return "  " // need an emoji-width thing here
      }
    case let .number(n):
      switch n {
      case 1:  return "🕐"
      case 2:  return "🕑"
      case 3:  return "🕒"
      case 4:  return "🕓"
      case 5:  return "🕔"
      case 6:  return "🕕"
      case 7:  return "🕖"
      case 8:  return "🕗"
      default: return "⁉️ "
      }
    }
  }
}
