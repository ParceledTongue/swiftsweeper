import Rainbow

struct BasicStyles {

  // for terminals or lives without color
  static let simple = Style(
    unknown: "#",
    flagged: "@",
    bomb: "*",
    nothing: " ",
    s0: "·",
    s1: "1",
    s2: "2",
    s3: "3",
    s4: "4",
    s5: "5",
    s6: "6",
    s7: "7",
    s8: "8"
  )

  // probably the easiest on the eyes
  static let color = Style(
    unknown: "#",
    flagged: "#".red,
    bomb: "*".lightBlack,
    nothing: " ",
    s0: "·",
    s1: "1".lightBlue,
    s2: "2".lightGreen,
    s3: "3".lightYellow,
    s4: "4".lightMagenta,
    s5: "5".lightCyan,
    s6: "6".lightRed,
    s7: "7".lightBlack,
    s8: "8".black
  )

  // if you really miss those flags
  static let emoji = Style(
    unknown: "██",
    flagged: "🚩",
    bomb: "💥",
    nothing: "  ",
    s0: "··",
    s1: " 1".lightBlue,
    s2: " 2".lightGreen,
    s3: " 3".lightYellow,
    s4: " 4".lightMagenta,
    s5: " 5".lightCyan,
    s6: " 6".lightRed,
    s7: " 7".lightBlack,
    s8: " 8".black
  )
}
