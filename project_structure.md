# Craft FOSSifier - Complete Project Structure

## Directory Tree

```
craft_fossifier/
│
├── README.md                      # Main documentation
├── PROJECT_STRUCTURE.md          # This file
├── LICENSE                       # MIT License
├── craft_fossifier.nimble        # Nimble package definition
│
├── src/                          # Source code
│   │
│   ├── craft_fossifier.nim       # MAIN ENTRY POINT
│   │                             # - Command line parsing
│   │                             # - Mode routing
│   │                             # - Help/version display
│   │
│   ├── types/                    # Type definitions
│   │   ├── enums.nim            # Enumerations
│   │   │                         # - RiskProfile (xiaomi, miui, googleservices, custom, core)
│   │   │                         # - BloatLevel (10 categories)
│   │   │                         # - Section (10 sections, sec1-sec10)
│   │   │
│   │   ├── package.nim          # Package type
│   │   │                         # - Package object definition
│   │   │                         # - initPackage() constructor
│   │   │
│   │   └── config.nim           # Configuration type
│   │                             # - Mode enum
│   │                             # - Config object (mode, profiles, flags, paths)
│   │
│   ├── data/                    # Package database
│   │   └── all_packages.nim     # Complete package list (~250 packages)
│   │                             # - Organized by sections (1-10)
│   │                             # - Each with risk profiles assigned
│   │                             # - SINGLE source of truth
│   │
│   ├── core/                    # Core functionality
│   │   ├── adb.nim              # ADB interface
│   │   │                         # - runAdbCommand()
│   │   │                         # - checkAdbConnection()
│   │   │                         # - isPackageInstalled()
│   │   │                         # - uninstallPackage()
│   │   │                         # - reinstallPackage()
│   │   │
│   │   └── risk_analyzer.nim    # Risk profile filtering
│   │                             # - shouldSkipPackage()
│   │                             # - Matches package risks vs user profiles
│   │
│   ├── modes/                   # Execution modes
│   │   ├── dryrun.nim           # Preview mode (no device needed)
│   │   │                         # - Shows what would be removed
│   │   │                         # - Color-coded output by risk
│   │   │                         # - Statistics summary
│   │   │
│   │   ├── generate.nim         # File generation mode (no device needed)
│   │   │                         # - Generates debloat.txt
│   │   │                         # - Generates restore.txt
│   │   │                         # - No execution, just files
│   │   │
│   │   ├── debloat.nim          # Execution mode (device required)
│   │   │                         # - Generates files
│   │   │                         # - Executes removals via ADB
│   │   │                         # - Real-time feedback
│   │   │
│   │   ├── restore.nim          # Restore mode (device required)
│   │   │                         # - Reinstalls all packages
│   │   │                         # - Progress feedback
│   │   │
│   │   └── debug_interactive.nim # Interactive debug mode (device required)
│   │                             # - One-by-one package removal
│   │                             # - User testing after each removal
│   │                             # - Auto-restore problematic packages
│   │                             # - Generates device profile folder
│   │
│   ├── output/                  # File generation
│   │   ├── section_formatter.nim # Section header templates
│   │   │                         # - getSectionHeader() for each section
│   │   │                         # - Rich documentation in headers
│   │   │                         # - Safety indicators, alternatives, warnings
│   │   │
│   │   └── file_generator.nim   # Generate output files
│   │                             # - generateDebloatFile()
│   │                             # - generateRestoreFile()
│   │                             # - Organizes packages by section
│   │                             # - Handles skipped packages
│   │                             # - Comments out risky sections
│   │
│   └── ui/                      # User interface utilities
│       └── colors.nim           # Terminal colors
│                                 # - printSuccess() - green
│                                 # - printError() - red
│                                 # - printWarning() - yellow
│                                 # - printInfo() - cyan
│                                 # - printSkipped() - yellow
│                                 # - printPackage() - blue
│
└── tests/                       # Unit tests (optional)
    ├── test_packages.nim
    ├── test_risk_analyzer.nim
    └── test_file_generator.nim
```

## File Responsibilities

### Main Entry Point
- **craft_fossifier.nim**: CLI parsing, mode routing, help display

### Type System
- **types/enums.nim**: All enumerations (RiskProfile, BloatLevel, Section)
- **types/package.nim**: Package data structure
- **types/config.nim**: Runtime configuration

### Data
- **data/all_packages.nim**: Single source of all ~250 packages
  - Each package has: name, package name, level, description, section, risk profiles
  - Organized by sections (1-10) for clarity

### Core Logic
- **core/adb.nim**: All ADB operations wrapped in clean functions
- **core/risk_analyzer.nim**: Determines if package should be skipped based on risk profiles

### Mode Implementations
Each mode is self-contained:
- **modes/dryrun.nim**: Preview without device
- **modes/generate.nim**: Generate files without device
- **modes/debloat.nim**: Generate + execute with device
- **modes/restore.nim**: Restore packages
- **modes/debug_interactive.nim**: Interactive testing + profile generation

### Output Generation
- **output/section_formatter.nim**: Rich section headers with docs
- **output/file_generator.nim**: Assembles debloat.txt and restore.txt

### UI
- **ui/colors.nim**: Consistent colored terminal output

## Data Flow

### Generate Mode (Primary Use Case)
```
User runs: --generate --leave-risky-to-remove-for xiaomi miui
    ↓
main() parses args → Config object
    ↓
generate.run(config)
    ↓
file_generator.generateDebloatFile()
    ├→ Reads allPackages from data/all_packages.nim
    ├→ Calls risk_analyzer.shouldSkipPackage() for each
    ├→ Organizes into sections
    ├→ Writes debloat.txt with:
    │   ├→ Header (metadata)
    │   ├→ Section 1 header + commands
    │   ├→ Section 2 header + commands
    │   ├→ ... (all 10 sections)
    │   └→ Footer (summary, instructions)
    └→ Comments out Section 7 (camera/launcher) and Section 10 (Google Services)
    ↓
file_generator.generateRestoreFile()
    └→ Same packages, restore commands
    ↓
Output: debloat.txt + restore.txt
```

### Debug Interactive Mode
```
User runs: --debuginteractive --leave-risky-to-remove-for xiaomi miui
    ↓
debug_interactive.run(config)
    ├→ Asks for device name + codename
    ├→ Creates folder: "Device Name - codename/"
    ├→ For each package in allPackages:
    │   ├→ Skip if matches risk profiles
    │   ├→ Ask user: "Remove?"
    │   ├→ If yes: uninstall via adb.nim
    │   ├→ Ask user: "Working?"
    │   └→ If no: restore via adb.nim + log as problematic
    ├→ Generates debloat.txt in folder
    ├→ Generates restore.txt in folder
    ├→ Generates problematic_packages.txt
    └→ Shows contribution instructions
```

## Build & Run

```bash
# Build release binary
nimble build

# Run directly
nim c -r src/craft_fossifier.nim --help

# Run with arguments
./craft_fossifier --generate --leave-risky-to-remove-for xiaomi miui googleservices
```

## Output Files

### debloat.txt Structure
```
# Header (metadata, warnings)
# Section 1: ABSOLUTE TRASH
#   - Safety info
#   - What's removed
#   - Impact
#   - Skipped packages (if any)
adb shell pm uninstall -k --user 0 com.miui.analytics
adb shell pm uninstall -k --user 0 com.xiaomi.mipicks
...

# Section 2: VENDOR BLOAT
...

# Section 10: GOOGLE SERVICES (commented by default)
# adb shell pm uninstall -k --user 0 com.google.android.gms

# Footer (summary, instructions)
```

### restore.txt Structure
```
# Header
# Section 1
adb shell cmd package install-existing com.miui.analytics
...
# Section 2
...
# Footer
```

## Key Design Decisions

### 1. Single Package Database
- All packages in `data/all_packages.nim`
- No splitting by level/section
- Organized visually with comments
- Easy to maintain and extend

### 2. Section-Based Organization
- 10 sections, ordered by risk
- Each section gets detailed header in output
- Sections 7 and 10 commented by default
- User can execute selectively

### 3. Risk Profile System
- Flexible: multiple profiles per package
- Core packages ALWAYS skipped
- User specifies profiles to respect
- --unsafe to override (debloat mode only)

### 4. Portable Output
- Plain text files with ADB commands
- OS-agnostic (Windows/Linux/macOS)
- Self-documenting with rich comments
- No dependencies to use (just ADB)

### 5. Nim Implementation
- Single binary, no runtime deps
- Fast compilation
- Clean, readable code
- Strong type system
- Excellent CLI tools (terminal, os, strutils)

## Extension Points

### Adding New Packages
Edit `data/all_packages.nim`:
```nim
initPackage("New App", "com.example.app", blAbsoluteTrash,
  "Description here", sec1AbsoluteTrash, @[rpXiaomi])
```

### Adding New Risk Profiles
1. Add to `types/enums.nim`: `rpNewProfile = "newprofile"`
2. Assign to packages in `data/all_packages.nim`
3. Update help text in `craft_fossifier.nim`

### Adding New Sections
1. Add to `types/enums.nim`: `sec11NewSection = 11`
2. Add header in `output/section_formatter.nim`
3. Assign to packages in `data/all_packages.nim`

### Adding New Modes
1. Create `modes/newmode.nim`
2. Implement `run*(config: Config)` proc
3. Add to mode enum in `types/config.nim`
4. Add case in `craft_fossifier.nim` main

## Code Quality Guidelines

- **KISS**: Simple, straightforward code
- **DRY**: No duplication (data, logic, or output)
- **Single Responsibility**: Each module does one thing
- **Type Safety**: Use enums and strong types
- **Error Handling**: Try-except where needed
- **User Feedback**: Rich terminal output
- **Documentation**: Comments where needed, self-documenting code

## Testing Strategy

```bash
# Manual testing workflow
nim c -r src/craft_fossifier.nim --dryrun --leave-risky-to-remove-for xiaomi miui
nim c -r src/craft_fossifier.nim --generate --leave-risky-to-remove-for xiaomi miui
cat debloat.txt  # Verify output
cat restore.txt  # Verify output

# With device connected
nim c -r src/craft_fossifier.nim --debloat --leave-risky-to-remove-for xiaomi miui googleservices
# Check device still works
nim c -r src/craft_fossifier.nim --restore
# Device should be back to normal
```

## Performance Notes

- **Compilation**: ~2-5 seconds
- **Binary size**: ~500KB (release build)
- **Runtime**: Instant for generate/dryrun, depends on ADB for others
- **Memory**: Minimal (<10MB)

## Future Enhancements

- [ ] JSON/YAML output format option
- [ ] Web UI for file generation
- [ ] Community device profile repository
- [ ] Auto-detect device and suggest profiles
- [ ] Backup/restore configuration
- [ ] Batch mode for multiple devices
- [ ] Integration with F-Droid installer script
