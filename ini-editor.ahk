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

    ; ── Data storage (replacing v1 pseudo-arrays) ───────────────────────────
    nodeVal  := Map()   ; ItemID -> current value
    nodeDef  := Map()   ; ItemID -> default value
    nodeDes  := Map()   ; ItemID -> description text
    nodeTyp  := Map()   ; ItemID -> key type string
    nodeFor  := Map()   ; ItemID -> format/list string
    nodeOpt  := Map()   ; ItemID -> extra AHK options
    nodeChkN := Map()   ; ItemID -> checkbox label
    nodeSec  := Map()   ; ItemID -> true if section, false if key

    ; ── Layout constants (kept in sync between initial layout and GuiResize) ──
    TreeX       := 10
    TreeW       := 180
    TreeY       := 75
    ValueX      := 215
    ValueW      := 340
    LabelH      := 18
    ValueY      := TreeY + LabelH
    RightMargin := 230   ; controls stretch to (Width - RightMargin)
    BtnH        := 23
    BtnW        := 75

    ; ── Create GUI ────────────────────────────────────────────────────────
    myGui := Gui("-Resize", ProgName " Settings")

    If OwnedBy {
        myGui.Opt("+ToolWindow +Owner" OwnedBy.Hwnd)
        If DisableGui
            OwnedBy.Opt("+Disabled")
    } Else
        DisableGui := false

    ; ── Add controls (order matters for ClassNN compatibility) ──────────────
    sb         := myGui.Add("StatusBar")
    tv         := myGui.Add("TreeView",     Format("x{} y{} w{} h221 0x400", TreeX, TreeY, TreeW))
    edt1       := myGui.Add("Edit",         Format("x{} y{} w{} h20", ValueX, ValueY, ValueW))
    edt2       := myGui.Add("Edit",         Format("x{} y{} w{} h115 ReadOnly -VScroll", ValueX, TreeY + 60 + LabelH, ValueW))
    btnExit    := myGui.Add("Button",       Format("x{} y310 w{} h{}", (ValueX + ValueW - BtnW), BtnW, BtnH),  "E&xit")
    btnBrowse  := myGui.Add("Button",       Format("x{} y88 w{} h{}", 505, BtnW, BtnH),    "B&rowse")
    btnDefault := myGui.Add("Button",       Format("x{} y275 w{} h{}", ValueX, 100, BtnH),   "&Restore Default")
    dtPicker   := myGui.Add("DateTime",     Format("x{} y{} w{} h{}", ValueX, ValueY, ValueW, 20))
    hkCtrl     := myGui.Add("Hotkey",       Format("x{} y{} w{} h{}", ValueX, ValueY, ValueW, 20))
    ddl        := myGui.Add("DropDownList", Format("x{} y{} w{} h{}", ValueX, ValueY, ValueW, 120))
    chkBox     := myGui.Add("CheckBox",     Format("x{} y{} w{} h{}", ValueX, ValueY, ValueW, 20))

    SetEditMargins(edt2.Hwnd, 5, 5)

    myGui.SetFont("Bold", "Segoe UI")
    myGui.Add("Text", Format("x{} y{}", ValueX, TreeY),  "Value")
    myGui.Add("Text", Format("x{} y{}", ValueX, TreeY + 60), "Description")

    HelpTip := "(All changes are autosaved)"
    If (HelpText != "") {
        HelpTip := "( All changes are Auto-Saved - Press F1 for Help )"
        HotIf(() => WinActive(ProgName " Settings"))
        Hotkey("F1", ShowHelp)
        HotIf()
    }
    myGui.SetFont("s9 Norm cDefault", "Segoe UI")
    myGui.Add("Text", Format("x{} y35 w{} h20 +Center", 45, 480), HelpTip)
    myGui.SetFont("s14 Bold", "Segoe UI")
    myGui.Add("Text", Format("x{} y8 w{} +Center", 45, 480), "Settings for " . ProgName)
    myGui.SetFont(, "Segoe UI")

    ; ── Read ini file, build tree, store values ──────────────────────────────
    CurrSecID := 0, CurrID := 0, CurrKey := "", CurrSec := "", CurrLength := 0

    Loop Read, IniFile {
        CurrLine       := A_LoopReadLine
        CurrLineLength := StrLen(CurrLine)

        If (Trim(CurrLine) = "")        ; blank line
            Continue

        If (SubStr(CurrLine, 1, 1) = ";") {   ; comment / description line
            LinePrefix := SubStr(CurrLine, 1, CurrLength + 2)
            Des        := SubStr(CurrLine, CurrLength + 3)

            If (CurrID && !nodeSec.Get(CurrID, true) && ";" CurrKey " " = LinePrefix) {
                ; --- key description ---
                If (SubStr(Des, 1, 6) = "Type: ") {
                    Typ := Trim(SubStr(Des, 7))
                    Des := "`n" Des
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

            } Else If (CurrID && nodeSec.Get(CurrID, false) && ";" CurrSec " " = LinePrefix) {
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
    sb.SetText("Ready")
    myGui.Show("w570 h365")
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
                OptSign := SubStr(A_LoopField, 1, 1)
                OptName := SubStr(A_LoopField, 2)
                If (OptSign = "+" || OptSign = "-") {
                    ControlUsed.Opt(A_LoopField)
                    InvertedOptions .= " " ((OptSign = "+") ? "-" : "+") OptName
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
        If (CurrID && !nodeSec.Get(CurrID, false)) {
            NewVal := (Typ = "DropDown") ? ControlUsed.Text : ControlUsed.Value
            If (NewVal != CurrVal || ValChanged) {
                ValChanged := false

                ; Consistency check for Integer type
                If (Typ = "Integer" && NewVal != "" && !IsInteger(NewVal)) {
                    edt1.Value := CurrVal
                    FlashInvalid("Enter a whole number")
                    Continue
                }
                ; Consistency check for Float type
                If (Typ = "Float" && NewVal != "" && NewVal != "."
                        && !IsFloat(NewVal) && !IsInteger(NewVal)) {
                    edt1.Value := CurrVal
                    FlashInvalid("Enter a number")
                    Continue
                }

                nodeVal[CurrID] := NewVal
                CurrVal := NewVal
                PrntID := tv.GetParent(CurrID)
                SelSec := tv.GetText(PrntID)
                SelKey := tv.GetText(CurrID)
                If (SelSec && SelKey) {
                    IniWrite(NewVal, IniFile, SelSec, SelKey)
                    sb.SetText("Saved " SelSec " › " SelKey)
                }
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
        tv.Move(,, TreeW, Height - 158)
        edt2.Move(,, Width - RightMargin, Height - 280)
        edt1.Move(,, Width - RightMargin)
        dtPicker.Move(,, Width - RightMargin)
        hkCtrl.Move(,, Width - RightMargin)
        ddl.Move(,, Width - RightMargin)
        chkBox.Move(,, Width - RightMargin)
        btnExit.Move(Width // 2 - 35, Height - 65)
        btnDefault.Move(, Height - 106)
        btnBrowse.Move(Width - 65)
    }

    FlashInvalid(Msg) {
        ToolTip(Msg, , , 1)
        SetTimer(() => ToolTip(, , , 1), -1200)
    }

    ShowHelp(*) {
        myGui.Opt("+OwnDialogs")
        MsgBox(HelpText, ProgName " Settings Help", 64)
    }

    SetEditMargins(hwnd, left, right) {
        EM_SETMARGINS  := 0xD3
        EC_LEFTMARGIN  := 0x1
        EC_RIGHTMARGIN := 0x2
        ; Gui/GuiControl coordinates are auto-scaled for DPI, but SendMessage
        ; talks to the control directly and bypasses that, so scale by hand.
        DpiScale := A_ScreenDPI / 96
        if (left != "")
            SendMessage(EM_SETMARGINS, EC_LEFTMARGIN, Round(left * DpiScale), , "ahk_id " hwnd)
        if (right != "")
            SendMessage(EM_SETMARGINS, EC_RIGHTMARGIN, Round(right * DpiScale) << 16, , "ahk_id " hwnd)
    }
}