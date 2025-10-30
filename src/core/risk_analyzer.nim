import std/strutils
import ../types/[enums, package]

proc shouldSkipPackage*(pkg: Package, riskProfiles: seq[string]): tuple[skip: bool, reason: string] =
  # Always skip CORE packages
  if rpCore in pkg.riskyToRemoveOn:
    return (true, "Core system package (never removed)")
  
  # Check if package matches any user-specified risk profiles
  for riskProfile in pkg.riskyToRemoveOn:
    let profileStr = ($riskProfile).toLowerAscii()
    if profileStr in riskProfiles:
      return (true, "Risky on " & $riskProfile)
  
  return (false, "")