#!/bin/bash
# Xiaomi Restore Script - Reinstall ALL removed packages
# Organized by same levels as debloat script

echo "=========================================="
echo "XIAOMI RESTORE SCRIPT"
echo "=========================================="
echo "This will restore ALL packages (organized by bloat level)"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

echo ""
echo "=== Restoring LEVEL 1: Absolute Trash ==="
adb shell cmd package install-existing com.miui.analytics
adb shell cmd package install-existing com.xiaomi.mipicks
adb shell cmd package install-existing com.miui.daemon
adb shell cmd package install-existing com.xiaomi.joyose
adb shell cmd package install-existing com.miui.mishare.connectivity
adb shell cmd package install-existing com.mfashiongallery.emag
adb shell cmd package install-existing com.mi.globalTrendNews
adb shell cmd package install-existing com.xiaomi.glgm
adb shell cmd package install-existing com.xiaomi.payment
adb shell cmd package install-existing com.mipay.wallet.id
adb shell cmd package install-existing com.miui.contentextension
adb shell cmd package install-existing com.miui.hybrid
adb shell cmd package install-existing com.miui.hybrid.accessory
adb shell cmd package install-existing com.xiaomi.gamecenter
adb shell cmd package install-existing com.xiaomi.gamecenter.sdk.service
adb shell cmd package install-existing com.mi.android.globalminusscreen
adb shell cmd package install-existing com.miui.yellowpage

echo ""
echo "=== Restoring LEVEL 2: Xiaomi Bloat ==="
adb shell cmd package install-existing com.xiaomi.account
adb shell cmd package install-existing com.xiaomi.micloud.sdk
adb shell cmd package install-existing com.miui.cloudservice
adb shell cmd package install-existing com.miui.cloudbackup
adb shell cmd package install-existing com.miui.cloudservice.sysbase
adb shell cmd package install-existing com.xiaomi.finddevice
adb shell cmd package install-existing com.miui.backup
adb shell cmd package install-existing com.xiaomi.jr.security
adb shell cmd package install-existing com.xiaomi.discover
adb shell cmd package install-existing com.mi.android.globalpersonalassistant
adb shell cmd package install-existing com.xiaomi.miplay_client
adb shell cmd package install-existing com.miui.player
adb shell cmd package install-existing com.milink.service
adb shell cmd package install-existing com.xiaomi.upnp

echo ""
echo "=== Restoring LEVEL 3: Useless Features ==="
adb shell cmd package install-existing com.mi.dlabs.vr
adb shell cmd package install-existing com.miui.translation.kingsoft
adb shell cmd package install-existing com.miui.translation.youdao
adb shell cmd package install-existing com.miui.translation.xmcloud
adb shell cmd package install-existing com.miui.freeform
adb shell cmd package install-existing com.miui.touchassistant
adb shell cmd package install-existing com.android.dreams.basic
adb shell cmd package install-existing com.android.dreams.phototable
adb shell cmd package install-existing com.android.egg
adb shell cmd package install-existing com.android.wallpaper.livepicker
adb shell cmd package install-existing com.android.wallpapercropper
adb shell cmd package install-existing com.android.wallpaperbackup
adb shell cmd package install-existing com.android.printspooler
adb shell cmd package install-existing com.android.bips

echo ""
echo "=== Restoring LEVEL 4: MIUI Security/Cleaner ==="
adb shell cmd package install-existing com.miui.securitycenter
adb shell cmd package install-existing com.miui.securityadd
adb shell cmd package install-existing com.miui.securitycore
adb shell cmd package install-existing com.qapp.secprotect
adb shell cmd package install-existing com.lbe.security.miui
adb shell cmd package install-existing com.miui.guardprovider
adb shell cmd package install-existing com.miui.powerkeeper
adb shell cmd package install-existing com.xiaomi.powerchecker
adb shell cmd package install-existing com.miui.sysopt
adb shell cmd package install-existing com.miui.cleaner

echo ""
echo "=== Restoring LEVEL 5: Google Bloat ==="
adb shell cmd package install-existing com.google.android.gm
adb shell cmd package install-existing com.android.chrome
adb shell cmd package install-existing com.google.android.youtube
adb shell cmd package install-existing com.google.android.music
adb shell cmd package install-existing com.google.android.videos
adb shell cmd package install-existing com.google.android.apps.maps
adb shell cmd package install-existing com.google.android.apps.docs
adb shell cmd package install-existing com.google.android.tts
adb shell cmd package install-existing com.google.android.marvin.talkback
adb shell cmd package install-existing com.google.android.inputmethod.pinyin
adb shell cmd package install-existing com.google.android.inputmethod.latin
adb shell cmd package install-existing com.google.android.ext.services
adb shell cmd package install-existing com.google.android.ext.shared
adb shell cmd package install-existing com.google.android.onetimeinitializer
adb shell cmd package install-existing com.google.android.configupdater
adb shell cmd package install-existing com.google.android.setupwizard
adb shell cmd package install-existing com.google.android.partnersetup
adb shell cmd package install-existing com.google.android.syncadapters.calendar
adb shell cmd package install-existing com.google.android.syncadapters.contacts
adb shell cmd package install-existing com.google.android.backuptransport

echo ""
echo "=== Restoring LEVEL 6: Qualcomm Bloat ==="
adb shell cmd package install-existing com.qualcomm.qti.perfdump
adb shell cmd package install-existing com.qualcomm.qti.auth.sampleextauthservice
adb shell cmd package install-existing com.qualcomm.qti.auth.sampleauthenticatorservice
adb shell cmd package install-existing com.qualcomm.qti.auth.fidocryptoservice
adb shell cmd package install-existing com.qualcomm.qti.auth.secureextauthservice
adb shell cmd package install-existing com.qualcomm.qti.auth.securesampleauthservice
adb shell cmd package install-existing com.qti.service.colorservice
adb shell cmd package install-existing com.qualcomm.cabl
adb shell cmd package install-existing com.qualcomm.svi
adb shell cmd package install-existing com.qualcomm.embms
adb shell cmd package install-existing com.qti.qualcomm.datastatusnotification
adb shell cmd package install-existing com.qti.qualcomm.deviceinfo
adb shell cmd package install-existing com.qualcomm.qti.qmmi
adb shell cmd package install-existing com.qualcomm.timeservice
adb shell cmd package install-existing com.dsi.ant.server
adb shell cmd package install-existing com.qti.vzw.ims.internal.tests
adb shell cmd package install-existing com.fingerprints.serviceext
adb shell cmd package install-existing com.fido.xiaomi.uafclient
adb shell cmd package install-existing com.fido.asm

echo ""
echo "=== Restoring LEVEL 7: Carrier/Network Bloat ==="
adb shell cmd package install-existing com.android.cellbroadcastreceiver
adb shell cmd package install-existing com.android.smspush
adb shell cmd package install-existing com.quicinc.cne.CNEService
adb shell cmd package install-existing com.qualcomm.qti.uceShimService
adb shell cmd package install-existing com.qualcomm.uimremoteclient
adb shell cmd package install-existing com.qualcomm.uimremoteserver
adb shell cmd package install-existing com.qualcomm.qcrilmsgtunnel
adb shell cmd package install-existing com.qualcomm.qti.radioconfiginterface
adb shell cmd package install-existing com.qualcomm.qti.loadcarrier
adb shell cmd package install-existing com.qualcomm.qti.accesscache
adb shell cmd package install-existing com.android.carrierdefaultapp
adb shell cmd package install-existing com.android.carrierconfig
adb shell cmd package install-existing com.wapi.wapicertmanage
adb shell cmd package install-existing org.codeaurora.btmultisim
adb shell cmd package install-existing com.qti.xdivert
adb shell cmd package install-existing com.qti.confuridialer
adb shell cmd package install-existing com.qualcomm.qti.confdialer
adb shell cmd package install-existing com.qualcomm.qti.callfeaturessetting

echo ""
echo "=== Restoring LEVEL 8: System Utilities ==="
adb shell cmd package install-existing com.android.calendar
adb shell cmd package install-existing com.android.deskclock
adb shell cmd package install-existing com.android.email
adb shell cmd package install-existing com.miui.weather2
adb shell cmd package install-existing com.android.soundrecorder
adb shell cmd package install-existing com.miui.screenrecorder
adb shell cmd package install-existing com.miui.notes
adb shell cmd package install-existing com.miui.calculator

echo ""
echo "=== Restoring LEVEL 9: MIUI System ==="
adb shell cmd package install-existing com.android.thememanager
adb shell cmd package install-existing com.android.thememanager.module
adb shell cmd package install-existing com.miui.system
adb shell cmd package install-existing com.miui.rom
adb shell cmd package install-existing com.miui.core
adb shell cmd package install-existing com.mi.globallayout

echo ""
echo "=== Restoring LEVEL 10: Necessary Evil (if removed) ==="
# These are kept by default in debloat, only restore if manually removed
echo "Restoring Gallery, File Manager, Camera (if removed)..."
adb shell cmd package install-existing com.miui.gallery
adb shell cmd package install-existing com.android.fileexplorer
adb shell cmd package install-existing com.mi.android.globalFileexplorer
adb shell cmd package install-existing com.android.camera
adb shell cmd package install-existing com.miui.home

echo "Restoring Play Store & GMS (if removed)..."
adb shell cmd package install-existing com.android.vending
adb shell cmd package install-existing com.google.android.gms
adb shell cmd package install-existing com.google.android.gsf
adb shell cmd package install-existing com.google.android.webview
adb shell cmd package install-existing com.google.android.packageinstaller

echo "Restoring VoLTE packages (if removed)..."
adb shell cmd package install-existing com.qualcomm.qti.ims
adb shell cmd package install-existing org.codeaurora.ims

echo ""
echo "=== Restoring Other Cruft ==="
adb shell cmd package install-existing com.android.cts.priv.ctsshim
adb shell cmd package install-existing com.android.cts.ctsshim
adb shell cmd package install-existing org.simalliance.openmobileapi.service
adb shell cmd package install-existing com.android.htmlviewer
adb shell cmd package install-existing com.android.companiondevicemanager
adb shell cmd package install-existing com.android.NFCtestSvc
adb shell cmd package install-existing com.android.provision
adb shell cmd package install-existing com.android.statementservice
adb shell cmd package install-existing android.autoinstalls.config.Xiaomi.gemini
adb shell cmd package install-existing com.android.managedprovisioning
adb shell cmd package install-existing com.android.bookmarkprovider
adb shell cmd package install-existing org.codeaurora.gps.gpslogsave
adb shell cmd package install-existing com.android.vpndialogs
adb shell cmd package install-existing com.android.emergency
adb shell cmd package install-existing com.android.bluetoothmidiservice
adb shell cmd package install-existing com.android.captiveportallogin
adb shell cmd package install-existing com.xiaomi.simactivate.service
adb shell cmd package install-existing com.xiaomi.location.fused
adb shell cmd package install-existing com.qualcomm.location
adb shell cmd package install-existing com.qualcomm.qti.qtisystemservice
adb shell cmd package install-existing com.qti.dpmserviceapp
adb shell cmd package install-existing com.qualcomm.wfd.service
adb shell cmd package install-existing com.qualcomm.qti.poweroffalarm
adb shell cmd package install-existing com.xiaomi.bluetooth
adb shell cmd package install-existing com.xiaomi.providers.appindex
adb shell cmd package install-existing com.android.apps.tag
adb shell cmd package install-existing com.miui.smsextra
adb shell cmd package install-existing com.miui.wmsvc
adb shell cmd package install-existing com.miui.cit
adb shell cmd package install-existing com.miui.global.packageinstaller
adb shell cmd package install-existing com.mi.webkit.core
adb shell cmd package install-existing com.android.updater

echo ""
echo "=========================================="
echo "RESTORE COMPLETE!"
echo "=========================================="
echo "All packages restored to factory state"
echo "Reboot recommended: adb reboot"
echo ""
echo "Note: Some errors are normal if packages weren't"
echo "originally on your device variant"