struct Style {
  let unknown: String
  let flagged: String
  let bomb: String
  let nothing: String
  let s0: String
  let s1: String
  let s2: String
  let s3: String
  let s4: String
  let s5: String
  let s6: String
  let s7: String
  let s8: String

  // swiftlint:disable cyclomatic_complexity
  func render(coord: Coord, game: Game) -> String {
    switch spaceType(coord, game) {
    case .unknown: return unknown
    case .flagged: return flagged
    case .bomb:    return bomb
    case .nothing: return nothing
    case .safe(0): return s0
    case .safe(1): return s1
    case .safe(2): return s2
    case .safe(3): return s3
    case .safe(4): return s4
    case .safe(5): return s5
    case .safe(6): return s6
    case .safe(7): return s7
    case .safe(8): return s8
    case .safe: return "FIXME" // more than 8 neighbors, impossible
    }
  }

  private enum SpaceType {
    case unknown, flagged, bomb, nothing, safe(Int)
  }

  private func spaceType(_ coord: Coord, _ game: Game) -> SpaceType {
    // not on grid
    if !game.grid.coords.contains(coord) { return .nothing }
    // on grid, revealed
    // (we treat all spaces as revealed after the player loses)
    if game.revealed.contains(coord) || game.state == .lost {
      // bomb
      if game.grid[coord] { return .bomb }
      // non-bomb
      let neighborCount = game.grid.adjacentMines(coord)
      return .safe(neighborCount)
    }
    // on grid, not revealed
    return game.flagged.contains(coord)
      ? .flagged // flagged space
      : .unknown // unflagged space
  }
}
