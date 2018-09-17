import Rainbow

struct NoveltyStyles {

  // surprisingly playable
  static let mahjong = Style(
    unknown: "🀫",
    flagged: "🀃".red,
    bomb: "🀅".lightBlack,
    nothing: " ",
    s0: "🀆",
    s1: "🀙",
    s2: "🀚",
    s3: "🀛",
    s4: "🀜",
    s5: "🀝",
    s6: "🀞",
    s7: "🀟",
    s8: "🀠"
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
