;#############   Edit ini file settings in a GUI   #############################
;  A function that can be used to edit settings in an ini file within its own
;  GUI. Just plug this function into your script.
;
;  Original: by Rajat, mod by toralf
;  AHK v2 port: updated for AutoHotkey v2
;
; format:
; =======
;   IniSettingsEditor(ProgName, IniFile[, OwnedBy := 0, DisableGui := 0, HelpText := ""])
;
;   ProgName   - A string used in the GUI to describe the program
;   IniFile    - The ini file name (with path if not in script directory)
;   OwnedBy    - Gui object of the calling GUI (or 0); makes settings GUI owned
;   DisableGui - 1=disables calling GUI during editing of settings
;   HelpText   - Optional help text shown when F1 is pressed
;
; example:
;   IniSettingsEditor("Hello World", "Settings.ini")

IniSettingsEditor(ProgName, IniFile, OwnedBy := 0, DisableGui := 0, HelpText := "") {

    ; Data storage (replacing v1 pseudo-arrays)
    nodeVal  := Map()   ; ItemID -> current value
    nodeDef  := Map()   ; ItemID -> default value
    nodeDes  := Map()   ; ItemID -> description text
    nodeTyp  := Map()   ; ItemID -> key type string
    nodeFor  := Map()   ; ItemID -> format/list string
    nodeOpt  := Map()   ; ItemID -> extra AHK options
    nodeChkN := Map()   ; ItemID -> checkbox label
    nodeSec  := Map()   ; ItemID -> true if section, false if key

    ; Create GUI
    myGui := Gui("+Resize", ProgName " Settings")

    If OwnedBy {
        myGui.Opt("+ToolWindow +Owner" OwnedBy.Hwnd)
        If DisableGui
            OwnedBy.Opt("+Disabled")
    } Else
        DisableGui := false

    ; Add controls (order matters for ClassNN compatibility)
    sb         := myGui.Add("StatusBar")
    tv         := myGui.Add("TreeView",     "x16 y75 w180 h242 0x400")
    edt1       := myGui.Add("Edit",         "x215 y114 w340 h20")
    edt2       := myGui.Add("Edit",         "x215 y174 w340 h120 ReadOnly")
    btnExit    := myGui.Add("Button",       "x250 y335 w70 h30",  "E&xit")
    btnBrowse  := myGui.Add("Button",       "x505 y88 Hidden",    "B&rowse")
    btnDefault := myGui.Add("Button",       "x215 y294",          "&Restore")
    dtPicker   := myGui.Add("DateTime",     "x215 y114 w340 h20 Hidden")
    hkCtrl     := myGui.Add("Hotkey",       "x215 y114 w340 h20 Hidden")
    ddl        := myGui.Add("DropDownList", "x215 y114 w340 h120 Hidden")
    chkBox     := myGui.Add("CheckBox",     "x215 y114 w340 h20 Hidden")
    myGui.Add("GroupBox", "x4 y63 w560 h263")

    SetEditMargins(edt2.Hwnd, 5, 5)

    myGui.SetFont("Bold")
    myGui.Add("Text", "x215 y93",  "Value")
    myGui.Add("Text", "x215 y154", "Description")

    HelpTip := "( All changes are Auto-Saved )"
    If (HelpText != "") {
        HelpTip := "( All changes are Auto-Saved - Press F1 for Help )"
        HotIf(() => WinActive(ProgName " Settings"))
        Hotkey("F1", ShowHelp)
        HotIf()
    }
    myGui.SetFont("s9 Norm cDefault")
    myGui.Add("Text", "x45 y48 w480 h20 +Center", HelpTip)
    myGui.SetFont("s16 Bold", "Verdana")
    myGui.Add("Text", "x45 y13 w480 h35 +Center", "Settings for " ProgName)
    myGui.SetFont()

    ; ── Read ini file, build tree, store values ──────────────────────────────
    CurrSecID := 0, CurrID := 0, CurrKey := "", CurrSec := "", CurrLength := 0

    Loop Read, IniFile {
        CurrLine       := A_LoopReadLine
        CurrLineLength := StrLen(CurrLine)

        If (Trim(CurrLine) = "")        ; blank line
            Continue

        If (SubStr(CurrLine, 1, 1) = ";") {   ; comment / description line
            chk2 := SubStr(CurrLine, 1, CurrLength + 2)
            Des  := SubStr(CurrLine, CurrLength + 3)

            If (CurrID && !nodeSec.Get(CurrID, true) && ";" CurrKey " " = chk2) {
                ; --- key description ---
                If (SubStr(Des, 1, 6) = "Type: ") {
                    Typ := Trim(SubStr(Des, 7))
                    Des := ";" "`n" Des
                    If (SubStr(Typ, 1, 9) = "DropDown ") {
                        nodeFor[CurrID] := SubStr(Typ, 10)
                        Typ := "DropDown", Des := ""
                    } Else If (SubStr(Typ, 1, 8) = "DateTime") {
                        Fmt := Trim(SubStr(Typ, 9))
                        nodeFor[CurrID] := (Fmt = "") ? "dddd MMMM d, yyyy HH:mm:ss tt" : Fmt
                        Typ := "DateTime", Des := ""
                    } Else If (Typ = "CheckBox") {
                        Des := ""
                    }
                    nodeTyp[CurrID] := Typ
                } Else If (SubStr(Des, 1, 9) = "Default: ") {
                    nodeDef[CurrID] := SubStr(Des, 10), Des := ""
                } Else If (SubStr(Des, 1, 9) = "Options: ") {
                    nodeOpt[CurrID] := SubStr(Des, 10), Des := ""
                } Else If (InStr(Des, "Hidden:") = 1) {
                    tv.Delete(CurrID), Des := "", CurrID := 0
                } Else If (SubStr(Des, 1, 14) = "CheckboxName: ") {
                    nodeChkN[CurrID] := SubStr(Des, 15), Des := ""
                }
                If CurrID
                    nodeDes[CurrID] := nodeDes.Get(CurrID, "") "`n" Des

            } Else If (CurrID && nodeSec.Get(CurrID, false) && ";" CurrSec " " = chk2) {
                ; --- section description ---
                If (InStr(Des, "Hidden:") = 1) {
                    tv.Delete(CurrID), Des := "", CurrSecID := 0
                }
                If CurrID
                    nodeDes[CurrID] := nodeDes.Get(CurrID, "") "`n" Des
            }

            ; Strip leading newline
            If (CurrID && SubStr(nodeDes.Get(CurrID, ""), 1, 1) = "`n")
                nodeDes[CurrID] := SubStr(nodeDes[CurrID], 2)
            Continue
        }

        If (SubStr(CurrLine, 1, 1) = "[" && SubStr(CurrLine, CurrLineLength, 1) = "]") {
            ; section line
            CurrSec    := Trim(SubStr(CurrLine, 2, CurrLineLength - 2))
            CurrLength := StrLen(CurrSec)
            CurrSecID  := tv.Add(CurrSec)
            CurrID     := CurrSecID
            nodeSec[CurrID] := true
            CurrKey := ""
            Continue
        }

        Pos := InStr(CurrLine, "=")     ; key = value line
        If (Pos && CurrSecID) {
            CurrKey    := Trim(SubStr(CurrLine, 1, Pos - 1))
            CurrVal    := SubStr(CurrLine, Pos + 1)
            CurrLength := StrLen(CurrKey)
            CurrID     := tv.Add(CurrKey, CurrSecID)
            nodeVal[CurrID] := CurrVal
            nodeSec[CurrID] := false
            nodeDef[CurrID] := CurrVal   ; initial value is default unless overridden
        }
    }

    ; Pre-select first key of first section
    tv.Modify(tv.GetChild(tv.GetNext()), "Select")
    myGui.Show("w570 h400")
    GuiHwnd := myGui.Hwnd

    ; ── Runtime state ────────────────────────────────────────────────────────
    LastID          := 0
    SetDefault      := false
    ValChanged      := false
    ControlUsed     := edt1
    InvertedOptions := ""
    CurrVal         := ""
    CurrID          := 0
    SelSec          := ""
    SelKey          := ""
    Typ             := ""
    done            := false

    ; Bind events
    btnExit.OnEvent("Click",    (*) => done := true)
    btnBrowse.OnEvent("Click",  BtnBrowseKeyValue)
    btnDefault.OnEvent("Click", (*) => SetDefault := true)
    myGui.OnEvent("Close",      (*) => done := true)
    myGui.OnEvent("Size",       GuiResize)

    ; ── Main polling loop ────────────────────────────────────────────────────
    Loop {
        If done
            Break

        CurrID := tv.GetSelection()

        If SetDefault {
            nodeVal[CurrID] := nodeDef.Get(CurrID, "")
            LastID     := 0
            SetDefault := false
            ValChanged := true
        }

        ; Update GUI when tree selection changes
        If (CurrID != LastID) {
            ; Undo custom options applied to previous control
            Loop Parse, InvertedOptions, " " {
                If (A_LoopField != "")
                    ControlUsed.Opt(A_LoopField)
            }

            Typ := nodeTyp.Get(CurrID, "")

            ; Browse button
            btnBrowse.Visible := (Typ = "File" || Typ = "Folder")

            ; Choose active value control
            If (Typ = "DateTime")
                ControlUsed := dtPicker
            Else If (Typ = "Hotkey")
                ControlUsed := hkCtrl
            Else If (Typ = "DropDown")
                ControlUsed := ddl
            Else If (Typ = "CheckBox")
                ControlUsed := chkBox
            Else
                ControlUsed := edt1

            ; Show only the relevant value control
            For ctrl in [dtPicker, hkCtrl, ddl, chkBox, edt1]
                ctrl.Visible := (ctrl == ControlUsed)

            If (ControlUsed == chkBox)
                chkBox.Text := nodeChkN.Get(CurrID, "")

            ; Apply custom options to this control, track inverted options for later removal
            CurrOpt := nodeOpt.Get(CurrID, "")
            InvertedOptions := ""
            Loop Parse, CurrOpt, " " {
                If (A_LoopField = "")
                    Continue
                chk  := SubStr(A_LoopField, 1, 1)
                chk2 := SubStr(A_LoopField, 2)
                If (chk = "+" || chk = "-") {
                    ControlUsed.Opt(A_LoopField)
                    InvertedOptions .= " " ((chk = "+") ? "-" : "+") chk2
                } Else {
                    ControlUsed.Opt("+" A_LoopField)
                    InvertedOptions .= " -" A_LoopField
                }
            }

            If nodeSec.Get(CurrID, false) {
                ; Section selected — disable value editing
                CurrVal := ""
                edt1.Value    := ""
                edt1.Enabled    := false
                btnDefault.Enabled := false
            } Else {
                ; Key selected — populate all value controls
                CurrVal := nodeVal.Get(CurrID, "")
                edt1.Value := CurrVal
                Try dtPicker.Value := CurrVal
                Try hkCtrl.Value   := CurrVal
                ddl.Delete()
                Items := StrSplit(nodeFor.Get(CurrID, ""), "|")
                If (Items.Length > 0 && Items[1] != "") {
                    ddl.Add(Items)
                    ddl.Choose(CurrVal)
                }
                Try chkBox.Value := Integer(CurrVal)
                edt1.Enabled    := true
                btnDefault.Enabled := true
            }
            Des     := RTrim(nodeDes.Get(CurrID, ""), "`n")
            DefText := !nodeSec.Get(CurrID, false) ? (Des != "" ? "`n`n" : "") "Default: " nodeDef.Get(CurrID, "") : ""
            edt2.Value := Des . DefText
        }
        LastID := CurrID

        Sleep(100)

        If done || !WinExist("ahk_id " GuiHwnd)
            Break

        ; Save value if it changed
        If (CurrID && nodeSec.Get(CurrID, false) = false) {
            NewVal := (Typ = "DropDown") ? ControlUsed.Text : ControlUsed.Value
            If (NewVal != CurrVal || ValChanged) {
                ValChanged := false

                ; Consistency check for Integer type
                If (Typ = "Integer" && NewVal != "" && !IsInteger(NewVal)) {
                    edt1.Value := CurrVal
                    Continue
                }
                ; Consistency check for Float type
                If (Typ = "Float" && NewVal != "" && NewVal != "."
                        && !IsFloat(NewVal) && !IsInteger(NewVal)) {
                    edt1.Value := CurrVal
                    Continue
                }

                nodeVal[CurrID] := NewVal
                CurrVal := NewVal
                PrntID := tv.GetParent(CurrID)
                SelSec := tv.GetText(PrntID)
                SelKey := tv.GetText(CurrID)
                If (SelSec && SelKey)
                    IniWrite(NewVal, IniFile, SelSec, SelKey)
            }
        }
    }

    ; ── Cleanup ──────────────────────────────────────────────────────────────
    If (DisableGui && OwnedBy) {
        OwnedBy.Opt("-Disabled")
        OwnedBy.Show()
    }
    If WinExist("ahk_id " GuiHwnd)
        myGui.Destroy()
    If (HelpText != "") {
        HotIf(() => WinActive(ProgName " Settings"))
        Hotkey("F1", "Off")
        HotIf()
    }

    Return 1

    ; ── Nested event handlers ────────────────────────────────────────────────

    BtnBrowseKeyValue(*) {
        StartVal := edt1.Value
        myGui.Opt("+OwnDialogs")
        Selected := ""

        If (Typ = "File") {
            StartFolder := ""
            If FileExist(A_ScriptDir "\" StartVal)
                StartFolder := A_ScriptDir
            Else If FileExist(StartVal)
                SplitPath(StartVal,, &StartFolder)
            Selected := FileSelect(, StartFolder,
                "Select file for " SelSec " - " SelKey, "Any file (*.*)")

        } Else If (Typ = "Folder") {
            StartFolder := ""
            If FileExist(A_ScriptDir "\" StartVal)
                StartFolder := A_ScriptDir "\" StartVal
            Else If FileExist(StartVal)
                StartFolder := StartVal
            Selected := DirSelect("*" StartFolder, 3,
                "Select folder for " SelSec " - " SelKey)
            If (SubStr(Selected, -1) = "\")
                Selected := SubStr(Selected, 1, -1)
        }

        If (Selected != "") {
            Selected := StrReplace(Selected, A_ScriptDir "\")
            edt1.Value      := Selected
            nodeVal[CurrID] := Selected
        }
    }

    GuiResize(thisGui, MinMax, Width, Height) {
        If (MinMax = -1)    ; minimized — skip
            Return
        ; Reposition/resize key controls to follow window edges
        tv.Move(,, 180, Height - 158)
        edt2.Move(,, Width - 230, Height - 280)
        edt1.Move(,, Width - 230)
        dtPicker.Move(,, Width - 230)
        hkCtrl.Move(,, Width - 230)
        ddl.Move(,, Width - 230)
        chkBox.Move(,, Width - 230)
        btnExit.Move(Width // 2 - 35, Height - 65)
        btnDefault.Move(, Height - 106)
        btnBrowse.Move(Width - 65)
    }

    ShowHelp(*) {
        myGui.Opt("+OwnDialogs")
        MsgBox(HelpText, ProgName " Settings Help", 64)
    }

    SetEditMargins(hwnd, left, right) {
        EM_SETMARGINS := 0xD3
        EC_LEFTMARGIN := 0x1
        EC_RIGHTMARGIN := 0x2
        if (left != "")
            SendMessage(EM_SETMARGINS, EC_LEFTMARGIN, left, , "ahk_id " hwnd)
        if (right != "")
            SendMessage(EM_SETMARGINS, EC_RIGHTMARGIN, right << 16, , "ahk_id " hwnd)
    }
}
