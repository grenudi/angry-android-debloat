import enums

type
  Package* = object
    uiName*: string
    packageName*: string
    bloatLevel*: BloatLevel
    description*: string
    riskyToRemoveOn*: seq[RiskProfile]
    section*: Section

proc initPackage*(uiName, packageName: string, bloatLevel: BloatLevel,
                  description: string, section: Section,
                  riskyToRemoveOn: seq[RiskProfile] = @[]): Package =
  Package(
    uiName: uiName,
    packageName: packageName,
    bloatLevel: bloatLevel,
    description: description,
    riskyToRemoveOn: riskyToRemoveOn,
    section: section
  )