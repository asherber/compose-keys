#Requires AutoHotkey v2.0
#SingleInstance Force

;@Ahk2Exe-SetMainIcon compose.ico
;@Ahk2Exe-Base ../v2/AutoHotKey64.exe
;@Ahk2Exe-ExeName compose-keys
;@Ahk2Exe-SetCopyright ©2026
;@Ahk2Exe-SetDescription Compose Keys
;@Ahk2Exe-SetVersion 2.1.1


; Local assets
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
if !FileExist(AssetDir "\config.ini")
{
    FileInstall("config.ini", AssetDir "\config.ini", 1)
}

; UI
TraySetIcon(AssetDir "\compose.ico")

ReadIni()

A_TrayMenu.ClickCount := 2
A_TrayMenu.Delete()

; Display the current modifier key at the top of the menu
A_TrayMenu.Add(ModifierKey, (*) => {})
A_TrayMenu.Disable(ModifierKey)
CAPSLOCK := "&CapsLock"
A_TrayMenu.Add(CAPSLOCK, (*) => {})
A_TrayMenu.Disable(CAPSLOCK)
SetCapsLockMenuChecked()

A_TrayMenu.Add()
A_TrayMenu.Add("&Disable", ToggleDisabled)
A_TrayMenu.Add("&Restart", (*) => Reload())
A_TrayMenu.Add()
A_TrayMenu.Add("&Settings...", ShowIniEditor)
A_TrayMenu.Add("&Help", (*) => Run(AssetDir "\help.html"))
A_TrayMenu.Add("Compose &Key Table", (*) => Run(AssetDir "\keytable.html"))
A_TrayMenu.Add()
A_TrayMenu.Add("&About", ShowAbout)
A_TrayMenu.Add("E&xit", (*) => ExitApp())

A_TrayMenu.Default := "&Settings..."
A_IconTip := "Compose Keys: right-click for options."
TraySetIcon(AssetDir "\compose.ico")

; Global state
Disabled := false

; Allows user to easily edit the settings
#Include ini-editor.ahk

; This is where the real action is!
; Loads all the compose key combinations and the cp() function.
#Include hotstring.ahk

; Tell the user that compose-keys has loaded, and which modifier is active
TrayTip("Compose Keys is now running...`nPress [ " ModifierKey " ] to start a new key sequence.", "Compose Keys", 1)



ToggleDisabled(*) {
    global Disabled

    if (Disabled == true) {
        Disabled := false
        A_TrayMenu.Uncheck("&Disable")
        TraySetIcon(AssetDir "\compose.ico")
    } else {
        Disabled := true
        A_TrayMenu.Check("&Disable")
        TraySetIcon(AssetDir "\compose2.ico")
    }
}

ShowIniEditor(*) {
    IniSettingsEditor("Compose Keys", AssetDir "\config.ini")
    ReadIni()
    A_TrayMenu.Rename("1&", ModifierKey)
    SetCapsLockMenuChecked()
}

ShowAbout(*) {
    AppName := "Compose Keys"
    if A_IsCompiled
        AppName .= " v" FileGetVersion(A_ScriptFullPath)
    Symon := "Symon Bent`n(henrybadao@gmail.com)"
    Aaron := "Aaron Sherber`n(aaron@sherber.com)"
    MsgBox(Format("{}`n`nby {}`n`n{}", AppName, Symon, Aaron), "Compose Key", 64)
}

ReadIni(*) {
    old_key := IsSet(ModifierKey) ? GetAhkKeyName(ModifierKey) : ""
    
    global SoundOnReset  := IniRead(AssetDir "\config.ini", "Settings", "SoundOnReset")
    global ModifierKey   := IniRead(AssetDir "\config.ini", "Settings", "ModifierKey")
    global UseCapsLock   := IniRead(AssetDir "\config.ini", "Settings", "UseCapsLock")
    global ResetDelay    := IniRead(AssetDir "\config.ini", "Settings", "ResetDelay")

    new_key := GetAhkKeyName(ModifierKey)
    UpdateModifierKey(old_key, new_key)
}

GetAhkKeyName(key_name) {
    ; Convert the 'human' key name to an AHK approved version
    key_map := {
        CapsLock: "CapsLock",
        RWin: "Right Winkey",
        LWin: "Left Winkey",
        RAlt: "Right Alt",
        LAlt: "Left Alt",
        RControl: "Right Ctrl",
        LControl: "Left Ctrl",
        RShift: "Right Shift",
        LShift: "Left Shift",
        Insert: "Insert",
        Numlock: "Num Lock",
        Esc: "Escape",
        Tab: "Tab"
    }

    for key, value in key_map.OwnProps() {
        if (value == key_name) {
            return key
        }
    }
}

SetCapsLockMenuChecked(*) {
    if (UseCapsLock == 1) {
        A_TrayMenu.Check(CAPSLOCK)
    } else {
        A_TrayMenu.Uncheck(CAPSLOCK)
    }
}

