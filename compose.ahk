#Requires AutoHotkey v2.0
#SingleInstance Force

;@Ahk2Exe-SetMainIcon compose.ico
;@Ahk2Exe-Base ../v2/AutoHotKey64.exe
;@Ahk2Exe-ExeName compose-keys
;@Ahk2Exe-SetCopyright ©2026
;@Ahk2Exe-SetDescription Compose Keys
;@Ahk2Exe-SetVersion  2.0.1


AssetDir := A_IsCompiled ? A_AppData . "\ComposeKeys" : A_ScriptDir
if A_IsCompiled
{
    DirCreate(AssetDir)
}

FileInstall("style.css", AssetDir "\style.css", 1)
FileInstall("help.html", AssetDir "\help.html", 1)
FileInstall("keytable.html", AssetDir "\keytable.html", 1)
FileInstall("compose.ico", AssetDir "\compose.ico", 1)
FileInstall("compose2.ico", AssetDir "\compose2.ico", 1)
Try FileInstall("config.ini", AssetDir "\config.ini", 0)

TraySetIcon(AssetDir "\compose.ico")

disabled := false

; User settings
SoundOnReset := IniRead(AssetDir "\config.ini", "Settings", "SoundOnReset")
ModifierKey   := IniRead(AssetDir "\config.ini", "Settings", "ModifierKey")
UseCapsLock   := IniRead(AssetDir "\config.ini", "Settings", "UseCapsLock")
ResetDelay    := IniRead(AssetDir "\config.ini", "Settings", "ResetDelay")

; Allows user to easily edit the settings
#Include ini-editor.ahk

; Convert the 'human' key name to an AHK approved version!
key_map := {RAlt: "Right Alt", LAlt: "Left Alt", RControl: "Right Ctrl", RWin: "Right Winkey", LWin: "Left Winkey", Esc: "Escape", Insert: "Insert", Numlock: "Num Lock", Tab: "Tab", None: "None"}

for key, value in key_map.OwnProps() {
    if (value == ModifierKey) {
        key_name := key
        break
    }
}

; Tell the user that compose-keys has loaded, and which modifier is active
TrayTip("Compose Keys is now running...`nPress [ " ModifierKey " ] to start a new key sequence.", "Compose Keys", 1)

A_TrayMenu.ClickCount := 2
A_TrayMenu.Delete()

; Display the current modifier key at the top of the menu
A_TrayMenu.Add(ModifierKey, MenuModifierKey)
A_TrayMenu.Disable(ModifierKey)
A_TrayMenu.Add("&CapsLock", MenuUseCapsLock)
A_TrayMenu.Disable("&CapsLock")
if (UseCapsLock == 1) {
    A_TrayMenu.Check("&CapsLock")
}
A_TrayMenu.Add()
A_TrayMenu.Add("&Disable", DisableKey)
A_TrayMenu.Add("&Restart", MenuRestart)
A_TrayMenu.Add()
A_TrayMenu.Add("&Settings...", MenuSettings)
A_TrayMenu.Add("&Help", MenuHelp)
A_TrayMenu.Add("Compose &Key Table", MenuKeyTable)
A_TrayMenu.Add()
A_TrayMenu.Add("&About", MenuAbout)
A_TrayMenu.Add("E&xit", MenuExit)

A_TrayMenu.Default := "&Settings..."
A_IconTip := "Compose Keys : right-click for options."
TraySetIcon(AssetDir "\compose.ico")

; This is where the real action is!
; Loads all the compose key combinations and the cp() function.
#Include hotstring.ahk

MenuModifierKey(*) {
    ; Void — item is disabled, only shown for info
}

MenuUseCapsLock(*) {
    ; Void — item is disabled, only shown for info
}

DisableKey(*) {
    global disabled

    if (disabled == true) {
        disabled := false
        A_TrayMenu.Uncheck("&Disable")
        TraySetIcon(AssetDir "\compose.ico")
    } else {
        disabled := true
        A_TrayMenu.Check("&Disable")
        TraySetIcon(AssetDir "\compose2.ico")
    }
}

MenuRestart(*) {
    Reload()
}

MenuSettings(*) {
    IniSettingsEditor("Compose", AssetDir "\config.ini")
}

MenuHelp(*) {
    Run(AssetDir "\help.html")
}

MenuAbout(*) {
    AppName := "Compose Keys"
    if A_IsCompiled
        AppName .= " v" FileGetVersion(A_ScriptFullPath)
    Symon := "Symon Bent`n(henrybadao@gmail.com)"
    Aaron := "Aaron Sherber`n(aaron@sherber.com)"
    MsgBox(Format("{}`n`nby {}`n`n{}", AppName, Symon, Aaron), "Compose Key", 64)
}

MenuExit(*) {
    ExitApp()
}

MenuKeyTable(*) {
    Run(AssetDir "\keytable.html")
}