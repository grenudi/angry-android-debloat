type
  Mode* = enum
    modeNone
    modeDryrun
    modeGenerate
    modeDebloat
    modeRestore
    modeDebugInteractive

  Config* = object
    mode*: Mode
    riskProfiles*: seq[string]
    unsafe*: bool
    outputDir*: string
    deviceName*: string
    codename*: string