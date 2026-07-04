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
    if (disabled) {
        return
    }

    if (!modify) {
        SetTimer () => modify := false, -ResetDelay    ; reset after a short period to avoid unwanted compose keys
    } else {
        ; pressing the modifier twice will reset it
        if (SoundOnReset = 1) {
            SoundBeep 200, 130  ; quick blip to tell user that modifier was cancelled
        }
    }
    
    global modify := !modify
}


; Main list of character replacements, adapt to your needs
; they consist of 2-character triggers, followed by a call to the cp() function with the replacement character
#Include keys.ahk
LoadCustomFile(AssetDir "\customkeys.txt")   

; The main Compose function
cp(char) {
    if (modify) {
        global modify := false
        length := StrLen(A_ThisHotkey) - InStr(A_ThisHotkey, ":", false, 1, 2)   ; length of the trigger, minus the two colon    
        Send "{BackSpace " length "}"
        Send char
    }
}

LoadCustomFile(file) {
    if !FileExist(file) {
        return
    }

    Loop read, file
    {
        if RegExMatch(A_LoopReadLine, '::(?<trigger>.+?)::cp\("(?<arg>.*)"\)', &match) {
            Hotstring("::" . match.trigger, (*) => cp(match.arg))
        }
    }
}
