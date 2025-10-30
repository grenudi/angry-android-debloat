import std/[terminal, rdstdin]
import ../types/[config, enums]
import ../data/all_packages
import ../core/[adb, risk_analyzer]
import ../output/file_generator
import ../ui/colors

proc run*(config: Config) =
  styledEcho fgCyan, styleBright, "\n╔══════════════════════════════════════════════════════════════════╗"
  styledEcho fgCyan, styleBright, "║              ", fgWhite, "DEBLOAT MODE", fgCyan, " - Removing Bloatware                 ║"
  styledEcho fgCyan, styleBright, "╚══════════════════════════════════════════════════════════════════╝\n"
  
  if config.riskProfiles.len > 0:
    printInfo("Risk profiles enabled: " & config.riskProfiles.join(", "))
  else:
    printWarning("Running without risk profiles (--unsafe mode)")
  
  # Check ADB connection
  if not checkAdbConnection():
    printError("No ADB device connected!")
    echo "  1. Connect device via USB"
    echo "  2. Enable USB debugging"
    echo "  3. Accept ADB authorization on device"
    quit(1)
  
  printSuccess("ADB device detected")
  echo ""
  
  # Generate files first
  printInfo("Generating debloat.txt and restore.txt...")
  try:
    generateDebloatFile(config, config.outputDir / "debloat.txt")
    generateRestoreFile(config, config.outputDir / "restore.txt")
    printSuccess("Files generated")
  except:
    printError("Failed to generate files: " & getCurrentExceptionMsg())
    quit(1)
  
  echo ""
  printWarning("About to remove packages from your device!")
  let proceed = readLineFromStdin("Press Enter to continue or Ctrl+C to cancel: ")
  echo ""
  
  var removed = 0
  var failed = 0
  var skipped = 0
  var currentSection = sec1AbsoluteTrash
  
  for pkg in allPackages:
    # Print section header
    if pkg.section != currentSection:
      currentSection = pkg.section
      echo ""
      styledEcho fgCyan, "─── SECTION ", $ord(pkg.section), " ─────────────────────────────────────"
      echo ""
    
    let (skip, reason) = shouldSkipPackage(pkg, config.riskProfiles)
    if skip:
      styledEcho fgYellow, "  ⊗ Skipped: ", fgWhite, pkg.uiName, fgYellow, " (", reason, ")"
      skipped.inc()
      continue
    
    # Skip camera/launcher and Google Services by default
    if pkg.section == sec7CameraLauncher or pkg.section == sec10GoogleServices:
      styledEcho fgMagenta, "  # Skipped: ", fgWhite, pkg.uiName, fgMagenta, " (commented by default)"
      skipped.inc()
      continue
    
    if not isPackageInstalled(pkg.packageName):
      styledEcho fgWhite, "  ○ Not installed: ", pkg.uiName
      continue
    
    if uninstallPackage(pkg.packageName):
      styledEcho fgGreen, "  ✓ Removed: ", fgWhite, pkg.uiName
      removed.inc()
    else:
      styledEcho fgRed, "  ✗ Failed: ", fgWhite, pkg.uiName
      failed.inc()
  
  echo ""
  styledEcho fgGreen, styleBright, "═".repeat(70)
  styledEcho fgGreen, styleBright, "DEBLOAT COMPLETE"
  styledEcho fgGreen, styleBright, "═".repeat(70)
  echo ""
  styledEcho fgGreen, "  Removed: ", fgWhite, styleBright, $removed
  styledEcho fgRed, "  Failed: ", fgWhite, styleBright, $failed
  styledEcho fgYellow, "  Skipped: ", fgWhite, styleBright, $skipped
  echo ""
  printInfo("Files saved: debloat.txt, restore.txt")
  echo ""
  printWarning("IMPORTANT: Reboot your device now!")
  echo "  adb reboot"
  echo ""