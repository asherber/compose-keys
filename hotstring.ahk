; Global state
Modify := false
DirectMode := false

UpdateModifierKey(old_key, new_key) {
    Try Hotkey old_key, "Off"
    Hotkey new_key, ModifierKeyFunction

    if (UseCapsLock || new_key == "CapsLock") {
        ; Special modifier CapsLock
        Hotkey "CapsLock", ModifierKeyFunction
        Hotkey "+CapsLock", (*) => Send("{CapsLock}")
    }
    else {
        Try Hotkey "CapsLock", "Off"
        Try Hotkey "+CapsLock", "Off"
    }
}

ModifierKeyFunction(*) {
    if (Disabled) {
        return
    }

    global Modify := !Modify
    global DirectMode := false

    if (Modify) {
        SetTimer ResetState, -ResetDelay    ; reset after a short period to avoid unwanted compose keys
    } else {
        ; pressing the modifier twice will reset it
        if (SoundOnReset = 1) {
            SoundBeep 200, 130  ; quick blip to tell user that modifier was cancelled
        }
    }    
}

ActivateDirectMode(mode) {
    if Modify {
        global DirectMode := mode
        SetTimer ResetState, -ResetDelay
    }
}

ResetState() {
    global Modify := false
    global DirectMode := false
}



; Trigger inside words; replace immediately; case-sensitive; no auto-backspace; execute function
#Hotstring ? * c b0 x

; Main list of character replacements, usually consisting of 2-character triggers,
; followed by a call to the cp() function with the replacement character
#Include keys.ahk
LoadCustomKeysFile(AssetDir "\customkeys.txt")   

; Allow for use of ascii/unicode codes as triggers, e.g. /u00E9 or /a0233
#Include vendor\Descolada\XHotstring.ahk

; Trigger inside words; replace immediately; case-sensitive; no auto-backspace; clear buffer
XHotstring("? * c b0 z")
XHotstring("::/([au])", (match, *) => ActivateDirectMode(match[1]))
; Only match 4 hex chars at the start of the buffer
XHotstring("::^[0-9A-Fa-f]{4}", (match, *) => cp(match[0], false))



; The main Compose function
cp(char, standard := true) {
    if !Modify {
        return
    }

    if standard && !DirectMode {
        ; length of the trigger, minus the two colon
        length := StrLen(A_ThisHotkey) - InStr(A_ThisHotkey, ":", false, 1, 2)
        Send "{BackSpace " length "}"
        Send char
        ResetState()
    } else if !standard && DirectMode {
        Send "{BackSpace 6}"  ; remove the trigger and the direct mode switch
        prefix := DirectMode = "a" ? "ASC " : "U+"
        Send "{" prefix char "}"
        ResetState()
    }
}

LoadCustomKeysFile(file) {
    if !FileExist(file) {
        return
    }

    loop read file
    {
        if RegExMatch(A_LoopReadLine, '::(?<trigger>.+?)::cp\("(?<arg>.*)"\)', &match) {
            Hotstring("::" . match.trigger, (*) => cp(match.arg))
        }
    }
}
