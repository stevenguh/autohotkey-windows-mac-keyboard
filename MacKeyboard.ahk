;-----------------------------------------
; Apple Wired Keyboard w/ Numpad (MB110LL) to Windows Key Mappings
;=========================================

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
; Mac -> Windows Translation
; --------------------------------------------------------------

; Swap left Control/Windows key with left Alt
LWin::LControl
LControl::LWin
RWin::RControl
RControl::RWin

; Eject Key
F20::SendInput {Insert}

; F13-15, Standard Windows Mapping
F13::SendInput {PrintScreen}
F14::SendInput {ScrollLock}
F15::SendInput {Pause}

; Launch the Task view (Windows 10 only)
F3::SendInput #{Tab}

; Launch Cortana (Windows 10 only)
^Space::SendInput #s
; --------------------------------------------------------------
; Media/Function Keys
; --------------------------------------------------------------

; Media Keys (For some reasons, Spotify able to detects those keys)
;!F7::SendInput {Media_Prev} ; Must use Alt modifier
;!F8::SendInput {Media_Play_Pause}
;!F9::SendInput {Media_Next}

; Volume control keys
F10::SendInput {Volume_Mute}
F11::SendInput {Volume_Down}
F12::SendInput {Volume_Up}


; Custom App Launchers
;F16::Run http://twitter.com
;F17::Run
;F18::Run
;F19::Run
