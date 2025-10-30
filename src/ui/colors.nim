import std/terminal

proc printSuccess*(msg: string) =
  styledEcho fgGreen, "✅ ", fgWhite, msg

proc printError*(msg: string) =
  styledEcho fgRed, "❌ ", fgWhite, msg

proc printWarning*(msg: string) =
  styledEcho fgYellow, "⚠️  ", fgWhite, msg

proc printInfo*(msg: string) =
  styledEcho fgCyan, "ℹ️  ", fgWhite, msg

proc printSkipped*(msg: string) =
  styledEcho fgYellow, "⊗ ", fgWhite, msg

proc printPackage*(msg: string) =
  styledEcho fgBlue, "📦 ", fgWhite, msg