$startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$lnkPath = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Ollama.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\CenterTaskbar.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\DeskPins.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Ditto.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\dnGREP.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\EarTrumpet.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Espanso.lnk"
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\GoldenDict.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Keypirinha.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\RBTray.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\RectangleWin.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Reduce Memory.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Sizer.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\T-Clock.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Tailscale.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Zeal.lnk"
    # Set startup in Opt
    # "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Everything.lnk"
    # "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Magpie.lnk"
)

$optPath = @(
    @{ Path = "$env:USER\Scoop\shims\resizer2.exe"; Arguments = ""; WorkingDir = "" },
    @{ Path = "$env:USER\Usr\Git\Shell\_windows\Startup\mprocs_autohotkey.bat"; Arguments = ""; WorkingDir = "" }
    # Set startup in Opt
    # @{ Path = "$env:ProgramFiles\Clash Verge\clash-verge.exe"; Arguments = ""; WorkingDir = "" }
)

Remove-Item "$startupDir\*.lnk" -Force

foreach ($app in $lnkPath) {
    Copy-Item -Path $app -Destination $startupDir -Force
}

foreach ($exe in $optPath) {
    $exePath = $exe.Path
    $exeArgs = $exe.Arguments
    $exeName = [System.IO.Path]::GetFileNameWithoutExtension($exePath)
    $shortcutPath = Join-Path -Path $startupDir -ChildPath "$exeName.lnk"
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $exePath

    if ($exeArgs -ne "") {
        $shortcut.Arguments = $exeArgs
    }

    if ($exe.WorkingDir -ne "") {
        $shortcut.WorkingDirectory = $exe.WorkingDir
    }

    $shortcut.Save()
}

Read-Host -Prompt "Press Enter to exit"