; Create array
Array := Array()

; Read wallpaper list from file
Loop, Read, wallpapers.txt
{
    line := Trim(A_LoopReadLine)
    ; Skip empty lines and comments
    if (line != "" && SubStr(line, 1, 1) != ";")
    {
        Array.Push(line)
    }
}

; Global variables
isRandomMode := 1  ; 1=Random mode, 0=Sequential mode
currentIndex := 1  ; Current index for sequential mode
cacheDir := A_Temp . "\WallpaperCache"  ; Cache directory
streamingExtensions := ".m3u8,.mpd,.m3u,.pls"  ; Common streaming formats
currentStreaming := ""  ; Currently playing streaming URL
streamCache := Object()  ; Cache for streaming wallpapers

; Create system tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Toggle Random Mode, ToggleMode
Menu, Tray, Add, Next Wallpaper, NextWallpaper
Menu, Tray, Add, Clear Cache, ClearCache
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitApp
Menu, Tray, Add, About, About
Menu, Tray, Tip, Wallpaper Switcher`nCurrent Mode: Random
Menu, Tray, Check, Toggle Random Mode  ; Default to random mode

; Create cache directory if it doesn't exist
IfNotExist, %cacheDir%
    FileCreateDir, %cacheDir%

; Hotkey: Win+Z
#z::
    if (isRandomMode) {
        ; Random mode
        randomIndex := Random(Array.MinIndex(), Array.MaxIndex())
        wallpaperPath := Array[randomIndex]
    } else {
        ; Sequential mode
        wallpaperPath := Array[currentIndex]
        currentIndex++
        if (currentIndex > Array.MaxIndex()) {
            currentIndex := Array.MinIndex()
        }
    }
    
    ; Check if it's a streaming URL
    isStreaming := IsStreamingURL(wallpaperPath)
    
    if (isStreaming) {
        ; For streaming URLs, we need to handle them differently
        if (wallpaperPath = currentStreaming) {
            ToolTip, Streaming wallpaper is already active`n(%wallpaperPath%)
            SetTimer, RemoveToolTip, 2000
            return
        }
        
        ; Cache the streaming URL
        cachedFile := CacheStreamingURL(wallpaperPath)
        
        if (cachedFile) {
            command := "lively setwp --file """ . cachedFile . """"
            currentStreaming := wallpaperPath
        } else {
            ; Fallback: try to use the URL directly
            command := "lively setwp --file """ . wallpaperPath . """"
            currentStreaming := ""
        }
    } else {
        ; For local files, use the path directly
        command := "lively setwp --file """ . wallpaperPath . """"
        currentStreaming := ""
    }
    
    ; Execute the command
    Run, cmd.exe /c %command%,, Hide
    
    ; Show tooltip notification
    modeText := isRandomMode ? "Random Mode" : "Sequential Mode"
    typeText := isStreaming ? "Streaming" : "Local File"
    ToolTip, Setting wallpaper:`n%wallpaperPath%`n(%modeText% | %typeText%)
    SetTimer, RemoveToolTip, 2000
return

; Check if URL is a streaming URL
IsStreamingURL(url) {
    global streamingExtensions
    
    ; Check for common streaming patterns
    if (InStr(url, "://") && (InStr(url, ".m3u8") 
        || InStr(url, ".mpd") 
        || InStr(url, "youtube.com")
        || InStr(url, "youtu.be")
        || InStr(url, "twitch.tv"))) {
        return true
    }
    
    ; Check file extension
    Loop, Parse, streamingExtensions, `,
    {
        if (InStr(url, A_LoopField)) {
            return true
        }
    }
    
    return false
}

; Cache streaming URL to a local playlist file
CacheStreamingURL(url) {
    global cacheDir, streamCache
    
    ; Check if already cached
    for cachedUrl, cachedFile in streamCache {
        if (cachedUrl = url) {
            ; Check if cache file still exists
            if (FileExist(cachedFile)) {
                return cachedFile
            } else {
                ; Remove from cache if file doesn't exist
                streamCache.Delete(url)
                break
            }
        }
    }
    
    ; Create cache file
    timestamp := A_Now
    cacheFile := cacheDir . "\stream_" . timestamp . ".m3u8"
    
    ; Create a simple playlist file
    FileContent := "#EXTM3U`n"
    FileContent .= "#EXT-X-VERSION:3`n"
    FileContent .= "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1000000`n"
    FileContent .= url . "`n"
    
    ; Save to cache file
    FileDelete, %cacheFile%
    FileAppend, %FileContent%, %cacheFile%
    
    if (ErrorLevel = 0) {
        ; Add to cache
        streamCache[url] := cacheFile
        return cacheFile
    }
    
    return ""
}

; Next wallpaper (manual trigger)
NextWallpaper:
    Gosub, #z
return

; Toggle between random and sequential mode
ToggleMode:
    isRandomMode := !isRandomMode
    if (isRandomMode) {
        Menu, Tray, Check, Toggle Random Mode
        Menu, Tray, Tip, Wallpaper Switcher`nCurrent Mode: Random
    } else {
        Menu, Tray, UnCheck, Toggle Random Mode
        Menu, Tray, Tip, Wallpaper Switcher`nCurrent Mode: Sequential
    }
    
    ; Update tray menu item text
    Menu, Tray, Rename, Toggle Random Mode, % isRandomMode ? "Toggle Random Mode" : "Toggle Sequential Mode"
    
    ; Show mode change notification
    modeText := isRandomMode ? "Random Mode" : "Sequential Mode"
    ToolTip, Switched to %modeText%
    SetTimer, RemoveToolTip, 1500
return

; Clear cache
ClearCache:
    ; Clear streaming cache
    streamCache := Object()
    
    ; Delete cache directory
    FileRemoveDir, %cacheDir%, 1
    
    ; Recreate cache directory
    FileCreateDir, %cacheDir%
    
    currentStreaming := ""
    
    ToolTip, Cache cleared
    SetTimer, RemoveToolTip, 1500
return

; Remove tooltip
RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

; Random number generator function
Random(x, y)
{
    Random, var, %x%, %y%
    return var
}

; About information
About:
    MsgBox, Wallpaper Switcher v1.2`n`nFeatures:`n• Win+Z: Change wallpaper`n• Toggle between random/sequential modes`n• Supports streaming wallpapers (m3u8, YouTube, Twitch)`n• Streaming cache system`n• System tray control`n`nRequires: Lively Wallpaper`n`nwallpapers.txt format:`n- Local files: C:\Path\to\wallpaper.webm`n- Streaming URLs: https://example.com/stream.m3u8`n- YouTube/Twitch: https://youtu.be/VIDEO_ID`n- Comments start with ; (semicolon)
return

; Exit application
ExitApp:
    ; Clean up cache on exit
    FileRemoveDir, %cacheDir%, 1
    ExitApp
return