$startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$lnkPath = @(
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\CenterTaskbar.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Ditto.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\DeskPins.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\EarTrumpet.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Espanso.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Everything.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\GoldenDict.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Keypirinha.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Lintalist.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Magpie.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\RBTray.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\RectangleWin.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Reduce Memory.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Sizer.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\T-Clock.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Tailscale.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Umi-OCR.lnk",
 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Zeal.lnk"
)

$optPath = @(
    "$env:ProgramFiles\Clash Verge\clash-verge.exe",
    "$env:USERPROFILE\Scoop\shims\resizer2.exe",
    "$env:USERPROFILE\Usr\Git\Shell\_windows\Other\startup_autohotkey.bat"
)

Remove-Item "$startupDir\*.lnk" -Force

foreach ($app in $lnkPath) {
    Copy-Item -Path $app -Destination $startupDir -Force
}

foreach ($exe in $optPath) {
    $exeName = [System.IO.Path]::GetFileNameWithoutExtension($exe)
    $shortcutPath = Join-Path -Path $startupDir -ChildPath "$exeName.lnk"
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $exe
    $shortcut.Save()
}

Read-Host -Prompt "Press Enter to exit"