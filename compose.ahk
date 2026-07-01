#Requires AutoHotkey v2.0
#SingleInstance Force

TraySetIcon("compose.ico")

disabled := false

; User settings
SoundOnReset := IniRead(A_ScriptDir "\config.ini", "Settings", "SoundOnReset")
ModifierKey   := IniRead(A_ScriptDir "\config.ini", "Settings", "ModifierKey")
UseCapslock   := IniRead(A_ScriptDir "\config.ini", "Settings", "UseCapslock")
ResetDelay    := IniRead(A_ScriptDir "\config.ini", "Settings", "ResetDelay")

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
A_TrayMenu.Add("&Capslock", MenuUseCapslock)
A_TrayMenu.Disable("&Capslock")
if (UseCapslock == 1) {
    A_TrayMenu.Check("&Capslock")
}
A_TrayMenu.Add()
A_TrayMenu.Add("&Disable", DisableKey)
A_TrayMenu.Add("&Restart", MenuRestart)
A_TrayMenu.Add()
A_TrayMenu.Add("&Settings...", MenuSettings)
A_TrayMenu.Add("&Help", MenuHelp)
A_TrayMenu.Add("&Key Table", MenuKeyTable)
A_TrayMenu.Add("&About", MenuAbout)
A_TrayMenu.Add("E&xit", MenuExit)

A_TrayMenu.Default := "&Settings..."
A_IconTip := "Compose Keys : right-click for options."
TraySetIcon("compose.ico")

; This is where the real action is!
; Loads all the compose key combinations and the cp() function.
#Include hotstring.ahk

MenuModifierKey(*) {
    ; Void — item is disabled, only shown for info
}

MenuUseCapslock(*) {
    ; Void — item is disabled, only shown for info
}

DisableKey(*) {
    global disabled

    if (disabled == true) {
        disabled := false
        A_TrayMenu.Uncheck("&Disable")
        TraySetIcon("compose.ico")
    } else {
        disabled := true
        A_TrayMenu.Check("&Disable")
        TraySetIcon("compose2.ico")
    }
}

MenuRestart(*) {
    Reload()
}

MenuSettings(*) {
    IniSettingsEditor("Compose", "config.ini")
}

MenuHelp(*) {
    Run("notepad.exe " A_ScriptDir "\help.txt")
}

MenuAbout(*) {
    MsgBox("Compose Keys`n`nby Symon Bent`n(henrybadao@gmail.com)", "Compose Key", 64)
}

MenuExit(*) {
    ExitApp()
}

MenuKeyTable(*) {
    Run(A_ScriptDir . "\compose-key-table.md")
}