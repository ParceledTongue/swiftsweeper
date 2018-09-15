struct Coord: Equatable, Hashable {
  let row: Int
  let col: Int
  var north: Coord { return Coord(row - 1, col) }
  var east: Coord { return Coord(row, col + 1) }
  var south: Coord { return Coord(row + 1, col) }
  var west: Coord { return Coord(row, col - 1) }

  init(_ row: Int, _ col: Int) {
    self.row = row
    self.col = col
  }

  static func rectangle(from: Coord, to: Coord) -> [Coord] {
    let b = Bounds([from, to])
    return (b.topBound...b.bottomBound).flatMap { row in
      (b.leftBound...b.rightBound).map { col in Coord(row, col) }
    }
  }

  struct Bounds {
    let topBound: Int
    let rightBound: Int
    let bottomBound: Int
    let leftBound: Int

    init<S: Sequence>(_ coords: S) where S.Element == Coord {
      // it is an error to pass an empty sequence
      let rowNums = coords.map { $0.row }
      let colNums = coords.map { $0.col }
      topBound = rowNums.min()!
      rightBound = colNums.max()!
      bottomBound = rowNums.max()!
      leftBound = colNums.min()!
    }
  }
}
