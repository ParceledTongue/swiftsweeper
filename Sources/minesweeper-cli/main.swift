// classic grid
var squareGrid = Grid(width: 16, height: 16)
squareGrid.populateRandom(mines: 40, start: Coord(1, 1)) // nearly top left
prettyPrintWithHints(grid: squareGrid)
print()

// circular grid
let dist = { (c1: Coord, c2: Coord) -> Float in
  let xDist = Float(c2.col - c1.col)
  let yDist = Float(c2.row - c1.row)
  return (xDist * xDist + yDist * yDist).squareRoot()
}
let circle = Coord.rectangle(from: Coord(0, 0), to: Coord(16, 16))
  .filter { dist($0, Coord(8, 8)) <= 8 }
var circularGrid = Grid(withCoords: circle)
circularGrid.populateRandom(mines: 45, start: Coord(8, 8))
prettyPrintWithHints(grid: circularGrid)
print()
