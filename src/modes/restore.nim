import std/[terminal, rdstdin]
import ../types/config
import ../data/all_packages
import ../core/adb
import ../ui/colors

proc run*(config: Config) =
  styledEcho fgCyan, styleBright, "\n╔══════════════════════════════════════════════════════════════════╗"
  styledEcho fgCyan, styleBright, "║              ", fgWhite, "RESTORE MODE", fgCyan, " - Reinstalling Packages              ║"
  styledEcho fgCyan, styleBright, "╚══════════════════════════════════════════════════════════════════╝\n"
  
  # Check ADB connection
  if not checkAdbConnection():
    printError("No ADB device connected!")
    echo "  1. Connect device via USB"
    echo "  2. Enable USB debugging"
    echo "  3. Accept ADB authorization on device"
    quit(1)
  
  printSuccess("ADB device detected")
  echo ""
  
  printWarning("This will restore ALL packages (including Google Services)")
  let proceed = readLineFromStdin("Press Enter to continue or Ctrl+C to cancel: ")
  echo ""
  
  var restored = 0
  var failed = 0
  var alreadyInstalled = 0
  
  for pkg in allPackages:
    if isPackageInstalled(pkg.packageName):
      styledEcho fgWhite, "  ○ Already installed: ", pkg.uiName
      alreadyInstalled.inc()
      continue
    
    if reinstallPackage(pkg.packageName):
      styledEcho fgGreen, "  ✓ Restored: ", fgWhite, pkg.uiName
      restored.inc()
    else:
      styledEcho fgRed, "  ✗ Failed: ", fgWhite, pkg.uiName
      failed.inc()
  
  echo ""
  styledEcho fgGreen, styleBright, "═".repeat(70)
  styledEcho fgGreen, styleBright, "RESTORE COMPLETE"
  styledEcho fgGreen, styleBright, "═".repeat(70)
  echo ""
  styledEcho fgGreen, "  Restored: ", fgWhite, styleBright, $restored
  styledEcho fgRed, "  Failed: ", fgWhite, styleBright, $failed
  styledEcho fgWhite, "  Already installed: ", fgWhite, styleBright, $alreadyInstalled
  echo ""
  printInfo("Reboot recommended: adb reboot")
  echo ""