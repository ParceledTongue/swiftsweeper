var g = Grid(width: 16, height: 16)
g.populate(mines: 40, start: Grid.Position(1, 1)) // nearly top left
g.prettyPrintWithHints()
