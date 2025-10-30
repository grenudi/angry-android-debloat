import std/[terminal, rdstdin, os, times, strutils]
import ../types/[config, package, enums]
import ../data/all_packages
import ../core/[adb, risk_analyzer]
import ../output/file_generator
import ../ui/colors

proc showWelcome() =
  styledEcho fgCyan, styleBright, """
╔══════════════════════════════════════════════════════════════╗
║           INTERACTIVE DEBUG MODE                             ║
║  Build device-specific debloat profile                       ║
╚══════════════════════════════════════════════════════════════╝

This mode helps create a device-specific debloat profile by:
• Removing packages ONE AT A TIME
• Testing if your device works after each removal
• Automatically restoring packages that cause problems
• Generating portable debloat.txt and restore.txt files

Available Risk Profiles:
• XIAOMI          - Xiaomi devices (bootloop risk)
• MIUI            - MIUI ROM specific
• GOOGLE_SERVICES - Apps requiring Google Play Services
• CUSTOM          - Custom device-specific issues
• CORE            - Core system (never removed automatically)

⚠️  RECOMMENDED WORKFLOW:

1. First: craft_fossifier --dryrun --leave-risky-to-remove-for xiaomi miui
   (Preview what would be removed)

2. Then: craft_fossifier --generate --leave-risky-to-remove-for xiaomi miui
   (Generate safe debloat files)

3. Finally: Use --debuginteractive only if:
   - No risk profile matches your device
   - You want to find additional problematic packages
   - You want to contribute a new device profile

Press Enter to continue or Ctrl+C to cancel..."""
  
  discard readLineFromStdin("")

proc run*(config: Config) =
  showWelcome()
  
  # Check ADB
  if not checkAdbConnection():
    printError("No ADB device connected!")
    quit(1)
  
  printSuccess("ADB device detected")
  echo ""
  
  # Get device info
  stdout.write "Enter device name (e.g., 'Poco X3 Pro'): "
  let deviceName = readLineFromStdin("").strip()
  
  stdout.write "Enter device codename (e.g., 'vayu'): "
  let codename = readLineFromStdin("").strip()
  
  if deviceName == "" or codename == "":
    printError("Device name and codename required!")
    quit(1)
  
  # Create folder
  let folderName = deviceName & " - " & codename
  let folderPath = config.outputDir / folderName
  createDir(folderPath)
  
  printSuccess("Created folder: " & folderName & "/")
  echo ""
  
  var successfullyRemoved: seq[Package] = @[]
  var problematicPackages: seq[tuple[pkg: Package, problem: string]] = @[]
  var skippedByUser = 0
  var skippedRisky = 0
  
  # Interactive loop
  for pkg in allPackages:
    let (skip, reason) = shouldSkipPackage(pkg, config.riskProfiles)
    if skip:
      styledEcho fgYellow, "⚠️  Auto-skipped: ", fgWhite, pkg.uiName, fgYellow, " (", reason, ")"
      skippedRisky.inc()
      continue
    
    if not isPackageInstalled(pkg.packageName):
      continue
    
    # Show package info
    echo ""
    echo "═".repeat(70)
    styledEcho fgCyan, styleBright, "Package: ", fgWhite, pkg.uiName
    styledEcho fgCyan, "Package Name: ", fgWhite, pkg.packageName
    styledEcho fgCyan, "Description: ", fgWhite, pkg.description
    styledEcho fgCyan, "Category: ", fgWhite, $pkg.bloatLevel, " (Section ", $ord(pkg.section), ")"
    styledEcho fgCyan, "Currently Installed: ", fgGreen, "Yes"
    echo "═".repeat(70)
    
    stdout.write "Remove this package? (Enter=Yes, n=Skip): "
    let answer = readLineFromStdin("").strip().toLowerAscii()
    
    if answer == "n":
      printSkipped("Skipped by user")
      skippedByUser.inc()
      continue
    
    # Remove package
    if uninstallPackage(pkg.packageName):
      printSuccess("Package removed")
      
      echo ""
      echo "⚠️  TEST YOUR DEVICE NOW!"
      echo ""
      echo "Check if everything works:"
      echo "• Open apps"
      echo "• Make a phone call"
      echo "• Send SMS"
      echo "• Check camera"
      echo "• Test any features you use"
      echo ""
      
      stdout.write "Is everything working? (Enter=Yes, n=Problem detected): "
      let workingAnswer = readLineFromStdin("").strip().toLowerAscii()
      
      if workingAnswer == "n":
        printWarning("Problem detected! Restoring package...")
        
        if reinstallPackage(pkg.packageName):
          printSuccess("Package restored")
          
          stdout.write "Describe the problem: "
          let problemDesc = readLineFromStdin("").strip()
          
          problematicPackages.add((pkg, problemDesc))
          printInfo("Added to device profile")
          
          # Update files immediately
          var newConfig = config
          newConfig.deviceName = deviceName
          newConfig.codename = codename
          generateDebloatFile(newConfig, folderPath / "debloat.txt")
          generateRestoreFile(newConfig, folderPath / "restore.txt")
        else:
          printError("Failed to restore package!")
      else:
        printSuccess("Confirmed working")
        successfullyRemoved.add(pkg)
    else:
      printError("Failed to remove package")
  
  # Generate final files
  echo ""
  printInfo("Generating final device profile files...")
  
  var newConfig = config
  newConfig.deviceName = deviceName
  newConfig.codename = codename
  
  # Generate main files
  generateDebloatFile(newConfig, folderPath / "debloat.txt")
  generateRestoreFile(newConfig, folderPath / "restore.txt")
  
  # Generate problematic_packages.txt
  var f = open(folderPath / "problematic_packages.txt", fmWrite)
  f.writeLine "# Problematic Packages for " & deviceName & " (" & codename & ")"
  f.writeLine "# These packages caused issues when removed"
  f.writeLine "# Generated by craft_fossifier"
  f.writeLine "# Date: " & now().format("yyyy-MM-dd HH:mm:ss")
  f.writeLine ""
  for item in problematicPackages:
    f.writeLine "Package: " & item.pkg.uiName
    f.writeLine "Package Name: " & item.pkg.packageName
    f.writeLine "Category: " & $item.pkg.bloatLevel
    f.writeLine "Problem: " & item.problem
    f.writeLine "Risk Profile: CUSTOM (device-specific)"
    f.writeLine ""
  f.writeLine "---"
  f.writeLine "Total problematic packages: " & $problematicPackages.len
  f.close()
  
  # Show summary
  echo ""
  styledEcho fgGreen, styleBright, "╔══════════════════════════════════════════════════════════════╗"
  styledEcho fgGreen, styleBright, "║           INTERACTIVE SESSION COMPLETE                       ║"
  styledEcho fgGreen, styleBright, "╚══════════════════════════════════════════════════════════════╝"
  echo ""
  styledEcho fgCyan, "📊 Statistics:"
  styledEcho fgGreen, "   ✓ Successfully removed:    ", $successfullyRemoved.len, " packages"
  styledEcho fgRed, "   ⚠️ Problematic (restored):   ", $problematicPackages.len, " packages"
  styledEcho fgWhite, "   ⊗ Skipped by user:           ", $skippedByUser, " packages"
  styledEcho fgYellow, "   ⊗ Skipped (risky):           ", $skippedRisky, " packages"
  echo ""
  styledEcho fgCyan, "📁 Device profile saved to:"
  echo "   " & folderName & "/"
  echo ""
  styledEcho fgCyan, "📝 Files generated:"
  echo "   ✓ debloat.txt              - Safe removal commands"
  echo "   ✓ restore.txt              - Restore commands"
  echo "   ✓ problematic_packages.txt - Problem package list"
  echo ""
  printWarning("IMPORTANT: Reboot your device now!")
  echo "  adb reboot"
  echo ""
  echo "Please share the folder '" & folderName & "' to help others!"
  echo "Create an issue at: https://github.com/username/craft-fossifier/issues"
  echo ""