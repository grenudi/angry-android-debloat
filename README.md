# 🔥 FOSSify Android

**Aggressive Android debloat tool** - Remove 200+ vendor bloat packages with bootloop protection.

**Especially optimized for Xiaomi/MIUI devices** - Tested on Mi 5, Redmi, and POCO phones. Should work on other Android vendors too (Samsung, Oppo, Realme, etc.) but Xiaomi-specific dangerous packages are well-documented.

## TL;DR (if your device is in the list)
1. Look at the folder structure for your device name/codename
2. 
## 🚀 Quick Start 

### 1. Install ADB
**Windows users:** Install [Fedora](https://fedoraproject.org/) (seriously, Windows sucks for development).  
**Everyone else:** You already know how.

### 2. Enable USB Debugging
```
Settings → About Phone → Tap "MIUI Version" 7 times
Settings → Additional Settings → Developer Options → USB Debugging ON
```

### 3. Connect Phone
```bash
adb devices
# Accept prompt on phone
```

### 4. Check Status (Dry Run)
```bash
python3 debloat.py --dryrun
```

### 5. Remove Bloat
```bash
# Normal mode - keeps Play Store, removes 190+ packages
python3 debloat.py --debloat

# FULL DEGOOGLE - removes Play Store/GMS too (195+ packages)
python3 debloat.py --fulldebloatdegoogle
```

### 6. Reboot
```bash
adb reboot
```

## 📦 What Gets Removed

### Both Modes Remove:
- ✓ **Ads & Tracking** - Analytics, vendor stores, GetApps
- ✓ **Vendor Bloat** - Cloud services, vendor accounts, payment apps
- ✓ **Vendor "Security"** - Cleaner, Security extras (NOT main Security Center on Xiaomi - causes bootloop!)
- ✓ **Stock Apps** - **Gallery (has ads!), File Manager (has ads!), Browser**
- ✓ **Google Bloat** - Gmail, Chrome, YouTube, Maps, Drive, Keyboards
- ✓ **Qualcomm Junk** - Telemetry, diagnostics, samples
- ✓ **Carrier Crap** - Cell broadcast, SMS push, configs
- ✓ **System Apps** - Calendar, Clock, Email, Calculator, Notes, Weather
- ✓ **Useless Shit** - VR, translations, themes, wallpapers

### --fulldebloatdegoogle ALSO Removes:
- ✓ **Play Store**
- ✓ **Google Play Services (GMS)**
- ✓ **Google Services Framework**
- ✓ **WebView**

⚠️ **Banking apps, Google Maps, and many games will NOT work without GMS!**

### Always Kept (Critical):
- ✓ SystemUI, Settings, Phone, Contacts
- ✓ Telephony (calls/SMS/4G/LTE/VoLTE)
- ✓ Bluetooth, NFC
- ✓ Camera, Launcher (safe to remove if you have replacements)

### Auto-Skipped (Will Cause Bootloop on Xiaomi/MIUI):
- ⊗ com.miui.securitycenter - **WILL BRICK XIAOMI PHONES**
- ⊗ com.miui.powerkeeper - May cause bootloop on Xiaomi
- ⊗ com.xiaomi.finddevice - Bootloop on MIUI 12.1+
- ⊗ com.miui.core - System instability on Xiaomi

*Note: These are Xiaomi-specific. Other vendors may have different dangerous packages.*

## 🛡️ Install FOSS Replacements

**BEFORE removing stock apps**, install these from F-Droid:

### Essential:
```bash
# Run the FOSS installer script
./install-foss.sh
```

Or manually install:
- **F-Droid** - https://f-droid.org
- **Fossify Gallery** - Replace Gallery
- **Material Files** - Replace File Manager
- **Ironfox FFUpdater** - Replace Browser
- **Tor Alfa FFUpdater** - Replace Browser
- **Unexpected Keyboard** - Replace Gboard (the best keyboard on touchscreen)

### Full List Auto-Installed:
- F-Droid, FFUpdater, Fennec
- Fossify (Gallery, Files, Notes, Messages, Phone, Calendar, Clock)
- Material Files
- KeePassDX (passwords)
- Orbot + Tor Browser
- NewPipe (to download from YouTube, to watch with your account auth just use firefox based browser(add extensions for ad,sponsor block, play in background and so on))
- MuPDF (PDF reader)

## 🔧 Commands

```bash
# Check what's installed (safe, no changes)
python3 debloat.py --dryrun

# Remove bloat, keep Play Store
python3 debloat.py --debloat

# Remove EVERYTHING including Google Services
python3 debloat.py --fulldebloatdegoogle

# Undo everything
python3 debloat.py --restore

# Reboot
adb reboot

# Restore single package
adb shell cmd package install-existing com.package.name
```

## ❓ FAQ

**Q: Will this brick my phone?**  
A: No. Dangerous packages are auto-skipped. Tested on multiple devices. (but maybe)

**Q: Can I undo this?**  
A: Yes. `python3 debloat.py --restore` or restore individual packages with ADB.

**Q: What's the difference between --debloat and --fulldebloatdegoogle?**  
A: --debloat keeps Play Store/GMS (most apps work). --fulldebloatdegoogle removes them too (full FOSS, some apps won't work).

**Q: Stock Gallery/FileManager have ADS?**  
A: YES on Xiaomi/MIUI! Even "system" apps show ads. Other vendors may vary. Always replace with Fossify Gallery and Material Files.

**Q: Will calls/SMS/mobile data work?**  
A: Yes. All telephony packages are preserved on all devices.

**Q: What if I need Play Store after degoogle?**  
A: Use Aurora Store (anonymous Play Store client) from F-Droid. Or restore PlayStore as showed above.

**Q: Phone won't boot?**  
A: Xiaomi-specific dangerous packages are auto-skipped. Other vendors might have different risky packages. If bootloop occurs, factory reset or restore in recovery.

**Q: Does this work on Samsung/Oppo/Realme/etc?**  
A: Should work, but dangerous package list is Xiaomi-specific. 
Use --dryrun first and research your vendor's critical packages before debloating.
Fork add packages, pull requst is welcomed 

## 🎯 Recommended Workflow

1. **Backup your data** (just in case)
2. `python3 debloat.py --dryrun` (check status)
3. TODO in py: `./install-foss.sh` (install FOSS apps FIRST) 
4. Test FOSS apps work
5. `python3 debloat.py --debloat` (or --fulldebloatdegoogle)
6. `adb reboot`
7. Set default apps (Fossify Gallery, Material Files, Fennec)
8. Enjoy ad-free MIUI

## 🔥 Pro Tips

- Use **FFUpdater** to install IronFox (hardened Firefox) or Brave(looks shady to me, but you do you)
- Route all apps through **Tor** with Orbot VPN mode
- Use **KeePassDX** with Syncthing for password sync
- Install **OLauncher** or **Lawnchair** to replace vendor launcher
- **Xiaomi users:** For true privacy, consider **LineageOS** (this script just makes MIUI bearable)
- **Other vendors:** Check XDA Forums for custom ROM options for your device

## 📱 Tested On

**Xiaomi devices (fully tested):**
- Xiaomi Mi 5 (Gemini) - MIUI Global
- Should work on all Xiaomi/Redmi/POCO devices with Qualcomm chipsets
- Android 7.0+

**Other vendors (should work, use with caution):**
- Samsung, Oppo, Realme, OnePlus, etc.
- Run --dryrun first and research vendor-specific dangerous packages
- Dangerous package list is Xiaomi/MIUI-specific

## 🙏 Credits

XDA Forums, Reddit r/Xiaomi, F-Droid, Fossify, Guardian Project

---

**⚠️ DISCLAIMER:** Backup your data. Author not responsible for issues. Dangerous package list is Xiaomi/MIUI-specific - other vendors may have different risky packages. This script makes vendor Android less shitty - for real privacy, use a custom ROM.