import std/[terminal, tables]
import ../types/[config, package, enums]
import ../data/all_packages
import ../core/risk_analyzer
import ../ui/colors

proc run*(config: Config) =
  styledEcho fgCyan, styleBright, "\n╔══════════════════════════════════════════════════════════════════╗"
  styledEcho fgCyan, styleBright, "║              ", fgWhite, "DRY RUN MODE", fgCyan, " - Preview Package Removal            ║"
  styledEcho fgCyan, styleBright, "╚══════════════════════════════════════════════════════════════════╝\n"
  
  if config.riskProfiles.len > 0:
    printInfo("Risk profiles enabled: " & config.riskProfiles.join(", "))
  else:
    printWarning("No risk profiles - showing ALL packages")
  
  var toRemove = 0
  var skipped = 0
  var currentSection = sec1AbsoluteTrash
  
  echo ""
  for pkg in allPackages:
    # Print section header when section changes
    if pkg.section != currentSection:
      currentSection = pkg.section
      echo ""
      styledEcho fgCyan, "─".repeat(70)
      styledEcho fgCyan, "SECTION ", $ord(pkg.section), ": ", styleBright, (case pkg.section
        of sec1AbsoluteTrash: "ABSOLUTE TRASH"
        of sec2VendorBloat: "VENDOR BLOAT"
        of sec3UselessFeatures: "USELESS FEATURES"
        of sec4VendorSecurity: "VENDOR SECURITY"
        of sec5QualcommCarrier: "QUALCOMM & CARRIER"
        of sec6StockApps: "STOCK VENDOR APPS"
        of sec7CameraLauncher: "CAMERA & LAUNCHER"
        of sec8GoogleBloat: "GOOGLE BLOAT"
        of sec9PlayStore: "GOOGLE PLAY STORE"
        of sec10GoogleServices: "GOOGLE SERVICES (NUCLEAR)")
      styledEcho fgCyan, "─".repeat(70)
      echo ""
    
    let (skip, reason) = shouldSkipPackage(pkg, config.riskProfiles)
    if skip:
      styledEcho fgYellow, "  ⚠️  Would skip: ", fgWhite, pkg.uiName.alignLeft(35), fgYellow, " (", reason, ")"
      skipped.inc()
    else:
      let commentOut = pkg.section == sec7CameraLauncher or pkg.section == sec10GoogleServices
      if commentOut:
        styledEcho fgMagenta, "  # Would skip: ", fgWhite, pkg.uiName.alignLeft(35), fgMagenta, " (commented by default)"
      else:
        styledEcho fgBlue, "  📦 Would remove: ", fgWhite, pkg.uiName
      toRemove.inc()
  
  echo ""
  styledEcho fgGreen, styleBright, "═".repeat(70)
  styledEcho fgGreen, styleBright, "SUMMARY"
  styledEcho fgGreen, styleBright, "═".repeat(70)
  echo ""
  styledEcho fgBlue, "  Would remove: ", fgWhite, styleBright, $toRemove, fgWhite, " packages"
  styledEcho fgYellow, "  Would skip: ", fgWhite, styleBright, $skipped, fgWhite, " packages (risky)"
  echo ""
  echo "To generate files: --generate " & (if config.riskProfiles.len > 0: "--leave-risky-to-remove-for " & config.riskProfiles.join(" ") else: "--unsafe")
  echo ""