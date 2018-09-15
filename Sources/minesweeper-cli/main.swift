print("Beginner:")
let beginner = Game.newBeginner()
prettyPrint(grid: beginner.grid)
print()

print("Intermediate:")
let intermediate = Game.newIntermediate()
prettyPrint(grid: intermediate.grid)
print()

print("Expert:")
let expert = Game.newExpert()
prettyPrint(grid: expert.grid)
print()

print("Circle:")
let circle = Game.newCircular(radius: 10, mines: 54)
prettyPrint(grid: circle.grid)
print()
