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

SendIfCmdDown(key, elseKey) {
    if GetWinKeyState() {
        Send %key%
    } else {
        Send %elseKey%
    }
}

ExtractAppTitle(FullTitle)
{	
	AppTitle := SubStr(FullTitle, InStr(FullTitle, " ", false, -1) + 1)
	Return AppTitle
}

; --------------------------------------------------------------
; Swap Control and Windows key
; --------------------------------------------------------------

LWin::Send {LCtrl Down}
LWin Up::Send {LCtrl Up}

LCtrl::Send {LWin Down}
LCtrl Up::Send {LWin Up}

RWin::Send {RCtrl Down}
RWin Up::Send {RCtrl Up}

RCtrl::Send {RWin Down}
RCtrl Up::Send {RWin Up}

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
Left:: Send {Ctrl Up}{Home}
Right:: Send {Ctrl Up}{End}
$Up:: Send {Ctrl Up}^{Home}
$Down:: Send {Ctrl Up}^{End}

; cmd+shift+left/right/up/down
*+Left:: Send {Ctrl Up}+{Home}
*+Right:: Send {Ctrl Up}+{End}
$*+Up:: Send {Ctrl Up}^+{Home}
$*+Down:: Send {Ctrl Up}^+{End}

; cmd+backspace
$Backspace:: Send {Ctrl Up}{Shift Down}{Home}{Shift Up}{BackSpace}
; cmd+delete
$Delete:: Send {Ctrl Up}{Shift Down}{End}{Shift Up}{Delete}

#If ; end-if

; --------------------------------------------------------------
; Mac-like shortcuts 
; --------------------------------------------------------------

#If GetWinKeyState() ; if cmd-pressed

; Capture entire screen -- Cmd + Shift + 3
; (requires Windows 10 Snip & Sketch)
*+3::Send {LCtrl Up}#{PrintScreen}
*+3 Up::Send {LCtrl Down}

; Capture portion of the screen -- Cmd + Shift + 4;
; (requires Windows 10 Snip & Sketch)
*+4::Send {LCtrl Up}#+s
*+4 Up::Send {LCtrl Down}

; Launch Spotlight/Cortana -- Cmd + Space
; (Windows 10 only)
Space::Send {LCtrl Up}#s
Space Up::Send {LCtrl Down}

; Paste plain text -- Cmd+Alt+Shift+V
!+v::
    AutoTrim Off
    Clip0 = %ClipBoardAll%
    ClipBoard = %ClipBoard%       ; Convert to text
    Send ^v                       ; For best compatibility: SendPlay
    Sleep 100                     ; Don't change clipboard while it is pasted! (Sleep > 0)
    ClipBoard = %Clip0%           ; Restore original ClipBoard
    VarSetCapacity(Clip0, 0)      ; Free memory
return

#If ; end-if

; Switch windows of the same app -- Alt + `
; https://github.com/JuanmaMenendez/AutoHotkey-script-Open-Show-Apps/blob/master/AutoHotkey-script-Switch-Windows-same-App.ahk
!`::
WinGet, ActiveProcess, ProcessName, A
WinGet, OpenWindowsAmount, Count, ahk_exe %ActiveProcess%

If OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    Return
	
Else
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
Return

; --------------------------------------------------------------
; Media/Function Keys
; --------------------------------------------------------------

; Launch the Task view (Windows 10 only)
F3::SendIfCmdDown("{F3}", "#{Tab}")

; Media Keys
F7::SendIfCmdDown("{F7}", "{Media_Prev}")
F8::SendIfCmdDown("{F8}", "{Media_Play_Pause}")
F9::SendIfCmdDown("{F9}", "{Media_Next}")

; Volume control keys
F10::SendIfCmdDown("{F10}", "{Volume_Mute}")
F11::SendIfCmdDown("{F11}", "{Volume_Down}")
F12::SendIfCmdDown("{F12}", "{Volume_Up}")

; F13-15, Standard Windows Mapping
F13::Send {PrintScreen}
F14::Send {ScrollLock}
F15::Send {Break}
^F15::Send ^{CtrlBreak}

; Custom App Launchers
;F16::Run http://twitter.com
;F17::Run
;F18::Run
;F19::Run

; Eject Key
F20::Send {Insert}

; --------------------------------------------------------------
; Personal keys
; --------------------------------------------------------------

; Change CapsLock to Ctrl; Shift+Caps to CapsLock
+CapsLock::CapsLock
CapsLock::Ctrl

; Add Horizontal Scroll with Shift
+WheelDown::WheelRight
+WheelUp::WheelLeft