type
  RiskProfile* = enum
    rpXiaomi = "xiaomi"
    rpMiui = "miui"
    rpGoogleServices = "googleservices"
    rpCustom = "custom"
    rpCore = "core"

  BloatLevel* = enum
    blAbsoluteTrash = "Absolute Trash"
    blVendorBloat = "Vendor Bloat"
    blUselessFeatures = "Useless Features"
    blVendorSecurity = "Vendor Security (Adware)"
    blGoogleBloat = "Google Bloat"
    blQualcommCarrier = "Qualcomm/Carrier Bloat"
    blStockApps = "Stock Vendor Apps"
    blCameraLauncher = "Camera/Launcher"
    blGooglePlayStore = "Google Play Store"
    blGoogleServices = "Google Services (Nuclear)"

  Section* = enum
    sec1AbsoluteTrash = 1
    sec2VendorBloat = 2
    sec3UselessFeatures = 3
    sec4VendorSecurity = 4
    sec5QualcommCarrier = 5
    sec6StockApps = 6
    sec7CameraLauncher = 7
    sec8GoogleBloat = 8
    sec9PlayStore = 9
    sec10GoogleServices = 10

proc `$`*(rp: RiskProfile): string =
  case rp
  of rpXiaomi: "XIAOMI"
  of rpMiui: "MIUI"
  of rpGoogleServices: "GOOGLE_SERVICES"
  of rpCustom: "CUSTOM"
  of rpCore: "CORE"

proc toRiskProfile*(s: string): RiskProfile =
  case s.toLowerAscii()
  of "xiaomi": rpXiaomi
  of "miui": rpMiui
  of "googleservices": rpGoogleServices
  of "custom": rpCustom
  of "core": rpCore
  else: raise newException(ValueError, "Unknown risk profile: " & s)