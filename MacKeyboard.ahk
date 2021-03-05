;-----------------------------------------
; Apple Wired Keyboard w/ Numpad (MB110LL) to Windows Key Mappings
;=========================================
; This script assumes the driver for the keybaord is the generic one from windows,
; which also means that the Apple keyboard driver in bootcamp is not installed.
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
; Mac -> Windows Translation
; --------------------------------------------------------------

; Swap left Control/Windows key with left Alt
LWin::LControl
LControl::LWin
RWin::RControl
RControl::RWin




; Launch Cortana (Windows 10 only)
^Space::SendInput #s

; --------------------------------------------------------------
; Mac-like screenshots in Windows (requires Windows 10 Snip & Sketch)
; --------------------------------------------------------------

; Capture entire screen with CMD/WIN + SHIFT + 3
^+3::SendInput #{PrintScreen}

; Capture portion of the screen with CMD/WIN + SHIFT + 4
^+4::SendInput #+s

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
