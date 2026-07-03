; trigger inside words; replace immediately; case-sensitive; no auto-backspace
#Hotstring ? * c b0

UpdateModifierKey(old_key, new_key) {
    Try Hotkey old_key, "Off"
    Hotkey new_key, ModifierKeyHotkey

    if (UseCapsLock || new_key == "CapsLock") {
        ; Special modifier CapsLock
        Hotkey "CapsLock", ModifierKeyHotkey
        Hotkey "+CapsLock", (*) => Send("{CapsLock}")
    }
    else {
        Try Hotkey "CapsLock", "Off"
        Try Hotkey "+CapsLock", "Off"
    }
}


ModifierKeyHotkey(*) {
    cp("modify")
}

; Shared state for the compose function
global modify := false

ResetModifier() {
    global modify
    modify := false
}

; Main list of character replacements, adapt to your needs
; they consist of 2-character triggers, followed by a call to the cp() function with the replacement character
#Include keys.ahk


; The main Compose function
cp(char) {
    global SoundOnReset, ResetDelay, disabled, modify

    if (disabled == true) {
        return
    }

    ; first check for the modifier key
    if (char = "modify") {
        if (modify = false) {
            modify := true
            SetTimer ResetModifier, -ResetDelay    ; reset after a short period to avoid unwanted compose keys
        } else {
            ; pressing the modifier twice will reset it
            modify := false
            if (SoundOnReset = 1) {
                SoundBeep 200, 130  ; quick blip to tell user that modifier was cancelled
            }
        }

    ; handle the replacement if the modifier is active
    } else if (modify = true) {
        modify := false
        Send "{BackSpace 2}"    ; remove the trigger characters
        Send char               ; send replacement
    }
}
