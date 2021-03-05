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
Left:: Send {Ctrl Up}{Home}{Ctrl Down}
Right:: Send {Ctrl Up}{End}{Ctrl Down}
$Up:: Send {Ctrl Up}^{Home}{Ctrl Down}
$Down:: Send {Ctrl Up}^{End}{Ctrl Down}

; cmd+shift+left/right/up/down
*+Left:: Send {Ctrl Up}+{Home}{Ctrl Down}
*+Right:: Send {trl Up}+{End}{Ctrl Down}
$*+Up:: Send {Ctrl Up}^+{Home}{Ctrl Down}
$*+Down:: Send {Ctrl Up}^+{End}{Ctrl Down}

; cmd+backspace
$Backspace:: Send {Ctrl Up}{Shift Down}{Home}{Shift Up}{BackSpace}{Ctrl Down}

#If ; end-if

; --------------------------------------------------------------
; Mac-like shortcuts 
; --------------------------------------------------------------

#If GetWinKeyState() ; if cmd-pressed

; Capture entire screen with CMD + SHIFT + 3
; (requires Windows 10 Snip & Sketch)
*+3::Send {Ctrl Up}#{PrintScreen}{Ctrl Down}

; Capture portion of the screen with CMD + SHIFT + 4; (requires Windows 10 Snip & Sketch)
*+4::Send {Ctrl Up}#+s{Ctrl Down}

; Launch Spotlight/Cortana (Windows 10 only)
Space::Send {Ctrl Up}#s{Ctrl Down}

#If ; end-if

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