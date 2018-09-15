import Rainbow

private struct DisplayStrings {
  static let bomb = "*".lightBlack.bold
  static let empty = "·"
  static let space = " "
}

func prettyPrint(grid: Grid) {
  printGridWith(grid) {
    if grid.coords.contains($0) {
      return grid[$0]
        ? DisplayStrings.bomb
        : DisplayStrings.empty
    } else {
      return DisplayStrings.space
    }
  }
}

func prettyPrintWithHints(grid: Grid) {
  printGridWith(grid) {
    if !grid.coords.contains($0) {
      return DisplayStrings.space
    } else if grid[$0] {
      return DisplayStrings.bomb
    } else {
      let neighborCount = grid.adjacentMines($0)
      return neighborCount == 0
        ? DisplayStrings.empty
        : coloredNumberString(neighborCount)
    }
  }
}

private func printGridWith(_ grid: Grid, renderer: (Coord) -> String) {
  let b = Coord.Bounds(grid.coords)

  // we put an extra coord at the end of each row so that we can
  // split on it to get the individual rows
  let coordRows = Coord.rectangle(
    from: Coord(b.topBound, b.leftBound),
    to: Coord(b.bottomBound, b.rightBound + 1)
  ).split { $0.col > b.rightBound }

  for r in coordRows {
    let rowString = r.map(renderer).joined(separator: " ")
    print(rowString)
  }
}

private func coloredNumberString(_ num: Int) -> String {
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
