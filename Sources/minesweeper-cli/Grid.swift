//
//  Grid.swift
//
//  Created by Zach Palumbo on 9/12/18.
//  Copyright © 2018 Zach Palumbo. All rights reserved.
//

import Rainbow

struct Grid {
  let width: Int
  let height: Int
  var grid: [[Bool]]

  private struct DisplayStrings {
    static let bomb = "*".lightBlack.bold
    static let space = "·"
  }

  init(width: Int, height: Int) {
    self.width = width
    self.height = height
    // start with an empty grid
    let emptyRow = Array(repeating: false, count: width)
    self.grid = Array(repeating: emptyRow, count: height)
  }

  subscript(row: Int, col: Int) -> Bool {
    return grid[row][col]
  }

  mutating func clear() {
    for row in 0..<height {
      for col in 0..<width {
        grid[row][col] = false
      }
    }
  }

  mutating func populate(mines: Int) {
    assert(mines <= width * height, "more mines than spaces")

    clear()

    var placed = 0
    while placed < mines {
      let (randomRow, randomCol) = (
        Int.random(in: 0..<height),
        Int.random(in: 0..<width)
      )
      if !grid[randomRow][randomCol] {
        grid[randomRow][randomCol] = true
        placed += 1
      }
    }
  }

  func neighbors(row: Int, col: Int) -> Int {
    var total = 0
    for neighborRow in max(0, row - 1)...min(row + 1, height - 1) {
      for neighborCol in max(0, col - 1)...min(col + 1, width - 1) {
        let isSelf = (neighborRow, neighborCol) == (row, col)
        if !isSelf && grid[neighborRow][neighborCol] {
          total += 1
        }
      }
    }
    return total
  }

  func prettyPrint() {
    printWith {
      return grid[$0][$1] ? DisplayStrings.bomb : DisplayStrings.space
    }
  }

  func prettyPrintWithHints() {
    printWith {
      if grid[$0][$1] {
        // mine
        return DisplayStrings.bomb
      } else {
        // empty
        let neighborCount = neighbors(row: $0, col: $1)
        return neighborCount == 0
          ? DisplayStrings.space
          : Grid.coloredNumberString(neighborCount)
      }
    }
  }

  private func printWith(renderer: (Int, Int) -> String) {
    for row in 0..<height {
      for col in 0..<width {
        print(renderer(row, col), terminator: " ")
      }
      print() // next row
    }
  }

  private static func coloredNumberString(_ num: Int) -> String {
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
}
