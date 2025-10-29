# 🔥 Xiaomi Aggressive Debloat Script

**Nuclear option for MIUI bloatware removal** - Removes ~160 packages while keeping your phone functional.

## ⚡ What This Does

Removes **EVERYTHING** non-essential:
- ❌ All MIUI apps (Gallery, Security, Backup, Cleaner, etc.)
- ❌ All Google apps (Play Store, Gmail, Chrome, GMS, etc.)
- ❌ All Qualcomm bloat (Diagnostics, telemetry, etc.)
- ❌ Browser, Calendar, Clock, Email
- ❌ Both Google keyboards (install yours first!)
- ✅ **Keeps:** Camera, Telephony, 4G/LTE, Calls, SMS, Bluetooth, NFC, System UI

## 🎯 Prerequisites

**BEFORE running this script:**

1. **Install your replacements from F-Droid:**
   - ✅ Keyboard (Unexpected Keyboard, AnySoftKeyboard)
   - ✅ Gallery (Simple Gallery Pro)
   - ✅ Browser (Fennec F-Droid, Bromite)
   - ✅ Any other apps you need
   - ⚠️ Camera is kept by default (edit script to remove if needed)

2. **Enable USB Debugging:**
   ```
   Settings → About Phone → Tap "MIUI Version" 7 times
   Settings → Additional Settings → Developer Options → USB Debugging ON
   ```

3. **Install ADB on your computer:**
   - **Windows:** [Download Platform Tools](https://developer.android.com/studio/releases/platform-tools)
   - **Linux:** `sudo apt install adb` or `sudo pacman -S android-tools`
   - **Mac:** `brew install android-platform-tools`

## 🚀 Usage

### Step 1: Connect Phone
```bash
adb devices
# Accept prompt on phone
```

### Step 2: Run Script
```bash
chmod +x debloat.sh
./debloat.sh
```

### Step 3: Reboot
```bash
adb reboot
```

## 📋 What's Kept (Critical Packages)

These packages are **NOT** removed to prevent system crashes:

| Package | Purpose |
|---------|---------|
| `com.android.systemui` | Status bar, navigation, notifications |
| `com.android.phone` | Telephony stack (calls/SMS/mobile data) |
| `com.android.server.telecom` | Call management |
| `com.android.settings` | Settings app |
| `com.android.contacts` | Contact provider |
| `com.android.bluetooth` | Bluetooth functionality |
| `com.android.nfc` | NFC (if you use it) |
| `com.android.providers.*` | System data storage |
| `com.android.mms` | MMS messaging |
| `com.android.defcontainer` | Package installation |
| `com.android.keychain` | Certificate management |
| `com.android.camera`* | Camera app (can remove) |
| `com.qualcomm.qti.ims`* | VoLTE (can remove) |
| `org.codeaurora.ims`* | VoLTE (can remove) |

\* Optional packages - commented or can be removed if not needed

## ⚠️ Important Notes

### Camera
Stock camera is **kept by default**. To remove it (if you have OpenCamera/etc), edit script and uncomment:
```bash
adb shell pm uninstall -k --user 0 com.android.camera
```

### VoLTE/VoWiFi
If you **don't use** VoLTE or VoWiFi calling, edit the script and uncomment these lines:
```bash
adb shell pm uninstall -k --user 0 com.qualcomm.qti.ims
adb shell pm uninstall -k --user 0 org.codeaurora.ims
```

### NFC
`com.android.nfc` is kept by default. Remove it if you don't use NFC payments/tags.

### 4G/LTE
Mobile data **will work** - all telephony packages are preserved.

## 🔧 Restore Packages

### Option 1: Restore Everything (Nuclear Undo)
Run the restore script to reinstall ALL removed packages:
```bash
chmod +x restore.sh
./restore.sh
adb reboot
```

### Option 2: Restore Individual Packages
Restore any single package manually:
```bash
adb shell cmd package install-existing com.package.name
```

Examples:
```bash
# Restore Google Play Store
adb shell cmd package install-existing com.android.vending

# Restore stock camera (if you removed it)
adb shell cmd package install-existing com.android.camera

# Restore MIUI Gallery
adb shell cmd package install-existing com.miui.gallery
```

## 🐛 Troubleshooting

### Phone won't boot / Bootloop
This script should **not** cause bootloops. All critical system packages are preserved.

### No mobile data / calls
This shouldn't happen. If it does:
```bash
adb shell cmd package install-existing com.android.phone
adb shell cmd package install-existing com.android.providers.telephony
```

### VoLTE not working
Restore IMS packages:
```bash
adb shell cmd package install-existing com.qualcomm.qti.ims
adb shell cmd package install-existing org.codeaurora.ims
```

### Settings crashes
```bash
adb shell cmd package install-existing com.android.settings
```

## 📱 Tested On

- Xiaomi Mi 5 (Gemini)
- MIUI Global ROM
- Should work on most Xiaomi/Redmi/POCO devices with Qualcomm chips

## ⚖️ License

Public Domain / WTFPL - Do whatever you want

## 🙏 Credits

Researched and verified against XDA Forums, Android AOSP sources, and Qualcomm documentation.

---

**⚠️ WARNING:** This is an aggressive debloat. While safe, always backup your data first. The author is not responsible for any issues.

**🔥 TIP:** After debloating, consider flashing a custom ROM like LineageOS for even better privacy and performance.
