; trigger inside words; replace immediately; case-sensitive; no auto-backspace; execute function
#Hotstring ? * c b0 x

modify := false

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
    global
    if (disabled == true) {
        return
    }

    if (modify = false) {
        SetTimer () => modify := false, -ResetDelay    ; reset after a short period to avoid unwanted compose keys
    } else {
        ; pressing the modifier twice will reset it
        if (SoundOnReset = 1) {
            SoundBeep 200, 130  ; quick blip to tell user that modifier was cancelled
        }
    }
    
    modify := !modify
}


; Main list of character replacements, adapt to your needs
; they consist of 2-character triggers, followed by a call to the cp() function with the replacement character
#Include keys.ahk

; The main Compose function
cp(char) {
    global modify

    if (modify = true) {
        modify := false
        length := StrLen(A_ThisHotkey) - 2    ; length of the trigger, minus the two colons
        Send "{BackSpace " length "}"    ; remove the trigger characters
        Send char               ; send replacement
    }
}
