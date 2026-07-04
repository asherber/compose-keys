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
    ; The ini file doubles as its own schema: a comment line directly under a
    ; section or key — shaped like ";<Name> <text>" — is parsed as metadata
    ; (Type/Default/Options/Hidden/CheckboxName) rather than shown as-is.
    ; Anything else starting with ";" is just an ordinary comment and is skipped.

    CurrSecID := 0, CurrID := 0, CurrKey := "", CurrSec := ""

    Loop Read, IniFile {
        CurrLine := A_LoopReadLine

        If (Trim(CurrLine) = "")        ; blank line
            Continue

        If (SubStr(CurrLine, 1, 1) = ";") {
            ParseDescriptionLine(CurrLine)
            Continue
        }

        If IsSectionHeader(CurrLine) {
            CurrSec   := Trim(SubStr(CurrLine, 2, StrLen(CurrLine) - 2))
            CurrSecID := tv.Add(CurrSec)
            CurrID    := CurrSecID
            nodeSec[CurrID] := true
            CurrKey := ""
            Continue
        }

        Pos := InStr(CurrLine, "=")     ; key = value line
        If (Pos && CurrSecID) {
            CurrKey := Trim(SubStr(CurrLine, 1, Pos - 1))
            CurrVal := SubStr(CurrLine, Pos + 1)
            CurrID  := tv.Add(CurrKey, CurrSecID)
            nodeVal[CurrID] := CurrVal
            nodeSec[CurrID] := false
            nodeDef[CurrID] := CurrVal   ; initial value is default unless overridden
        }
    }

    IsSectionHeader(Line) {
        Return SubStr(Line, 1, 1) = "[" && SubStr(Line, StrLen(Line), 1) = "]"
    }

    ParseDescriptionLine(CurrLine) {
        ; Only recognize lines that describe the item just added to the tree.
        If !CurrID
            Return
        Name   := nodeSec.Get(CurrID, false) ? CurrSec : CurrKey
        Prefix := ";" Name " "
        If (SubStr(CurrLine, 1, StrLen(Prefix)) != Prefix)
            Return

        Des := SubStr(CurrLine, StrLen(Prefix) + 1)

        If nodeSec.Get(CurrID, false) {
            If (InStr(Des, "Hidden:") = 1) {
                tv.Delete(CurrID)
                Des := ""
                CurrSecID := 0
            }
        } Else {
            Des := ParseKeyDirective(Des)
        }

        nodeDes[CurrID] := nodeDes.Get(CurrID, "") "`n" Des
        If (SubStr(nodeDes[CurrID], 1, 1) = "`n")     ; drop the leading blank line
            nodeDes[CurrID] := SubStr(nodeDes[CurrID], 2)
    }

    ; Recognizes the "Type: / Default: / Options: / Hidden: / CheckboxName: "
    ; directives on a key's description line, records them into the node*
    ; maps, and returns what (if anything) should remain visible as
    ; free-text description.
    ParseKeyDirective(Des) {
        Static TypePrefix := "Type: "
        Static DefPrefix  := "Default: "
        Static OptPrefix  := "Options: "
        Static ChkPrefix  := "CheckboxName: "

        If (SubStr(Des, 1, StrLen(TypePrefix)) = TypePrefix) {
            Typ := Trim(SubStr(Des, StrLen(TypePrefix) + 1))
            Des := "`n" Des   ; shown in the description panel unless overridden below

            If (SubStr(Typ, 1, 9) = "DropDown ") {
                nodeFor[CurrID] := SubStr(Typ, 10)
                Typ := "DropDown"
                Des := ""
            } Else If (SubStr(Typ, 1, 8) = "DateTime") {
                Fmt := Trim(SubStr(Typ, 9))
                nodeFor[CurrID] := (Fmt = "") ? "dddd MMMM d, yyyy HH:mm:ss tt" : Fmt
                Typ := "DateTime"
                Des := ""
            } Else If (Typ = "CheckBox") {
                Des := ""
            }
            nodeTyp[CurrID] := Typ

        } Else If (SubStr(Des, 1, StrLen(DefPrefix)) = DefPrefix) {
            nodeDef[CurrID] := SubStr(Des, StrLen(DefPrefix) + 1)
            Des := ""

        } Else If (SubStr(Des, 1, StrLen(OptPrefix)) = OptPrefix) {
            nodeOpt[CurrID] := SubStr(Des, StrLen(OptPrefix) + 1)
            Des := ""

        } Else If (InStr(Des, "Hidden:") = 1) {
            tv.Delete(CurrID)
            CurrID := 0
            Des := ""

        } Else If (SubStr(Des, 1, StrLen(ChkPrefix)) = ChkPrefix) {
            nodeChkN[CurrID] := SubStr(Des, StrLen(ChkPrefix) + 1)
            Des := ""
        }
        Return Des
    }

    ; Pre-select first key of first section
    tv.Modify(tv.GetChild(tv.GetNext()), "Select")
    sb.SetText("Ready")
    myGui.Show("w570 h365")
    GuiHwnd := myGui.Hwnd

    ; ── Runtime state ────────────────────────────────────────────────────────
    ControlUsed     := edt1
    InvertedOptions := ""
    CurrVal         := ""
    CurrID          := 0
    SelSec          := ""
    SelKey          := ""
    Typ             := ""
    Populating      := false   ; true while code (not the user) is writing to a control

    ; Bind events — the GUI now reacts to notifications instead of being polled
    btnExit.OnEvent("Click",    CloseEditor)
    btnBrowse.OnEvent("Click",  BtnBrowseKeyValue)
    btnDefault.OnEvent("Click", RestoreDefault)
    myGui.OnEvent("Close",      CloseEditor)
    myGui.OnEvent("Size",       GuiResize)
    tv.OnEvent("ItemSelect",    TreeSelectionChanged)

    edt1.OnEvent("Change",      EditValueChanged)      ; debounced (fires per keystroke)
    dtPicker.OnEvent("Change",  (*) => CommitValue(dtPicker.Value))
    hkCtrl.OnEvent("Change",    (*) => CommitValue(hkCtrl.Value))
    ddl.OnEvent("Change",       (*) => CommitValue(ddl.Text))
    chkBox.OnEvent("Click",     (*) => CommitValue(chkBox.Value))

    ; Populate the panel for the item pre-selected above, then block until closed.
    ; No manual Sleep/poll loop is needed: WinWaitClose blocks efficiently on the
    ; OS message queue and returns the instant the window is destroyed or hidden,
    ; whether that happens via the Exit button, Alt+F4, or the title-bar X.
    RefreshDisplay(tv.GetSelection())
    WinWaitClose("ahk_id " GuiHwnd)

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

    TreeSelectionChanged(*) {
        ; Fires only on a genuine selection change (mouse or keyboard), so no
        ; "did the ID change?" bookkeeping is needed here anymore.
        Id := tv.GetSelection()
        If Id
            RefreshDisplay(Id)
    }

    RefreshDisplay(id) {
        ; Repaint the value/description panel for the given tree item.
        ; Wrapped in Populating so that programmatically setting control
        ; values below doesn't loop back around and trigger CommitValue.
        Populating := true

        ; Undo custom options applied to the previously active control
        Loop Parse, InvertedOptions, " " {
            If (A_LoopField != "")
                ControlUsed.Opt(A_LoopField)
        }

        CurrID := id
        Typ    := nodeTyp.Get(CurrID, "")

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

        Populating := false
    }

    EditValueChanged(*) {
        ; Debounce free-text typing: each keystroke restarts a one-shot timer
        ; instead of writing the ini file on every character.
        If Populating
            Return
        SetTimer(CommitEditValue, -400)
    }

    CommitEditValue() {
        CommitValue(edt1.Value)
    }

    CommitValue(NewVal) {
        ; Shared save path for every value control's Change/Click event.
        If (Populating || !CurrID || nodeSec.Get(CurrID, false))
            Return
        If (NewVal = CurrVal)
            Return

        ; Consistency check for Integer type
        If (Typ = "Integer" && NewVal != "" && !IsInteger(NewVal)) {
            Populating := true
            edt1.Value := CurrVal
            Populating := false
            FlashInvalid("Enter a whole number")
            Return
        }
        ; Consistency check for Float type
        If (Typ = "Float" && NewVal != "" && NewVal != "."
                && !IsFloat(NewVal) && !IsInteger(NewVal)) {
            Populating := true
            edt1.Value := CurrVal
            Populating := false
            FlashInvalid("Enter a number")
            Return
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

    RestoreDefault(*) {
        If (!CurrID || nodeSec.Get(CurrID, false))
            Return
        DefVal := nodeDef.Get(CurrID, "")
        nodeVal[CurrID] := DefVal
        RefreshDisplay(CurrID)   ; repaints controls with the default value

        PrntID := tv.GetParent(CurrID)
        SelSec := tv.GetText(PrntID)
        SelKey := tv.GetText(CurrID)
        If (SelSec && SelKey) {
            IniWrite(DefVal, IniFile, SelSec, SelKey)
            sb.SetText("Restored default for " SelSec " › " SelKey)
        }
    }

    CloseEditor(*) {
        ; Shared by the Exit button and the window's Close event. Explicitly
        ; destroying here (rather than just flipping a flag) is what lets
        ; WinWaitClose unblock — a bare Close event only hides the window.
        If WinExist("ahk_id " GuiHwnd)
            myGui.Destroy()
    }

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