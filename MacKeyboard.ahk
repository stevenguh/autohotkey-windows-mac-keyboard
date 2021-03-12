;-----------------------------------------
; This script assumes the driver for the keyboard is the generic one from windows,
; which also means that the Apple keyboard driver in bootcamp is not installed.
; --------------------------------------------------------------
; If you are using Apple Magic Keyboard and need to delete key via fn+backspace
; you will need to the driver from bootcamp and change the the follow registry to 0
; HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\KeyMagic\OSXFnBehavior
; HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KeyMagic\OSXFnBehavior
; See https://blog.yo1.dog/apple-magic-keyboard-drivers-for-windows-10-mouse-trackpad-also/
; --------------------------------------------------------------
; NOTES
; --------------------------------------------------------------
; ! = ALT
; ^ = CTRL
; + = SHIFT
; # = WIN
;
; Debug action snippet: MsgBox You pressed Control-A while Notepad is active.
#NoEnv ; Compatibility with future releases
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
#SingleInstance force ; Skips the dialog box and replaces the old instance automatically when script already running
DetectHiddenWindows, On ; Detect apps even when minimized (ex. Spotify)
SetTitleMatchMode 2 ; Match any part of window title

; --------------------------------------------------------------
; Function
; --------------------------------------------------------------
GetWinKeyState() {
    return GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
}

ExtractAppTitle(FullTitle)
{	
	AppTitle := SubStr(FullTitle, InStr(FullTitle, " ", false, -1) + 1)
	Return AppTitle
}

; --------------------------------------------------------------
; Swap Control and Windows key
; --------------------------------------------------------------
AltTabbed := false

LWin::
Send {Ctrl Down}
KeyWait, LWin
if (AltTabbed) {
    ; Use to release the alt key for
    ; Cmd-Tab remap below
    Send {Alt Up}
    AltTabbed := false
}
Send {Ctrl Up}
return

RWin::
Send {Ctrl Down}
KeyWait, RWin
if (AltTabbed) {
    ; Use to release the alt key for
    ; Cmd-Tab remap below
    Send {Alt Up}
    AltTabbed := false
}
Send {Ctrl Up}
return

; Use F4 to replace Win key
; This is so the the muscle of ctrl key can be preserved
; like Ctrl-Tab between window or Ctrl-C in Terminal
;LCtrl::Send {LWin Down}
;LCtrl Up::Send {LWin Up}
;RCtrl::Send {RWin Down}
;RCtrl Up::Send {RWin Up}

; --------------------------------------------------------------
; Personal keys
; --------------------------------------------------------------
SetCapsLockState AlwaysOff

; Change CapsLock to Ctrl; Shift+Caps to CapsLock
+CapsLock::CapsLock

CapsLock::
Send {Ctrl Down}
KeyWait, CapsLock
Send {Ctrl Up}
return

#If (GetWinKeyState() && GetKeyState("CapsLock", "P"))

; Launch Emoji keyboard -- Caps + Cmd + Space
; (Windows 10 only)
Space::Send {Ctrl Up}#{.}{Ctrl Down}

; Lock screen -- Caps + Cmd + q
q::DllCall("LockWorkStation") 

; Vim-like key scroll
d::Send {Ctrl Up}{PgDn}{Ctrl Down}
u::Send {Ctrl Up}{PgUp}{Ctrl Down}

#If

#If (GetKeyState("CapsLock", "P"))

; Disable built-in Win key shortcut -- Caps+Esc
Esc::Send {Ctrl Up}{Esc}{Ctrl Down}

#If

; Add Horizontal Scroll with Shift
+WheelDown::WheelRight
+WheelUp::WheelLeft

; --------------------------------------------------------------
; Text navigation
; --------------------------------------------------------------

; option+left/right
$!Left::Send ^{Left}
$!Right::Send ^{Right}

; option+shift+left/right
$*!+Left::Send ^+{Left}
$*!+Right::Send ^+{Right}

; option+shift+up/down
$*!+Up::Send +{Up}
$*!+Down::Send ^+{Down}

; option+backspace
$!Backspace:: Send ^{BackSpace}

#If GetWinKeyState() ; if cmd-pressed
; cmd+left/right/up/down
Left:: Send {Ctrl Up}{Home}{Ctrl Down}
Right:: Send {Ctrl Up}{End}{Ctrl Down}
$Up:: Send {Ctrl Up}^{Home}{Ctrl Down}
$Down:: Send {Ctrl Up}^{End}{Ctrl Down}

; cmd+shift+left/right/up/down
*+Left:: Send {Ctrl Up}+{Home}{Ctrl Down}
*+Right:: Send {Ctrl Up}+{End}{Ctrl Down}
$*+Up:: Send {Ctrl Up}^+{Home}{Ctrl Down}
$*+Down:: Send {Ctrl Up}^+{End}{Ctrl Down}

; cmd+backspace
$Backspace:: Send {Ctrl Up}{Shift Down}{Home}{Shift Up}{BackSpace}{Ctrl Down}
; cmd+delete
$Delete:: Send {Ctrl Up}{Shift Down}{End}{Shift Up}{Delete}{Ctrl Down}

#If ; end-if

; --------------------------------------------------------------
; Mac-like shortcuts 
; --------------------------------------------------------------

; Disable built-in Win key shortcut -- Ctrl+Esc
^Esc::Send {Esc}

#If GetWinKeyState() ; if cmd-pressed

; Disable built-in Win key shortcut -- Cmd+Esc
Esc::Send {Ctrl Up}{Esc}{Ctrl Down}

; Lock screen -- Ctrl + Cmd + q
$*^q::DllCall("LockWorkStation") 

; Switch window -- Cmd + Tab
Tab::
if !AltTabbed {
    Send {Ctrl Up}{Alt Down}{Tab}{Ctrl Down}
    AltTabbed := true
} else {
    Send {Tab}
}
return

; Capture entire screen -- Cmd + Shift + 3
; (requires Windows 10 Snip & Sketch)
*+3::Send {Ctrl Up}#{PrintScreen}{Ctrl Down}

; Capture portion of the screen -- Cmd + Shift + 4;
; (requires Windows 10 Snip & Sketch)
*+4::Send {Ctrl Up}#+s{Ctrl Down}

; Launch Spotlight/Cortana -- Cmd + Space
; (Windows 10 only)
Space::Send {Ctrl Up}#s{Ctrl Down}

; Launch Emoji keyboard -- Ctrl + Cmd + Space
; (Windows 10 only)
$*^Space::Send {Ctrl Up}#{.}{Ctrl Down}

; Paste plain text -- Cmd+Alt+Shift+V
$*!+v::
AutoTrim Off
Clip0 = %ClipBoardAll%
ClipBoard = %ClipBoard%       ; Convert to text
Send ^v                       ; For best compatibility: SendPlay
Sleep 100                     ; Don't change clipboard while it is pasted! (Sleep > 0)
ClipBoard = %Clip0%           ; Restore original ClipBoard
VarSetCapacity(Clip0, 0)      ; Free memory
return

; Switch windows of the same app -- Cmd + `
; https://github.com/JuanmaMenendez/AutoHotkey-script-Open-Show-Apps/blob/master/AutoHotkey-script-Switch-Windows-same-App.ahk
`::
WinGet, ActiveProcess, ProcessName, A
WinGet, OpenWindowsAmount, Count, ahk_exe %ActiveProcess%
if OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    Return
else
	{
		WinGetTitle, FullTitle, A
		AppTitle := ExtractAppTitle(FullTitle)

		SetTitleMatchMode, 2		
		WinGet, WindowsWithSameTitleList, List, %AppTitle%
		
		If WindowsWithSameTitleList > 1 ; If several Window of same type (title checking) exist
		{
			WinActivate, % "ahk_id " WindowsWithSameTitleList%WindowsWithSameTitleList%	; Activate next Window	
		}
	}
return

#If ; end-if

; --------------------------------------------------------------
; Media/Function Keys
; --------------------------------------------------------------

#If !GetKeyState("CapsLock", "T") ; if caps is not on
F3::
if GetWinKeyState() {
    ; Show desktop
    Send {Ctrl Up}#d{Ctrl Down}
} else {
    ; Launch the Task view (Windows 10 only)
    Send #{Tab}
}
return

;; Use F4 as the Win key
F4::
Send {LWin Down}
KeyWait, F4
Send {LWin Up}

; Media Keys
F7::Send {Media_Prev}
F8::Send {Media_Play_Pause}
F9::Send {Media_Next}

; Volume control keys
F10::Send {Volume_Mute}
F11::Send {Volume_Down}
F12::Send {Volume_Up}

; F13-15, Standard Windows Mapping
F13::Send {PrintScreen}
F14::Send {ScrollLock}
F15::Send {Break}
^F15::Send ^{CtrlBreak}

; Eject Key
F20::Send {Insert}

#If