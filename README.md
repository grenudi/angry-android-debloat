# Craft FOSSifier

**Android Debloat Tool v2.0** - Generate portable debloat scripts for Android devices.

Written in Nim for maximum performance and minimal dependencies.

## Features

- ✅ **Portable Output**: Generates OS-agnostic `debloat.txt` and `restore.txt` files
- 📊 **Organized by Risk**: 10 sections from safest (ads/telemetry) to most dangerous (Google Services)
- 🛡️ **Bootloop Protection**: Risk profiles prevent dangerous removals on Xiaomi/MIUI devices
- 🎯 **Interactive Debug Mode**: Build device-specific profiles by testing packages one-by-one
- 📝 **Self-Documenting**: Each section has detailed headers explaining risks and alternatives
- 🚀 **No Runtime Dependencies**: Generated files work with just ADB on any OS

## Installation

### Prerequisites
- Nim compiler (>= 1.6.0)
- ADB in PATH (only for execution modes)

### Build from source

```bash
git clone https://github.com/username/craft-fossifier
cd craft-fossifier
nimble build
```

This creates a single `craft_fossifier` binary.

## Usage

### Quick Start

```bash
# 1. Preview what would be removed (safe, no device needed)
./craft_fossifier --dryrun --leave-risky-to-remove-for xiaomi miui googleservices

# 2. Generate portable debloat files (RECOMMENDED)
./craft_fossifier --generate --leave-risky-to-remove-for xiaomi miui googleservices

# 3. Review debloat.txt, then copy-paste commands to terminal with ADB
cat debloat.txt
# Copy commands section by section
```

### Modes

| Mode | Description | Device Required |
|------|-------------|-----------------|
| `--dryrun` | Preview what would be removed | No |
| `--generate` | Generate debloat.txt and restore.txt | No |
| `--debloat` | Generate files AND execute removal | Yes |
| `--restore` | Restore all removed packages | Yes |
| `--debuginteractive` | Build device profile interactively | Yes |

### Risk Profiles

Protect your device by skipping risky packages:

- `xiaomi` - Xiaomi-specific packages (bootloop risk)
- `miui` - MIUI ROM packages (system instability)
- `googleservices` - Apps requiring Google Play Services
- `custom` - Device-specific (from debug sessions)
- `core` - Critical system packages (auto-protected)

### Examples

**Safe debloat keeping Google + Xiaomi critical packages:**
```bash
./craft_fossifier --generate --leave-risky-to-remove-for xiaomi miui googleservices
```

**Degoogle but keep Xiaomi safe:**
```bash
./craft_fossifier --generate --leave-risky-to-remove-for xiaomi miui
```

**Full nuclear option (requires --unsafe):**
```bash
./craft_fossifier --generate --unsafe
```

**Interactive debug mode (build device profile):**
```bash
./craft_fossifier --debuginteractive --leave-risky-to-remove-for xiaomi miui
```

## Output Files

### debloat.txt
Organized in 10 sections from safest to most dangerous:

1. **Absolute Trash** - Ads, telemetry, tracking (✅ Safe)
2. **Vendor Bloat** - Cloud, accounts, ecosystem (✅ Safe)
3. **Useless Features** - VR, translation, extras (✅ Safe)
4. **Vendor Security** - Fake security apps with ads (⚠️ Caution on Xiaomi)
5. **Qualcomm & Carrier** - Chipset and network bloat (✅ Mostly Safe)
6. **Stock Vendor Apps** - Gallery, Files, Browser (⚠️ Install FOSS first!)
7. **Camera & Launcher** - User preference (⚠️ Commented by default)
8. **Google Bloat** - Gmail, Chrome, YouTube, Maps (⚠️ Moderate)
9. **Google Play Store** - Play Store only (⚠️ Moderate-High)
10. **Google Services** - GMS, GSF, WebView (☢️ Nuclear - commented by default)

Each section includes:
- Safety level indicator
- What gets removed
- Impact description
- FOSS alternatives
- Detailed warnings

### restore.txt
Commands to restore all removed packages, organized by the same sections.

## Debug Interactive Mode

Creates a folder with:
- `debloat.txt` - Tested safe removal commands
- `restore.txt` - Restore commands
- `problematic_packages.txt` - Human-readable problem list
- Device profile for contribution

**Workflow:**
1. Removes packages one-by-one
2. Prompts you to test device after each removal
3. Automatically restores problematic packages
4. Generates device-specific profile

## Project Structure

```
craft_fossifier/
├── craft_fossifier.nimble    # Package definition
├── src/
│   ├── craft_fossifier.nim   # Main entry point
│   ├── types/
│   │   ├── enums.nim         # Risk profiles, sections, levels
│   │   ├── package.nim       # Package type
│   │   └── config.nim        # Configuration
│   ├── data/
│   │   └── all_packages.nim  # Complete package database (~250 packages)
│   ├── core/
│   │   ├── adb.nim           # ADB interface
│   │   └── risk_analyzer.nim # Risk filtering
│   ├── modes/
│   │   ├── dryrun.nim
│   │   ├── generate.nim
│   │   ├── debloat.nim
│   │   ├── restore.nim
│   │   └── debug_interactive.nim
│   ├── output/
│   │   ├── section_formatter.nim  # Section headers
│   │   └── file_generator.nim     # Generate output files
│   └── ui/
│       └── colors.nim             # Terminal colors
```

## Philosophy

**KISS (Keep It Simple, Stupid):**
- Single binary, no runtime dependencies
- Generates portable text files that work anywhere
- Clean, readable code following Nim best practices
- Self-documenting output with detailed explanations

**Safety First:**
- Risk profiles prevent bootloops
- Dangerous packages commented out by default
- Interactive mode for testing unknowns
- Always generates restore.txt as backup

**Educational:**
- Each package has description
- Sections explain what/why/when
- FOSS alternatives listed
- Impact warnings prominent

## Contributing

We welcome device profiles! If you use `--debuginteractive`, please share your device folder:

1. Go to https://github.com/username/craft-fossifier/issues/new
2. Title: "Device Profile: [Device Name]"
3. Attach the entire device folder as ZIP
4. Describe your experience

## License

MIT License - See LICENSE file for details

## Disclaimer

⚠️ **Use at your own risk!** Removing system packages can cause instability or bootloops. Always:
- Start with `--dryrun` to preview
- Use risk profiles appropriate for your device
- Generate files first before executing
- Keep `restore.txt` as backup
- Test thoroughly after debloating

The authors are not responsible for any damage to your device.

## Credits

- Inspired by Universal Android Debloater
- Built with Nim programming language
- Package database curated from community contributions
