#!/usr/bin/env python3
"""
FOSSify Android - Aggressive Android Debloat Tool
Remove vendor bloatware with bootloop protection
Especially optimized for Xiaomi/MIUI devices
"""

import subprocess
import sys
from enum import Enum
from dataclasses import dataclass
from typing import List, Tuple


class BloatLevel(Enum):
    """Bloat severity levels"""
    ABSOLUTE_TRASH = "🗑️  ABSOLUTE TRASH"
    VENDOR_BLOAT = "📱 VENDOR BLOAT"
    USELESS_FEATURES = "🎭 USELESS FEATURES"
    VENDOR_SECURITY = "🛡️  VENDOR SECURITY (Adware)"
    GOOGLE_BLOAT = "🔍 GOOGLE BLOAT"
    QUALCOMM_BLOAT = "⚙️  QUALCOMM BLOAT"
    CARRIER_BLOAT = "📡 CARRIER BLOAT"
    SYSTEM_UTILITIES = "🔧 SYSTEM UTILITIES"
    VENDOR_SYSTEM = "🎨 VENDOR SYSTEM"
    STOCK_APPS = "📲 STOCK APPS (Ad-Ridden)"
    NECESSARY_EVIL = "⚠️  NECESSARY EVIL"
    OTHER_CRUFT = "🧹 OTHER CRUFT"
    DANGEROUS = "☠️  DANGEROUS (Bootloop Risk)"


@dataclass
class Package:
    """App package data"""
    ui_name: str
    package_name: str
    bloat_level: BloatLevel
    description: str
    dangerous: bool = False


# Package lists organized by bloat level
LEVEL_1_ABSOLUTE_TRASH = [
    Package("Mi Analytics", "com.miui.analytics", BloatLevel.ABSOLUTE_TRASH, "Tracking and analytics"),
    Package("Mi Picks", "com.xiaomi.mipicks", BloatLevel.ABSOLUTE_TRASH, "App recommendations/ads"),
    Package("Mi Daemon", "com.miui.daemon", BloatLevel.ABSOLUTE_TRASH, "Background telemetry"),
    Package("Joyose", "com.xiaomi.joyose", BloatLevel.ABSOLUTE_TRASH, "Xiaomi service framework"),
    Package("Mi Share", "com.miui.mishare.connectivity", BloatLevel.ABSOLUTE_TRASH, "Mi Share connectivity"),
    Package("Fashion Gallery", "com.mfashiongallery.emag", BloatLevel.ABSOLUTE_TRASH, "Bloatware magazine"),
    Package("Trend News", "com.mi.globalTrendNews", BloatLevel.ABSOLUTE_TRASH, "News feed bloat"),
    Package("GLGM", "com.xiaomi.glgm", BloatLevel.ABSOLUTE_TRASH, "Xiaomi service"),
    Package("Mi Payment", "com.xiaomi.payment", BloatLevel.ABSOLUTE_TRASH, "Payment service"),
    Package("Mi Pay Wallet (ID)", "com.mipay.wallet.id", BloatLevel.ABSOLUTE_TRASH, "Indonesia wallet"),
    Package("Mi Pay Wallet (IN)", "com.mipay.wallet.in", BloatLevel.ABSOLUTE_TRASH, "India wallet"),
    Package("Content Extension", "com.miui.contentextension", BloatLevel.ABSOLUTE_TRASH, "Content suggestions"),
    Package("Hybrid", "com.miui.hybrid", BloatLevel.ABSOLUTE_TRASH, "Hybrid engine"),
    Package("Hybrid Accessory", "com.miui.hybrid.accessory", BloatLevel.ABSOLUTE_TRASH, "Hybrid accessory"),
    Package("Game Center", "com.xiaomi.gamecenter", BloatLevel.ABSOLUTE_TRASH, "Game store bloat"),
    Package("Game Center SDK", "com.xiaomi.gamecenter.sdk.service", BloatLevel.ABSOLUTE_TRASH, "Game SDK"),
    Package("App Vault", "com.mi.android.globalminusscreen", BloatLevel.ABSOLUTE_TRASH, "Left screen cards"),
    Package("Yellow Page", "com.miui.yellowpage", BloatLevel.ABSOLUTE_TRASH, "Yellow pages service"),
]

LEVEL_2_VENDOR_BLOAT = [
    Package("Mi Account", "com.xiaomi.account", BloatLevel.VENDOR_BLOAT, "Xiaomi account service"),
    Package("Mi Cloud Service", "com.miui.cloudservice", BloatLevel.VENDOR_BLOAT, "Cloud sync service"),
    Package("Mi Cloud Backup", "com.miui.cloudbackup", BloatLevel.VENDOR_BLOAT, "Cloud backup"),
    Package("Cloud Sysbase", "com.miui.cloudservice.sysbase", BloatLevel.VENDOR_BLOAT, "Cloud system base"),
    Package("Mi Backup", "com.miui.backup", BloatLevel.VENDOR_BLOAT, "Local backup app"),
    Package("JR Security", "com.xiaomi.jr.security", BloatLevel.VENDOR_BLOAT, "Financial security"),
    Package("Mi Discover", "com.xiaomi.discover", BloatLevel.VENDOR_BLOAT, "Content discovery"),
    Package("Personal Assistant", "com.mi.android.globalpersonalassistant", BloatLevel.VENDOR_BLOAT, "Assistant service"),
    Package("Mi Play Client", "com.xiaomi.miplay_client", BloatLevel.VENDOR_BLOAT, "Mi Play streaming"),
    Package("Mi Player", "com.miui.player", BloatLevel.VENDOR_BLOAT, "Video player"),
    Package("Mi Link", "com.milink.service", BloatLevel.VENDOR_BLOAT, "Device linking"),
    Package("UPnP", "com.xiaomi.upnp", BloatLevel.VENDOR_BLOAT, "UPnP service"),
    Package("Mi Drop", "com.xiaomi.midrop", BloatLevel.VENDOR_BLOAT, "File sharing"),
]

LEVEL_3_USELESS_FEATURES = [
    Package("VR Labs", "com.mi.dlabs.vr", BloatLevel.USELESS_FEATURES, "VR features"),
    Package("Kingsoft Translate", "com.miui.translation.kingsoft", BloatLevel.USELESS_FEATURES, "Translation service"),
    Package("Youdao Translate", "com.miui.translation.youdao", BloatLevel.USELESS_FEATURES, "Translation service"),
    Package("XMCloud Translate", "com.miui.translation.xmcloud", BloatLevel.USELESS_FEATURES, "Translation service"),
    Package("Translation Service", "com.miui.translationservice", BloatLevel.USELESS_FEATURES, "Translation framework"),
    Package("Freeform", "com.miui.freeform", BloatLevel.USELESS_FEATURES, "Freeform windows"),
    Package("Touch Assistant", "com.miui.touchassistant", BloatLevel.USELESS_FEATURES, "Touch assistant ball"),
    Package("Basic Dreams", "com.android.dreams.basic", BloatLevel.USELESS_FEATURES, "Screen saver"),
    Package("Photo Table Dreams", "com.android.dreams.phototable", BloatLevel.USELESS_FEATURES, "Photo screen saver"),
    Package("Easter Egg", "com.android.egg", BloatLevel.USELESS_FEATURES, "Android easter egg"),
    Package("Live Wallpaper Picker", "com.android.wallpaper.livepicker", BloatLevel.USELESS_FEATURES, "Live wallpapers"),
    Package("Wallpaper Cropper", "com.android.wallpapercropper", BloatLevel.USELESS_FEATURES, "Crop wallpapers"),
    Package("Wallpaper Backup", "com.android.wallpaperbackup", BloatLevel.USELESS_FEATURES, "Wallpaper backup"),
    Package("Mi Wallpaper", "com.miui.miwallpaper", BloatLevel.USELESS_FEATURES, "Mi wallpaper carousel"),
    Package("Print Spooler", "com.android.printspooler", BloatLevel.USELESS_FEATURES, "Print service"),
    Package("Print Service", "com.android.bips", BloatLevel.USELESS_FEATURES, "Built-in print"),
]

LEVEL_4_VENDOR_SECURITY = [
    Package("Security Add", "com.miui.securityadd", BloatLevel.VENDOR_SECURITY, "Security extras"),
    Package("SecProtect", "com.qapp.secprotect", BloatLevel.VENDOR_SECURITY, "Security protection"),
    Package("Guard Provider", "com.miui.guardprovider", BloatLevel.VENDOR_SECURITY, "Guard services"),
    Package("Power Checker", "com.xiaomi.powerchecker", BloatLevel.VENDOR_SECURITY, "Power monitoring"),
    Package("System Optimizer", "com.miui.sysopt", BloatLevel.VENDOR_SECURITY, "System optimizer"),
    Package("Cleaner", "com.miui.cleaner", BloatLevel.VENDOR_SECURITY, "Cleaner with ads"),
    Package("Clean Master", "com.miui.cleanmaster", BloatLevel.VENDOR_SECURITY, "Clean master"),
]

LEVEL_5_GOOGLE_BLOAT = [
    Package("Chrome", "com.android.chrome", BloatLevel.GOOGLE_BLOAT, "Google browser"),
    Package("Google Books", "com.google.android.apps.books", BloatLevel.GOOGLE_BLOAT, "Books app"),
    Package("Google Docs", "com.google.android.apps.docs", BloatLevel.GOOGLE_BLOAT, "Docs/Sheets/Slides"),
    Package("Google Magazines", "com.google.android.apps.magazines", BloatLevel.GOOGLE_BLOAT, "Newsstand"),
    Package("Google Maps", "com.google.android.apps.maps", BloatLevel.GOOGLE_BLOAT, "Maps app"),
    Package("Google Messages", "com.google.android.apps.messaging", BloatLevel.GOOGLE_BLOAT, "Messages app"),
    Package("Google Files", "com.google.android.apps.nbu.files", BloatLevel.GOOGLE_BLOAT, "Files app"),
    Package("Google Photos", "com.google.android.apps.photos", BloatLevel.GOOGLE_BLOAT, "Photos app"),
    Package("Google Duo", "com.google.android.apps.tachyon", BloatLevel.GOOGLE_BLOAT, "Video calls"),
    Package("Google Wallet", "com.google.android.apps.walletnfcrel", BloatLevel.GOOGLE_BLOAT, "Wallet/Pay"),
    Package("Backup Transport", "com.google.android.backuptransport", BloatLevel.GOOGLE_BLOAT, "Backup service"),
    Package("Config Updater", "com.google.android.configupdater", BloatLevel.GOOGLE_BLOAT, "Config updates"),
    Package("Ext Services", "com.google.android.ext.services", BloatLevel.GOOGLE_BLOAT, "Extended services"),
    Package("Ext Shared", "com.google.android.ext.shared", BloatLevel.GOOGLE_BLOAT, "Shared libs"),
    Package("Feedback", "com.google.android.feedback", BloatLevel.GOOGLE_BLOAT, "Feedback service"),
    Package("Gmail", "com.google.android.gm", BloatLevel.GOOGLE_BLOAT, "Gmail app"),
    Package("Gboard", "com.google.android.inputmethod.latin", BloatLevel.GOOGLE_BLOAT, "Google keyboard"),
    Package("Pinyin Input", "com.google.android.inputmethod.pinyin", BloatLevel.GOOGLE_BLOAT, "Chinese input"),
    Package("TalkBack", "com.google.android.marvin.talkback", BloatLevel.GOOGLE_BLOAT, "Accessibility"),
    Package("Google Music", "com.google.android.music", BloatLevel.GOOGLE_BLOAT, "Music app"),
    Package("One Time Init", "com.google.android.onetimeinitializer", BloatLevel.GOOGLE_BLOAT, "Setup initializer"),
    Package("Partner Setup", "com.google.android.partnersetup", BloatLevel.GOOGLE_BLOAT, "Partner setup"),
    Package("Setup Wizard", "com.google.android.setupwizard", BloatLevel.GOOGLE_BLOAT, "Setup wizard"),
    Package("Calendar Sync", "com.google.android.syncadapters.calendar", BloatLevel.GOOGLE_BLOAT, "Calendar sync"),
    Package("Contacts Sync", "com.google.android.syncadapters.contacts", BloatLevel.GOOGLE_BLOAT, "Contacts sync"),
    Package("Google Talk", "com.google.android.talk", BloatLevel.GOOGLE_BLOAT, "Hangouts service"),
    Package("Google TTS", "com.google.android.tts", BloatLevel.GOOGLE_BLOAT, "Text-to-speech"),
    Package("Google Videos", "com.google.android.videos", BloatLevel.GOOGLE_BLOAT, "Play Movies"),
    Package("YouTube", "com.google.android.youtube", BloatLevel.GOOGLE_BLOAT, "YouTube app"),
]

LEVEL_6_QUALCOMM_BLOAT = [
    Package("Perf Dump", "com.qualcomm.qti.perfdump", BloatLevel.QUALCOMM_BLOAT, "Performance dump"),
    Package("Sample ExtAuth", "com.qualcomm.qti.auth.sampleextauthservice", BloatLevel.QUALCOMM_BLOAT, "Auth sample"),
    Package("Sample Auth", "com.qualcomm.qti.auth.sampleauthenticatorservice", BloatLevel.QUALCOMM_BLOAT, "Auth sample"),
    Package("FIDO Crypto", "com.qualcomm.qti.auth.fidocryptoservice", BloatLevel.QUALCOMM_BLOAT, "FIDO service"),
    Package("Secure ExtAuth", "com.qualcomm.qti.auth.secureextauthservice", BloatLevel.QUALCOMM_BLOAT, "Secure auth"),
    Package("Secure Sample", "com.qualcomm.qti.auth.securesampleauthservice", BloatLevel.QUALCOMM_BLOAT, "Secure sample"),
    Package("Color Service", "com.qti.service.colorservice", BloatLevel.QUALCOMM_BLOAT, "Display color"),
    Package("CABL", "com.qualcomm.cabl", BloatLevel.QUALCOMM_BLOAT, "Adaptive backlight"),
    Package("SVI", "com.qualcomm.svi", BloatLevel.QUALCOMM_BLOAT, "SVI service"),
    Package("eMBMS", "com.qualcomm.embms", BloatLevel.QUALCOMM_BLOAT, "Broadcast service"),
    Package("Data Status", "com.qti.qualcomm.datastatusnotification", BloatLevel.QUALCOMM_BLOAT, "Data notification"),
    Package("Device Info", "com.qti.qualcomm.deviceinfo", BloatLevel.QUALCOMM_BLOAT, "Device info"),
    Package("QMMI", "com.qualcomm.qti.qmmi", BloatLevel.QUALCOMM_BLOAT, "Diagnostics"),
    Package("Time Service", "com.qualcomm.timeservice", BloatLevel.QUALCOMM_BLOAT, "Time service"),
    Package("ANT Server", "com.dsi.ant.server", BloatLevel.QUALCOMM_BLOAT, "ANT+ wireless"),
    Package("IMS Tests", "com.qti.vzw.ims.internal.tests", BloatLevel.QUALCOMM_BLOAT, "IMS testing"),
    Package("Fingerprint Ext", "com.fingerprints.serviceext", BloatLevel.QUALCOMM_BLOAT, "FP extensions"),
    Package("FIDO UAF", "com.fido.xiaomi.uafclient", BloatLevel.QUALCOMM_BLOAT, "FIDO client"),
    Package("FIDO ASM", "com.fido.asm", BloatLevel.QUALCOMM_BLOAT, "FIDO service"),
]

LEVEL_7_CARRIER_BLOAT = [
    Package("Cell Broadcast", "com.android.cellbroadcastreceiver", BloatLevel.CARRIER_BLOAT, "Emergency alerts"),
    Package("SMS Push", "com.android.smspush", BloatLevel.CARRIER_BLOAT, "SMS push service"),
    Package("CNE Service", "com.quicinc.cne.CNEService", BloatLevel.CARRIER_BLOAT, "Connectivity engine"),
    Package("UCE Shim", "com.qualcomm.qti.uceShimService", BloatLevel.CARRIER_BLOAT, "UCE service"),
    Package("UIM Remote Client", "com.qualcomm.uimremoteclient", BloatLevel.CARRIER_BLOAT, "UIM remote"),
    Package("UIM Remote Server", "com.qualcomm.uimremoteserver", BloatLevel.CARRIER_BLOAT, "UIM server"),
    Package("QCRIL MSG", "com.qualcomm.qcrilmsgtunnel", BloatLevel.CARRIER_BLOAT, "QCRIL tunnel"),
    Package("Radio Config", "com.qualcomm.qti.radioconfiginterface", BloatLevel.CARRIER_BLOAT, "Radio config"),
    Package("Load Carrier", "com.qualcomm.qti.loadcarrier", BloatLevel.CARRIER_BLOAT, "Carrier loader"),
    Package("Access Cache", "com.qualcomm.qti.accesscache", BloatLevel.CARRIER_BLOAT, "Access cache"),
    Package("Carrier Default", "com.android.carrierdefaultapp", BloatLevel.CARRIER_BLOAT, "Default carrier app"),
    Package("WAPI Cert", "com.wapi.wapicertmanage", BloatLevel.CARRIER_BLOAT, "WAPI certs"),
    Package("BT Multi-SIM", "org.codeaurora.btmultisim", BloatLevel.CARRIER_BLOAT, "Multi-SIM BT"),
    Package("XDivert", "com.qti.xdivert", BloatLevel.CARRIER_BLOAT, "Call divert"),
    Package("ConfURI Dialer", "com.qti.confuridialer", BloatLevel.CARRIER_BLOAT, "Conference dialer"),
    Package("Conf Dialer", "com.qualcomm.qti.confdialer", BloatLevel.CARRIER_BLOAT, "Conference dialer"),
    Package("Call Features", "com.qualcomm.qti.callfeaturessetting", BloatLevel.CARRIER_BLOAT, "Call settings"),
]

LEVEL_8_SYSTEM_UTILITIES = [
    Package("Calendar", "com.android.calendar", BloatLevel.SYSTEM_UTILITIES, "Stock calendar"),
    Package("Clock", "com.android.deskclock", BloatLevel.SYSTEM_UTILITIES, "Stock clock/alarm"),
    Package("Email", "com.android.email", BloatLevel.SYSTEM_UTILITIES, "Stock email"),
    Package("Sound Recorder", "com.android.soundrecorder", BloatLevel.SYSTEM_UTILITIES, "Audio recorder"),
    Package("Bug Report", "com.miui.bugreport", BloatLevel.SYSTEM_UTILITIES, "Bug reporting"),
    Package("Calculator", "com.miui.calculator", BloatLevel.SYSTEM_UTILITIES, "Calculator"),
    Package("Compass", "com.miui.compass", BloatLevel.SYSTEM_UTILITIES, "Compass app"),
    Package("FM Radio", "com.miui.fm", BloatLevel.SYSTEM_UTILITIES, "FM radio"),
    Package("FM Service", "com.miui.fmservice", BloatLevel.SYSTEM_UTILITIES, "FM service"),
    Package("Mi Cloud Sync", "com.miui.micloudsync", BloatLevel.SYSTEM_UTILITIES, "Cloud sync"),
    Package("Music", "com.miui.music", BloatLevel.SYSTEM_UTILITIES, "Music player"),
    Package("Notes", "com.miui.notes", BloatLevel.SYSTEM_UTILITIES, "Notes app"),
    Package("Weather Provider", "com.miui.providers.weather", BloatLevel.SYSTEM_UTILITIES, "Weather data"),
    Package("Screen Recorder", "com.miui.screenrecorder", BloatLevel.SYSTEM_UTILITIES, "Screen recorder"),
    Package("Video", "com.miui.video", BloatLevel.SYSTEM_UTILITIES, "Video app"),
    Package("Video Player", "com.miui.videoplayer", BloatLevel.SYSTEM_UTILITIES, "Video player"),
    Package("Voice Assistant", "com.miui.voiceassistant", BloatLevel.SYSTEM_UTILITIES, "Voice assistant"),
    Package("Weather", "com.miui.weather2", BloatLevel.SYSTEM_UTILITIES, "Weather app"),
    Package("Scanner", "com.xiaomi.scanner", BloatLevel.SYSTEM_UTILITIES, "QR/barcode scanner"),
    Package("Antispam", "com.miui.antispam", BloatLevel.SYSTEM_UTILITIES, "Spam filter"),
]

LEVEL_9_VENDOR_SYSTEM = [
    Package("Theme Manager", "com.android.thememanager", BloatLevel.VENDOR_SYSTEM, "Theme manager"),
    Package("Theme Module", "com.android.thememanager.module", BloatLevel.VENDOR_SYSTEM, "Theme module"),
    Package("MIUI System", "com.miui.system", BloatLevel.VENDOR_SYSTEM, "MIUI system"),
    Package("MIUI ROM", "com.miui.rom", BloatLevel.VENDOR_SYSTEM, "ROM info"),
    Package("Global Layout", "com.mi.globallayout", BloatLevel.VENDOR_SYSTEM, "Layout service"),
]

LEVEL_10_STOCK_APPS = [
    Package("MIUI Gallery", "com.miui.gallery", BloatLevel.STOCK_APPS, "Gallery with ADS! Replace with Fossify"),
    Package("File Explorer", "com.android.fileexplorer", BloatLevel.STOCK_APPS, "File manager with ADS!"),
    Package("Global File Explorer", "com.mi.android.globalFileexplorer", BloatLevel.STOCK_APPS, "File manager with ADS!"),
    Package("Stock Browser", "com.android.browser", BloatLevel.STOCK_APPS, "Stock browser"),
]

LEVEL_11_NECESSARY_EVIL = [
    Package("Camera", "com.android.camera", BloatLevel.NECESSARY_EVIL, "Stock camera (optional removal)"),
    Package("Vendor Launcher", "com.miui.home", BloatLevel.NECESSARY_EVIL, "Vendor launcher (optional removal)"),
]

# Google packages for degoogle mode
GOOGLE_DEGOOGLE = [
    Package("Play Store", "com.android.vending", BloatLevel.NECESSARY_EVIL, "Google Play Store"),
    Package("Google Services", "com.google.android.gms", BloatLevel.NECESSARY_EVIL, "Google Play Services"),
    Package("Google Framework", "com.google.android.gsf", BloatLevel.NECESSARY_EVIL, "Services framework"),
    Package("WebView", "com.google.android.webview", BloatLevel.NECESSARY_EVIL, "Web rendering"),
    Package("Package Installer", "com.google.android.packageinstaller", BloatLevel.NECESSARY_EVIL, "App installer"),
]

LEVEL_12_OTHER_CRUFT = [
    Package("Fashion Gallery", "com.miui.android.fashiongallery", BloatLevel.OTHER_CRUFT, "Fashion content"),
    Package("Gemini AutoInstall", "android.autoinstalls.config.Xiaomi.gemini", BloatLevel.OTHER_CRUFT, "Auto-install config"),
    Package("NFC Test", "com.android.NFCtestSvc", BloatLevel.OTHER_CRUFT, "NFC testing"),
    Package("NFC Tag", "com.android.apps.tag", BloatLevel.OTHER_CRUFT, "NFC tags"),
    Package("BT MIDI", "com.android.bluetoothmidiservice", BloatLevel.OTHER_CRUFT, "Bluetooth MIDI"),
    Package("Bookmark Provider", "com.android.bookmarkprovider", BloatLevel.OTHER_CRUFT, "Bookmark storage"),
    Package("Captive Portal", "com.android.captiveportallogin", BloatLevel.OTHER_CRUFT, "WiFi login"),
    Package("Companion Device", "com.android.companiondevicemanager", BloatLevel.OTHER_CRUFT, "Device pairing"),
    Package("CTS Shim", "com.android.cts.ctsshim", BloatLevel.OTHER_CRUFT, "Compatibility test"),
    Package("CTS Priv Shim", "com.android.cts.priv.ctsshim", BloatLevel.OTHER_CRUFT, "CTS privileged"),
    Package("Emergency Info", "com.android.emergency", BloatLevel.OTHER_CRUFT, "Emergency info"),
    Package("HTML Viewer", "com.android.htmlviewer", BloatLevel.OTHER_CRUFT, "HTML viewer"),
    Package("Managed Provision", "com.android.managedprovisioning", BloatLevel.OTHER_CRUFT, "Enterprise setup"),
    Package("Provision", "com.android.provision", BloatLevel.OTHER_CRUFT, "Device provision"),
    Package("Statement Service", "com.android.statementservice", BloatLevel.OTHER_CRUFT, "Statement service"),
    Package("System Updater", "com.android.updater", BloatLevel.OTHER_CRUFT, "System updates"),
    Package("VPN Dialogs", "com.android.vpndialogs", BloatLevel.OTHER_CRUFT, "VPN dialogs"),
    Package("Facebook Manager", "com.facebook.appmanager", BloatLevel.OTHER_CRUFT, "Facebook bloat"),
    Package("Facebook Services", "com.facebook.services", BloatLevel.OTHER_CRUFT, "Facebook services"),
    Package("Facebook System", "com.facebook.system", BloatLevel.OTHER_CRUFT, "Facebook system"),
    Package("Mi WebKit", "com.mi.webkit.core", BloatLevel.OTHER_CRUFT, "WebKit core"),
    Package("CIT", "com.miui.cit", BloatLevel.OTHER_CRUFT, "Hardware testing"),
    Package("Global Installer", "com.miui.global.packageinstaller", BloatLevel.OTHER_CRUFT, "Package installer"),
    Package("SMS Extra", "com.miui.smsextra", BloatLevel.OTHER_CRUFT, "SMS extras"),
    Package("WM Service", "com.miui.wmsvc", BloatLevel.OTHER_CRUFT, "Window manager"),
    Package("DPM Service", "com.qti.dpmserviceapp", BloatLevel.OTHER_CRUFT, "Data Power Management"),
    Package("Qualcomm Location", "com.qualcomm.location", BloatLevel.OTHER_CRUFT, "Location service"),
    Package("Power Off Alarm", "com.qualcomm.qti.poweroffalarm", BloatLevel.OTHER_CRUFT, "Power-off alarm"),
    Package("QTI System Service", "com.qualcomm.qti.qtisystemservice", BloatLevel.OTHER_CRUFT, "QTI service"),
    Package("WFD Service", "com.qualcomm.wfd.service", BloatLevel.OTHER_CRUFT, "WiFi Display"),
    Package("Mi Bluetooth", "com.xiaomi.bluetooth", BloatLevel.OTHER_CRUFT, "Mi Bluetooth"),
    Package("Mi Location", "com.xiaomi.location.fused", BloatLevel.OTHER_CRUFT, "Location provider"),
    Package("App Index", "com.xiaomi.providers.appindex", BloatLevel.OTHER_CRUFT, "App indexing"),
    Package("SIM Activate", "com.xiaomi.simactivate.service", BloatLevel.OTHER_CRUFT, "SIM activation"),
    Package("GPS Log", "org.codeaurora.gps.gpslogsave", BloatLevel.OTHER_CRUFT, "GPS logging"),
    Package("OpenMobile API", "org.simalliance.openmobileapi.service", BloatLevel.OTHER_CRUFT, "Open mobile API"),
    Package("Coolook", "top.coolook", BloatLevel.OTHER_CRUFT, "Unknown service"),
]

# Dangerous packages - NEVER remove these (Xiaomi/MIUI specific)
DANGEROUS_PACKAGES = [
    Package("Security Center", "com.miui.securitycenter", BloatLevel.DANGEROUS, "WILL CAUSE BOOTLOOP on Xiaomi!", dangerous=True),
    Package("Security Core", "com.miui.securitycore", BloatLevel.DANGEROUS, "Part of Security Center", dangerous=True),
    Package("Power Keeper", "com.miui.powerkeeper", BloatLevel.DANGEROUS, "May cause bootloop on Xiaomi", dangerous=True),
    Package("LBE Security", "com.lbe.security.miui", BloatLevel.DANGEROUS, "Security framework on Xiaomi", dangerous=True),
    Package("Find Device", "com.xiaomi.finddevice", BloatLevel.DANGEROUS, "Bootloop on MIUI 12.1+", dangerous=True),
    Package("Mi Cloud SDK", "com.xiaomi.micloud.sdk", BloatLevel.DANGEROUS, "Gallery dependency on Xiaomi", dangerous=True),
    Package("MIUI Core", "com.miui.core", BloatLevel.DANGEROUS, "System instability on Xiaomi", dangerous=True),
    Package("Carrier Config", "com.android.carrierconfig", BloatLevel.DANGEROUS, "May break carrier features", dangerous=True),
    Package("Qualcomm IMS", "com.qualcomm.qti.ims", BloatLevel.DANGEROUS, "VoLTE/VoWiFi (safe on most devices)", dangerous=False),
    Package("CodeAurora IMS", "org.codeaurora.ims", BloatLevel.DANGEROUS, "VoLTE/VoWiFi (safe on most devices)", dangerous=False),
]

# All package groups for normal debloat
ALL_GROUPS = [
    ("LEVEL 1: ABSOLUTE TRASH", LEVEL_1_ABSOLUTE_TRASH),
    ("LEVEL 2: VENDOR BLOAT", LEVEL_2_VENDOR_BLOAT),
    ("LEVEL 3: USELESS FEATURES", LEVEL_3_USELESS_FEATURES),
    ("LEVEL 4: VENDOR SECURITY", LEVEL_4_VENDOR_SECURITY),
    ("LEVEL 5: GOOGLE BLOAT", LEVEL_5_GOOGLE_BLOAT),
    ("LEVEL 6: QUALCOMM BLOAT", LEVEL_6_QUALCOMM_BLOAT),
    ("LEVEL 7: CARRIER BLOAT", LEVEL_7_CARRIER_BLOAT),
    ("LEVEL 8: SYSTEM UTILITIES", LEVEL_8_SYSTEM_UTILITIES),
    ("LEVEL 9: VENDOR SYSTEM", LEVEL_9_VENDOR_SYSTEM),
    ("LEVEL 10: STOCK APPS (Bloat)", LEVEL_10_STOCK_APPS),
    ("LEVEL 11: NECESSARY EVIL", LEVEL_11_NECESSARY_EVIL),
    ("LEVEL 12: OTHER CRUFT", LEVEL_12_OTHER_CRUFT),
]


def run_adb(command: List[str]) -> Tuple[int, str]:
    """Run ADB command and return status code and output"""
    try:
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            timeout=10
        )
        return result.returncode, result.stdout + result.stderr
    except subprocess.TimeoutExpired:
        return 1, "Command timed out"
    except Exception as e:
        return 1, str(e)


def check_adb_connection() -> bool:
    """Check if ADB is connected"""
    code, output = run_adb(["adb", "devices"])
    if code != 0:
        return False
    lines = output.strip().split('\n')
    return len(lines) > 1 and 'device' in lines[1]


def is_package_installed(package_name: str) -> bool:
    """Check if package is installed"""
    code, output = run_adb(["adb", "shell", "pm", "list", "packages", package_name])
    return code == 0 and package_name in output


def uninstall_package(package_name: str) -> bool:
    """Uninstall package for current user"""
    code, _ = run_adb(["adb", "shell", "pm", "uninstall", "-k", "--user", "0", package_name])
    return code == 0


def reinstall_package(package_name: str) -> bool:
    """Reinstall package for current user"""
    code, _ = run_adb(["adb", "shell", "cmd", "package", "install-existing", package_name])
    return code == 0


def print_header(text: str):
    """Print styled header"""
    print("\n" + "=" * 70)
    print(f"  {text}")
    print("=" * 70)


def print_level(text: str):
    """Print level header"""
    print(f"\n{'─' * 70}")
    print(f"  {text}")
    print(f"{'─' * 70}")


def print_package(pkg: Package, status: str = "", prefix: str = ""):
    """Print package info with status"""
    status_symbol = {
        "removed": "✓",
        "restored": "✓",
        "installed": "📦",
        "not_installed": "○",
        "failed": "✗",
        "skipped": "⊗",
    }.get(status, "•")
    
    danger_mark = " ⚠️ " if pkg.dangerous else ""
    print(f"  {prefix}{status_symbol} {pkg.ui_name:<30} {danger_mark}")
    if status in ["removed", "restored", "failed"]:
        print(f"     └─ {pkg.package_name}")


def dry_run_mode():
    """Dry run - check package installation status"""
    print_header("🔍 DRY RUN MODE - Package Status Check")
    
    if not check_adb_connection():
        print("\n❌ Error: No ADB device connected!")
        print("   Connect your device and enable USB debugging")
        return 1
    
    total_packages = 0
    installed_packages = 0
    
    for group_name, packages in ALL_GROUPS:
        print_level(group_name)
        for pkg in packages:
            total_packages += 1
            if is_package_installed(pkg.package_name):
                installed_packages += 1
                print_package(pkg, "installed")
            else:
                print_package(pkg, "not_installed")
    
    # Check Google packages
    print_level("🔍 GOOGLE SERVICES (For --fulldebloatdegoogle)")
    for pkg in GOOGLE_DEGOOGLE:
        total_packages += 1
        if is_package_installed(pkg.package_name):
            installed_packages += 1
            print_package(pkg, "installed")
        else:
            print_package(pkg, "not_installed")
    
    # Check dangerous packages
    print_level("☠️  DANGEROUS PACKAGES (Never removed)")
    for pkg in DANGEROUS_PACKAGES:
        total_packages += 1
        if is_package_installed(pkg.package_name):
            installed_packages += 1
            print_package(pkg, "installed")
        else:
            print_package(pkg, "not_installed")
    
    print_header("📊 Summary")
    print(f"  Total packages checked: {total_packages}")
    print(f"  Installed: {installed_packages}")
    print(f"  Not installed: {total_packages - installed_packages}")
    
    return 0


def debloat_mode(full_degoogle: bool = False):
    """Debloat - remove bloatware packages"""
    mode_name = "FULL DEBLOAT + DEGOOGLE" if full_degoogle else "DEBLOAT MODE"
    print_header(f"🗑️  {mode_name} - Removing Bloatware")
    
    if full_degoogle:
        print("⚠️  DEGOOGLE MODE: Will remove Play Store and Google Services!")
        print("    Banking apps, Google Maps, and many games will NOT work!")
    else:
        print("⚠️  Play Store and Google Services will be KEPT")
    
    print("    Dangerous packages will be SKIPPED to prevent bootloop")
    
    if not check_adb_connection():
        print("\n❌ Error: No ADB device connected!")
        print("   Connect your device and enable USB debugging")
        return 1
    
    input("\nPress Enter to continue or Ctrl+C to cancel...")
    
    removed = 0
    failed = 0
    skipped = 0
    
    # Process regular packages
    for group_name, packages in ALL_GROUPS:
        print_level(group_name)
        for pkg in packages:
            if not is_package_installed(pkg.package_name):
                print_package(pkg, "not_installed", "  ")
                continue
            
            if uninstall_package(pkg.package_name):
                print_package(pkg, "removed", "  ")
                removed += 1
            else:
                print_package(pkg, "failed", "  ")
                failed += 1
    
    # Process Google packages if degoogle mode
    if full_degoogle:
        print_level("🔍 REMOVING GOOGLE SERVICES (Degoogle)")
        for pkg in GOOGLE_DEGOOGLE:
            if not is_package_installed(pkg.package_name):
                print_package(pkg, "not_installed", "  ")
                continue
            
            if uninstall_package(pkg.package_name):
                print_package(pkg, "removed", "  ")
                removed += 1
            else:
                print_package(pkg, "failed", "  ")
                failed += 1
    
    # Skip dangerous packages
    print_level("☠️  DANGEROUS PACKAGES - SKIPPED FOR SAFETY")
    for pkg in DANGEROUS_PACKAGES:
        if pkg.dangerous and is_package_installed(pkg.package_name):
            print_package(pkg, "skipped", "  ")
            print(f"     └─ Reason: {pkg.description}")
            skipped += 1
    
    print_header("✅ Debloat Complete!")
    print(f"  Removed: {removed}")
    print(f"  Failed: {failed}")
    print(f"  Skipped (dangerous): {skipped}")
    
    if full_degoogle:
        print(f"\n  🎯 Next Steps (DEGOOGLE MODE):")
        print(f"     1. Reboot: adb reboot")
        print(f"     2. Install F-Droid manually from https://f-droid.org")
        print(f"     3. Install apps from F-Droid only")
        print(f"     4. Use Aurora Store for Play Store apps (optional)")
    else:
        print(f"\n  🎯 Next Steps:")
        print(f"     1. Reboot: adb reboot")
        print(f"     2. Install FOSS apps: ./install-foss.sh")
        print(f"     3. Test everything works")
    
    return 0


def restore_mode():
    """Restore - reinstall all packages"""
    print_header("♻️  RESTORE MODE - Reinstalling Packages")
    
    if not check_adb_connection():
        print("\n❌ Error: No ADB device connected!")
        print("   Connect your device and enable USB debugging")
        return 1
    
    print("\n⚠️  This will restore ALL packages (including Google Services)")
    input("Press Enter to continue or Ctrl+C to cancel...")
    
    restored = 0
    failed = 0
    already_installed = 0
    
    # Restore regular packages
    for group_name, packages in ALL_GROUPS:
        print_level(group_name)
        for pkg in packages:
            if is_package_installed(pkg.package_name):
                print_package(pkg, "installed", "  ")
                already_installed += 1
                continue
            
            if reinstall_package(pkg.package_name):
                print_package(pkg, "restored", "  ")
                restored += 1
            else:
                print_package(pkg, "failed", "  ")
                failed += 1
    
    # Restore Google packages
    print_level("🔍 GOOGLE SERVICES")
    for pkg in GOOGLE_DEGOOGLE:
        if is_package_installed(pkg.package_name):
            print_package(pkg, "installed", "  ")
            already_installed += 1
            continue
        
        if reinstall_package(pkg.package_name):
            print_package(pkg, "restored", "  ")
            restored += 1
        else:
            print_package(pkg, "failed", "  ")
            failed += 1
    
    # Restore dangerous packages (non-dangerous ones only)
    print_level("☠️  DANGEROUS PACKAGES")
    for pkg in DANGEROUS_PACKAGES:
        if is_package_installed(pkg.package_name):
            print_package(pkg, "installed", "  ")
            already_installed += 1
            continue
        
        if reinstall_package(pkg.package_name):
            print_package(pkg, "restored", "  ")
            restored += 1
        else:
            print_package(pkg, "failed", "  ")
            failed += 1
    
    print_header("✅ Restore Complete!")
    print(f"  Restored: {restored}")
    print(f"  Failed: {failed}")
    print(f"  Already installed: {already_installed}")
    print(f"\n  💡 Reboot recommended: adb reboot")
    
    return 0


def print_usage():
    """Print usage information"""
    print("""
╔══════════════════════════════════════════════════════════════════╗
║              FOSSify Android - Debloat Tool v2.0                 ║
║              Bootloop-protected bloatware removal                ║
║              Especially optimized for Xiaomi/MIUI devices        ║
╚══════════════════════════════════════════════════════════════════╝

Usage:
  python3 debloat.py [MODE]

Modes:
  --dryrun              Check package status (no changes)
  --debloat             Remove bloat (keeps Play Store & GMS)
  --fulldebloatdegoogle Remove EVERYTHING including Google Services
  --restore             Restore all removed packages

Examples:
  python3 debloat.py --dryrun              # Safe check
  python3 debloat.py --debloat             # Remove bloat
  python3 debloat.py --fulldebloatdegoogle # Full FOSS mode
  python3 debloat.py --restore             # Undo everything

What Gets Removed:
  • --debloat: ~190 packages (keeps Play Store, Camera, Launcher)
  • --fulldebloatdegoogle: ~195 packages (removes Google Services too)

Stock Apps REMOVED in both modes:
  • Gallery (has ads) - install Fossify Gallery first!
  • File Manager (has ads) - install Material Files first!
  • Browser - install Fennec/Mull first!

Dangerous Packages (Auto-Skipped on Xiaomi/MIUI):
  • com.miui.securitycenter    - WILL cause bootloop
  • com.miui.powerkeeper       - May cause bootloop
  • com.xiaomi.finddevice      - Bootloop on MIUI 12.1+
  • com.miui.core              - System instability

Requirements:
  • ADB installed and in PATH
  • USB debugging enabled
  • Device connected via USB

Learn more: https://github.com/yourusername/fossify-android
""")


def main():
    """Main entry point"""
    if len(sys.argv) != 2:
        print_usage()
        return 1
    
    mode = sys.argv[1].lower()
    
    if mode == "--dryrun":
        return dry_run_mode()
    elif mode == "--debloat":
        return debloat_mode(full_degoogle=False)
    elif mode == "--fulldebloatdegoogle":
        return debloat_mode(full_degoogle=True)
    elif mode == "--restore":
        return restore_mode()
    else:
        print(f"\n❌ Unknown mode: {mode}\n")
        print_usage()
        return 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\n\n⚠️  Operation cancelled by user")
        sys.exit(130)