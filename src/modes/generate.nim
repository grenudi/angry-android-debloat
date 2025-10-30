import std/[os, terminal]
import ../types/[config, package]
import ../output/file_generator
import ../ui/colors

proc run*(config: Config) =
  styledEcho fgCyan, styleBright, "\n╔══════════════════════════════════════════════════════════════════╗"
  styledEcho fgCyan, styleBright, "║              ", fgWhite, "GENERATE MODE", fgCyan, " - Creating Debloat Files             ║"
  styledEcho fgCyan, styleBright, "╚══════════════════════════════════════════════════════════════════╝\n"
  
  if config.riskProfiles.len > 0:
    printInfo("Risk profiles enabled: " & config.riskProfiles.join(", "))
  else:
    printWarning("No risk profiles - generating ALL packages")
  
  echo ""
  printInfo("Generating files in: " & config.outputDir)
  echo ""
  
  let debloatPath = config.outputDir / "debloat.txt"
  let restorePath = config.outputDir / "restore.txt"
  
  try:
    generateDebloatFile(config, debloatPath)
    printSuccess("Generated: debloat.txt")
    
    generateRestoreFile(config, restorePath)
    printSuccess("Generated: restore.txt")
    
    echo ""
    styledEcho fgGreen, styleBright, "✅ FILES GENERATED SUCCESSFULLY!"
    echo ""
    echo "Next steps:"
    echo "  1. Review " & debloatPath
    echo "  2. Copy commands section by section"
    echo "  3. Paste in terminal with ADB connected"
    echo "  4. Keep " & restorePath & " as backup"
    echo ""
    printWarning("IMPORTANT: Read section headers before executing!")
    
  except:
    printError("Failed to generate files: " & getCurrentExceptionMsg())
    quit(1)