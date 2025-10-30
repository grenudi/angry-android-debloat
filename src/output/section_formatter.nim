import ../types/enums

proc getSectionHeader*(section: Section): string =
  let divider = "# " & "=".repeat(76) & "\n"
  
  case section
  of sec1AbsoluteTrash:
    result = divider
    result &= "# SECTION 1: ABSOLUTE TRASH - Ads, Telemetry, Tracking\n"
    result &= divider
    result &= "# SAFETY: ✅ COMPLETELY SAFE - Pure garbage\n"
    result &= "# REMOVES: Analytics, ads, telemetry, tracking services\n"
    result &= "# IMPACT: None - only removes spyware and adware\n"
    result &= "# WHEN TO USE: Always safe, recommended for everyone\n\n"
  
  of sec2VendorBloat:
    result = "\n\n" & divider
    result &= "# SECTION 2: VENDOR BLOAT - Cloud, Accounts, Ecosystem Services\n"
    result &= divider
    result &= "# SAFETY: ✅ SAFE - Vendor ecosystem services\n"
    result &= "# REMOVES: Mi Cloud, Mi Account, vendor sync services\n"
    result &= "# IMPACT: Lose cloud sync, vendor account features\n"
    result &= "# WHEN TO USE: If you don't use vendor cloud services\n\n"
  
  of sec3UselessFeatures:
    result = "\n\n" & divider
    result &= "# SECTION 3: USELESS FEATURES - VR, Translation, Extras\n"
    result &= divider
    result &= "# SAFETY: ✅ SAFE - Unused features\n"
    result &= "# REMOVES: VR services, translation, live wallpapers, print services\n"
    result &= "# IMPACT: None unless you use these specific features\n"
    result &= "# WHEN TO USE: If you don't use VR, translation, or printing\n\n"
  
  of sec4VendorSecurity:
    result = "\n\n" & divider
    result &= "# SECTION 4: VENDOR SECURITY/CLEANER - Fake Security (Adware)\n"
    result &= divider
    result &= "# SAFETY: ⚠️  CAUTION - May be risky on some Xiaomi/MIUI devices\n"
    result &= "# REMOVES: Security Center, Cleaner, Power Keeper (these show ads!)\n"
    result &= "# IMPACT: Lose \"security\" scanning (which is mostly ads anyway)\n"
    result &= "# WHEN TO USE: Safe on most devices\n"
    result &= "# NOTE: These packages are ADWARE disguised as security tools\n\n"
  
  of sec5QualcommCarrier:
    result = "\n\n" & divider
    result &= "# SECTION 5: QUALCOMM & CARRIER BLOAT - Chipset & Network Services\n"
    result &= divider
    result &= "# SAFETY: ✅ MOSTLY SAFE - Diagnostic and telemetry services\n"
    result &= "# REMOVES: Qualcomm diagnostics, carrier bloat, unused network features\n"
    result &= "# IMPACT: May lose carrier-specific features (usually not needed)\n"
    result &= "# WHEN TO USE: Safe for most users\n\n"
  
  of sec6StockApps:
    result = "\n\n" & divider
    result &= "# SECTION 6: STOCK VENDOR APPS - Gallery, File Manager, Browser, Notes, etc.\n"
    result &= divider
    result &= "# SAFETY: ⚠️  SAFE BUT IMPORTANT - Stock utility apps\n"
    result &= "# REMOVES: Vendor's Gallery, File Manager, Browser, Notes, Calculator, etc.\n"
    result &= "# IMPACT: Lose stock apps (they have ADS anyway!)\n"
    result &= "# WHEN TO USE: ONLY AFTER installing FOSS alternatives!\n"
    result &= "#\n"
    result &= "# ⚠️  RECOMMENDATION: Install FOSS alternatives FIRST!\n"
    result &= "#\n"
    result &= "# BEFORE removing these, install:\n"
    result &= "# - Gallery      → Fossify Gallery (from F-Droid)\n"
    result &= "# - File Manager → Material Files (from F-Droid)\n"
    result &= "# - Browser      → Fennec/Mull (from F-Droid)\n"
    result &= "# - Notes        → Fossify Notes (from F-Droid)\n"
    result &= "# - Calendar     → Fossify Calendar (from F-Droid)\n"
    result &= "# - Calculator   → Simple Calculator (from F-Droid)\n"
    result &= "# - Clock        → Fossify Clock (from F-Droid)\n"
    result &= "# - SMS          → Fossify Messages (from F-Droid)\n"
    result &= "# - Phone        → Fossify Phone (from F-Droid)\n"
    result &= "# - Music        → AIMP or VLC (from official sites/F-Droid)\n"
    result &= "#\n"
    result &= "# These vendor apps contain ADS and track you!\n"
    result &= "# Removing them is SAFE but you need replacements first.\n\n"
  
  of sec7CameraLauncher:
    result = "\n\n" & divider
    result &= "# SECTION 7: CAMERA & LAUNCHER - User Preference Apps\n"
    result &= divider
    result &= "# SAFETY: ⚠️  USER CHOICE - Stock camera and launcher\n"
    result &= "# REMOVES: Stock camera app, vendor launcher\n"
    result &= "# IMPACT: Lose stock camera (may be better than alternatives), lose launcher\n"
    result &= "# WHEN TO USE: Only if you have replacements\n"
    result &= "#\n"
    result &= "# ⚠️  CAMERA: Stock camera often has better quality than alternatives!\n"
    result &= "#    Only remove if you have OpenCamera or GCam port and tested it.\n"
    result &= "#\n"
    result &= "# ⚠️  LAUNCHER: You NEED a launcher! Install alternatives FIRST!\n"
    result &= "#    Alternatives: Lawnchair, KISS Launcher, Simple Launcher\n"
    result &= "#\n"
    result &= "# SKIPPED by default. Uncomment to remove:\n"
  
  of sec8GoogleBloat:
    result = "\n\n" & divider
    result &= "# SECTION 8: GOOGLE BLOAT - Non-Essential Google Apps\n"
    result &= divider
    result &= "# SAFETY: ⚠️  MODERATE RISK - Google ecosystem apps\n"
    result &= "# REMOVES: Gmail, Chrome, YouTube, Maps, Photos, etc.\n"
    result &= "# IMPACT: Lose Google apps (many have FOSS alternatives)\n"
    result &= "# WHEN TO USE: If you want to reduce Google dependency\n"
    result &= "#\n"
    result &= "# ALTERNATIVES:\n"
    result &= "# - Gmail        → K-9 Mail / FairEmail\n"
    result &= "# - Chrome       → Fennec / Mull / Bromite\n"
    result &= "# - YouTube      → NewPipe / LibreTube\n"
    result &= "# - Maps         → OsmAnd / Organic Maps\n"
    result &= "# - Photos       → Fossify Gallery\n"
    result &= "# - Drive/Docs   → Nextcloud / Syncthing\n\n"
  
  of sec9PlayStore:
    result = "\n\n" & divider
    result &= "# SECTION 9: GOOGLE PLAY STORE - Still Relatively Safe\n"
    result &= divider
    result &= "# SAFETY: ⚠️  MODERATE-HIGH RISK - Play Store\n"
    result &= "# REMOVES: Google Play Store (NOT Play Services yet)\n"
    result &= "# IMPACT: Can't install apps from Play Store\n"
    result &= "# WHEN TO USE: If you're okay with F-Droid + Aurora Store only\n"
    result &= "#\n"
    result &= "# ⚠️  IMPORTANT: Many apps require Play Store for updates!\n"
    result &= "#    Alternative: Aurora Store (anonymous Play Store client)\n\n"
  
  of sec10GoogleServices:
    result = "\n\n" & divider
    result &= "# SECTION 10: GOOGLE SERVICES FRAMEWORK - NUCLEAR OPTION ☢️\n"
    result &= divider
    result &= "# SAFETY: ☢️  HIGH RISK - Core Google services\n"
    result &= "# REMOVES: Google Play Services, Services Framework, WebView\n"
    result &= "# IMPACT: MANY APPS WILL NOT WORK!\n"
    result &= "# WHEN TO USE: Full degoogle - you accept broken apps\n"
    result &= "#\n"
    result &= "# ⚠️  WARNING: This will BREAK many apps!\n"
    result &= "#\n"
    result &= "# WILL NOT WORK after removal:\n"
    result &= "# - Most banking apps\n"
    result &= "# - Apps with Google login\n"
    result &= "# - Apps using Google Maps API\n"
    result &= "# - Apps with push notifications via FCM\n"
    result &= "# - Many games (especially online)\n"
    result &= "# - Payment apps (Google Pay, etc.)\n"
    result &= "#\n"
    result &= "# ALTERNATIVES:\n"
    result &= "# - Use microG (requires unlocked bootloader + custom ROM usually)\n"
    result &= "# - Use only FOSS apps from F-Droid\n"
    result &= "# - Use web versions of apps\n"
    result &= "#\n"
    result &= "# Uncomment ONLY if you want full degoogle:\n"