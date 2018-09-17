import Rainbow

struct NoveltyStyles {

  // surprisingly playable
  static let mahjong = Style(
    unknown: "🀫",
    flagged: "🀃".red,
    bomb: "🀅".lightBlack,
    nothing: " ",
    s0: "🀆",
    s1: "🀙".lightBlue,
    s2: "🀚".lightGreen,
    s3: "🀛".lightYellow,
    s4: "🀜".lightMagenta,
    s5: "🀝".lightCyan,
    s6: "🀞".lightRed,
    s7: "🀟".lightBlack,
    s8: "🀠".black
  )

  // the best one
  static let clocks = Style(
    unknown: "🕰 ",
    flagged: "⏳",
    bomb: "⏰",
    nothing: "  ",
    s0: "🕛",
    s1: "🕐",
    s2: "🕑",
    s3: "🕒",
    s4: "🕓",
    s5: "🕔",
    s6: "🕕",
    s7: "🕖",
    s8: "🕗"
  )
}
