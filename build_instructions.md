# Craft FOSSifier - Build and Use Guide

## Prerequisites

1. **Install Nim** (if not installed):
   ```bash
   # Linux/macOS
   curl https://nim-lang.org/choosenim/init.sh -sSf | sh
   
   # Or via package manager
   # Arch: sudo pacman -S nim
   # Ubuntu: sudo apt install nim
   # macOS: brew install nim
   ```

2. **Install ADB** (Android Debug Bridge):
   ```bash
   # Linux
   sudo apt install android-tools-adb
   
   # macOS
   brew install android-platform-tools
   
   # Windows
   # Download from: https://developer.android.com/studio/releases/platform-tools
   ```

## Build from Source

```bash
# Clone the repository
git clone https://github.com/username/craft-fossifier
cd craft-fossifier

# Build release binary (optimized, ~500KB)
nimble build

# Or build with debug symbols
nimble debug

# Binary created: ./craft_fossifier
```

## Quick Start (3 Steps)

### Step 1: Preview (No Device Needed)
```bash
./craft_fossifier --dryrun --leave-risky-to-remove-for xiaomi miui googleservices
```
This shows what WOULD be removed. Safe to run anytime.

### Step 2: Generate Files (No Device Needed)
```bash
./craft_fossifier --generate --leave-risky-to-remove-for xiaomi miui googleservices
```
Creates: `debloat.txt` and `restore.txt`

### Step 3: Use Generated Files
```bash
# Connect device via USB, enable USB debugging
adb devices  # Verify connection

# Open debloat.txt, read section headers
# Copy commands section-by-section and paste in terminal
# Example:
adb shell pm uninstall -k --user 0 com.miui.analytics
adb shell pm uninstall -k --user 0 com.xiaomi.mipicks
# ... etc

# Reboot device
adb reboot
```

## Common Use Cases

### Safe Debloat (Keep Everything Important)
```bash
./craft_fossifier --generate \
  --leave-risky-to-remove-for xiaomi miui googleservices
```
- Removes ads, telemetry, bloat
- Keeps Google Services (apps work)
- Keeps Xiaomi critical packages (no bootloop)
- ~150 packages removed

### Degoogle (Remove Google, Keep Xiaomi Safe)
```bash
./craft_fossifier --generate \
  --leave-risky-to-remove-for xiaomi miui
```
- Removes Google apps
- Keeps critical Xiaomi packages
- ~180 packages removed
- Banking apps may not work

### Nuclear Option (Remove Everything)
```bash
./craft_fossifier --generate --unsafe
```
- ⚠️ **DANGEROUS!** May brick device
- Removes Google Services
- Removes everything possible
- ~195 packages removed
- Many apps will break

### Interactive Debug (Build Device Profile)
```bash
./craft_fossifier --debuginteractive \
  --leave-risky-to-remove-for xiaomi miui
```
- Tests packages one-by-one
- You confirm after each removal
- Auto-restores problematic packages
- Creates device profile folder
- Use to contribute new device profile

## Understanding Risk Profiles

| Profile | What It Protects | When To Use |
|---------|------------------|-------------|
| `xiaomi` | Xiaomi bootloop packages | Always on Xiaomi devices |
| `miui` | MIUI system packages | Always on MIUI ROM |
| `googleservices` | Apps needing Google | If you use banking/games |
| `custom` | Device-specific issues | From debug sessions |
| `core` | Critical system | Always (auto-protected) |

## Reading debloat.txt

The generated file has 10 sections:

```
Section 1: ABSOLUTE TRASH ✅ (Always safe)
  - Ads, telemetry, tracking
  - No impact

Section 2-5: VENDOR & CARRIER BLOAT ✅ (Safe)
  - Cloud services, translations, Qualcomm stuff
  - Minor impact

Section 6: STOCK APPS ⚠️ (Install FOSS first!)
  - Gallery, Files, Browser, Notes, Calendar
  - Install alternatives before removing

Section 7: CAMERA & LAUNCHER ⚠️ (Commented out)
  - Only remove if you have replacements
  - Uncomment manually to remove

Section 8: GOOGLE BLOAT ⚠️ (Moderate risk)
  - Gmail, Chrome, YouTube, Maps
  - FOSS alternatives available

Section 9: PLAY STORE ⚠️ (High risk)
  - Play Store only
  - Use Aurora Store instead

Section 10: GOOGLE SERVICES ☢️ (Nuclear)
  - GMS, GSF, WebView
  - MANY APPS BREAK
  - Commented out by default
```

## Example Workflow

### For Xiaomi Poco X3 Pro User

```bash
# 1. Preview first
./craft_fossifier --dryrun --leave-risky-to-remove-for xiaomi miui googleservices

# Output shows:
#   Would remove: 150 packages
#   Would skip: 45 packages (risky on XIAOMI, MIUI, GOOGLE_SERVICES)

# 2. Generate files
./craft_fossifier --generate --leave-risky-to-remove-for xiaomi miui googleservices

# 3. Install FOSS alternatives FIRST
# See separate FOSS installer script

# 4. Connect device
adb devices

# 5. Execute Section 1 (absolutely safe)
# Copy commands from Section 1 in debloat.txt
adb shell pm uninstall -k --user 0 com.miui.analytics
# ... more commands

# 6. Test device, reboot
adb reboot

# 7. Execute Section 2-5 (safe)
# Copy more commands

# 8. Execute Section 6 (stock apps) - only after FOSS installed!
# Copy commands for Gallery, Files, Browser, etc.

# 9. Skip Section 7-10 or execute selectively
```

## Troubleshooting

### "adb: command not found"
Install Android platform tools (see Prerequisites).

### "No devices found"
1. Connect device via USB
2. Enable Developer Options: Settings → About → Tap "Build Number" 7 times
3. Enable USB Debugging: Settings → Developer Options → USB Debugging
4. Accept authorization popup on device
5. Run `adb devices` to verify

### "Package not found" errors
Normal! Many packages vary by device. The script continues.

### Device acting weird after debloat
```bash
# Restore everything
./craft_fossifier --restore

# Or use restore.txt manually
# Copy commands from restore.txt
```

### Bootloop or won't start
1. Boot to recovery mode (usually Power + Volume Up)
2. Wipe cache partition
3. Reboot
4. If still broken, factory reset (you'll lose data!)

Prevention: Always use risk profiles appropriate for your device!

## File Locations

After running `--generate`:
```
./debloat.txt   - Commands to remove packages
./restore.txt   - Commands to restore packages
```

After running `--debuginteractive`:
```
./Device Name - codename/
  ├── debloat.txt
  ├── restore.txt
  ├── problematic_packages.txt
  └── README.md
```

## Advanced Usage

### Custom Output Directory
```bash
./craft_fossifier --generate \
  --leave-risky-to-remove-for xiaomi miui \
  --output-dir ~/my-debloat-profiles/
```

### Generate and Execute Immediately
```bash
# Device must be connected
./craft_fossifier --debloat \
  --leave-risky-to-remove-for xiaomi miui googleservices
```

### Preview Different Risk Combinations
```bash
# With Google
./craft_fossifier --dryrun --leave-risky-to-remove-for xiaomi miui googleservices

# Without Google
./craft_fossifier --dryrun --leave-risky-to-remove-for xiaomi miui

# Nothing protected (dangerous!)
./craft_fossifier --dryrun --unsafe
```

## FOSS App Installation

Before removing stock apps (Section 6), install alternatives:

**Essential:**
- Gallery → Fossify Gallery (F-Droid)
- Files → Material Files (F-Droid)
- Browser → Fennec/Mull (F-Droid)
- Keyboard → Unexpected Keyboard (F-Droid)

**Recommended:**
- SMS → Fossify Messages (F-Droid)
- Phone → Fossify Phone (F-Droid)
- Calendar → Fossify Calendar (F-Droid)
- Notes → Fossify Notes (F-Droid)
- Camera → OpenCamera (F-Droid) or keep stock
- Music → AIMP (official) or VLC (F-Droid)
- YouTube → NewPipe (F-Droid)

See companion script: `install-foss.sh`

## Contributing Device Profiles

If you use `--debuginteractive`, please share your device folder!

1. Zip the folder: `Device Name - codename.zip`
2. Create issue: https://github.com/username/craft-fossifier/issues/new
3. Title: "Device Profile: [Your Device]"
4. Attach ZIP
5. Describe your experience

Your contribution helps others with the same device!

## Safety Tips

✅ **DO:**
- Use risk profiles for your device
- Run `--dryrun` first
- Install FOSS alternatives before removing stock apps
- Keep `restore.txt` as backup
- Test device after each section
- Reboot after major changes

❌ **DON'T:**
- Use `--unsafe` unless you know what you're doing
- Remove Camera/Launcher without alternatives
- Remove Google Services if you need banking apps
- Remove packages you don't understand
- Debloat before important events (keep phone working!)

## Getting Help

- **Documentation**: README.md, PROJECT_STRUCTURE.md
- **Issues**: https://github.com/username/craft-fossifier/issues
- **Discussions**: https://github.com/username/craft-fossifier/discussions
- **Matrix/Discord**: [Link to community chat]

## License

MIT License - See LICENSE file.

Use at your own risk. The authors are not responsible for bricked devices.

---

**Happy debloating! 🎉**
