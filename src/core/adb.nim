import std/[osproc, strutils]

proc runAdbCommand*(args: seq[string]): tuple[success: bool, output: string] =
  try:
    let cmd = "adb " & args.join(" ")
    let (output, exitCode) = execCmdEx(cmd)
    result = (exitCode == 0, output)
  except:
    result = (false, "")

proc checkAdbConnection*(): bool =
  let (success, output) = runAdbCommand(@["devices"])
  if not success:
    return false
  let lines = output.strip().splitLines()
  return lines.len > 1 and "device" in lines[1]

proc isPackageInstalled*(packageName: string): bool =
  let (success, output) = runAdbCommand(@["shell", "pm", "list", "packages", packageName])
  return success and packageName in output

proc uninstallPackage*(packageName: string): bool =
  let (success, _) = runAdbCommand(@["shell", "pm", "uninstall", "-k", "--user", "0", packageName])
  return success

proc reinstallPackage*(packageName: string): bool =
  let (success, _) = runAdbCommand(@["shell", "cmd", "package", "install-existing", packageName])
  return success