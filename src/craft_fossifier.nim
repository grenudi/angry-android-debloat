import std/[os, strutils, parseopt, terminal]
import types/[enums, package, config]
import modes/[dryrun, generate, debloat, restore, debug_interactive]

const version = "2.0.0"

proc printBanner() =
  echo ""
  styledEcho fgCyan, "╔══════════════════════════════════════════════════════════════════╗"
  styledEcho fgCyan, "║        ", fgWhite, styleBright, "CRAFT FOSSIFIER", fgCyan, " - Android Debloat Tool v" & version & "        ║"
  styledEcho fgCyan, "║              ", fgWhite, "Generate portable debloat scripts", fgCyan, "                    ║"
  styledEcho fgCyan, "║              ", fgWhite, "Optimized for Xiaomi/MIUI devices", fgCyan, "                   ║"
  styledEcho fgCyan, "╚══════════════════════════════════════════════════════════════════╝"
  echo ""

proc printHelp() =
  printBanner()
  echo """
Usage:
  craft_fossifier [MODE] [FLAGS]

Modes:
  --dryrun              Preview what would be removed (no files)
  --generate            Generate debloat.txt and restore.txt
  --debloat             Generate files AND execute removal
  --debuginteractive    Build device profile interactively
  --restore             Restore all removed packages

Flags:
  --leave-risky-to-remove-for [profiles...]
                        Skip packages risky for these profiles
                        Options: xiaomi, miui, googleservices, custom, core
  
  --unsafe              Skip safety check (use with caution!)
                        Required for --debloat without risk profiles
  
  --output-dir DIR      Output directory for files (default: current)

Risk Profiles:
  • xiaomi         - Xiaomi-specific (bootloop risk)
  • miui           - MIUI ROM packages
  • googleservices - Apps needing Google Play Services
  • custom         - Device-specific (from debug sessions)
  • core           - Critical system (auto-protected)

Examples:

  # Preview what would be removed
  craft_fossifier --dryrun --leave-risky-to-remove-for xiaomi miui

  # Generate portable debloat files (RECOMMENDED)
  craft_fossifier --generate --leave-risky-to-remove-for xiaomi miui googleservices

  # Generate and execute immediately
  craft_fossifier --debloat --leave-risky-to-remove-for xiaomi miui

  # Build device-specific profile
  craft_fossifier --debuginteractive --leave-risky-to-remove-for xiaomi miui

  # Restore everything
  craft_fossifier --restore

Output:
  debloat.txt  - ADB commands organized in 10 sections (safe → nuclear)
  restore.txt  - ADB commands to restore packages
  
Requirements:
  • ADB in PATH (only for --debloat, --debuginteractive, --restore)
  • Device with USB debugging (only for execution modes)

Learn more: https://github.com/username/craft-fossifier
"""

proc parseRiskProfiles(profiles: string): seq[string] =
  result = @[]
  for profile in profiles.split(','):
    let p = profile.strip().toLowerAscii()
    if p in ["xiaomi", "miui", "googleservices", "custom", "core"]:
      result.add(p)

proc main() =
  var config = Config(
    mode: modeNone,
    riskProfiles: @[],
    unsafe: false,
    outputDir: getCurrentDir(),
    deviceName: "",
    codename: ""
  )
  
  var parser = initOptParser()
  
  # Parse command line arguments
  while true:
    parser.next()
    case parser.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      case parser.key.toLowerAscii()
      of "dryrun":
        config.mode = modeDryrun
      of "generate":
        config.mode = modeGenerate
      of "debloat":
        config.mode = modeDebloat
      of "restore":
        config.mode = modeRestore
      of "debuginteractive":
        config.mode = modeDebugInteractive
      of "leave-risky-to-remove-for":
        parser.next()
        if parser.kind == cmdArgument:
          config.riskProfiles = parseRiskProfiles(parser.key)
      of "unsafe":
        config.unsafe = true
      of "output-dir":
        parser.next()
        if parser.kind == cmdArgument:
          config.outputDir = parser.key
      of "help", "h":
        printHelp()
        quit(0)
      of "version", "v":
        echo "craft_fossifier v" & version
        quit(0)
      else:
        styledEcho fgRed, "Unknown option: ", parser.key
        printHelp()
        quit(1)
    of cmdArgument:
      discard
  
  # Validate mode
  if config.mode == modeNone:
    printHelp()
    quit(1)
  
  # Safety check for debloat mode
  if config.mode == modeDebloat and config.riskProfiles.len == 0 and not config.unsafe:
    styledEcho fgRed, styleBright, "\n❌ DANGER! Running debloat without risk profiles!\n"
    echo "This may BRICK your device or cause bootloops."
    echo "You must specify EITHER:\n"
    echo "1. Risk profiles (recommended):"
    echo "   --leave-risky-to-remove-for xiaomi miui googleservices\n"
    echo "2. OR accept the risk:"
    echo "   --unsafe\n"
    echo "To see what would be removed first:"
    echo "   --dryrun [--leave-risky-to-remove-for ...]"
    quit(1)
  
  # Execute mode
  case config.mode
  of modeDryrun:
    dryrun.run(config)
  of modeGenerate:
    generate.run(config)
  of modeDebloat:
    debloat.run(config)
  of modeRestore:
    restore.run(config)
  of modeDebugInteractive:
    debug_interactive.run(config)
  of modeNone:
    discard

when isMainModule:
  main()