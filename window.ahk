#MaxHotkeysPerInterval 200
Distance := 0
VDistance := 0
NewTabNum := 0
TabNum := 0
TaskBarHeight := 1

return

; Console window Visor
; Launches, reopens or hides the console.

!`::
DetectHiddenWindows On
SysGet, monitor, MonitorPrimary
SysGet, size, Monitor, monitor

If WinExist("ahk_class Console_2_Main")
{
	IfWinActive
	{
		Send !{Esc}
		WinHide
	} 
	Else 
	{
		WinGetPos x, y, width, height
		WinMove, x, -9
		WinShow
		WinActivate
	}
} 
Else 
{
	Run C:\Dropbox\Projects\Consolo\Console2\Console.exe
	WinWait, Console
	SysGet, monitor, MonitorPrimary
	SysGet, size, Monitor, monitor
	WinGetPos x, y, width, height
	; WinMove, ((sizeRight - sizeLeft) / 2 - width / 2), -9
  WinMove 0, -8, sizeRight, height
}
return

; Windows mobility center
#o::
  Run, %windir%\system32\mblctr.exe /open
return

; Tab Switcher

WheelUp::
  Send {WheelUp}
  Distance := round(NewTabNum * 10)
return

WheelDown::
  Send {WheelDown}
  Distance := round(NewTabNum * 10)
return

WheelLeft::
  Distance := Distance - 1
  DistanceUpdated()
return

WheelRight::
  Distance := Distance + 1
  DistanceUpdated()
return

DistanceUpdated()
{
  global Distance
  global NewTabNum
  global TabNum
  SetTimer ResetDistance, -2000
  NewTabNum := round(Distance / 10)

  Loop
  {
    if round(NewTabNum) == round(TabNum)
    {
      break
    }
    else if round(NewTabNum) < round(TabNum)
    {
      Send ^{PgUp}
      TabNum := TabNum - 1
    }
    else if round(NewTabNum) > round(TabNum)
    {
      Send ^{PgDn}
      TabNum := TabNum + 1
    }
  }
}


!WheelUp::
  if (VDistance == 1)
    return

  VDistance := 1
  Send ^t
  SetTimer ResetVertical, -1000
return

!WheelDown::
  if (VDistance == 1)
    return

  VDistance := 1
  Send ^w
  SetTimer ResetVertical, -1000
return

!WheelLeft::
  if (VDistance == 1)
    return

  VDistance := 1
  Send !{Left}
  SetTimer ResetVertical, -1000
return

!WheelRight::
  if (VDistance == 1)
    return

  VDistance := 1
  Send !{Right}
  SetTimer ResetVertical, -1000
return


ResetVertical:
  VDistance := 0
return

ResetDistance:
  Distance := 0
  VDistance := 0
  TabNum := 0
  NewTabNum := 0
return

; Note: You can optionally release Capslock or the middle mouse button after
; pressing down the mouse button rather than holding it down the whole time.
; This script requires v1.0.25+.

;Alt & LButton::
;CoordMode, Mouse  ; Switch to screen/absolute coordinates.
;MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
;WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
;WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
;if EWD_WinState = 0  ; Only if the window isn't maximized 
;    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
;return

;EWD_WatchMouse:
;GetKeyState, EWD_LButtonState, LButton, P
;if EWD_LButtonState = U  ; Button has been released, so drag is complete.
;{
;    SetTimer, EWD_WatchMouse, off
;    return
;}
;GetKeyState, EWD_EscapeState, Escape, P
;if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
;{
;    SetTimer, EWD_WatchMouse, off
;    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
;    return
;}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
;CoordMode, Mouse
;MouseGetPos, EWD_MouseX, EWD_MouseY
;WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
;SetWinDelay, -1   ; Makes the below move faster/smoother.
;WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
;EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
;EWD_MouseStartY := EWD_MouseY
;return


; Aero peek replacement
#Down::
 WinGet MX, MinMax, A
 If MX
   WinRestore A
 Else WinMinimize A
return

#Up::
 WinGet MX, MinMax, A
 If MX
   WinRestore A
 Else WinMaximize A
return


#Left::
  WinGetTitle, currentWindow, A ; get the active window title
  WinGetPos, aeroX, aeroY, aeroWidth, aeroHeight, A ; get active window x,y,W,H
  WinGet, active_id, ID, A ; get active window ID (like 0xc00dc)
  
  maxWidth := A_ScreenWidth / 3 * 2
  medWidth := A_ScreenWidth / 2
  minWidth := A_ScreenWidth / 3

  intendedHeight := (A_ScreenHeight - 1)

  if (aeroX = 0 && aeroY = 0 && aeroHeight = intendedHeight)
  {
    if (aeroWidth <= minWidth)
    {
      WinMove, %currentWindow%,, (A_ScreenWidth - minWidth), 5, minWidth, intendedHeight
    }
    else if (aeroWidth = medWidth)
    {
      WinMove, %currentWindow%,, 0, 0, minWidth, intendedHeight
    }
    else if (aeroWidth = maxWidth)
    {
      WinMove, %currentWindow%,, 0, 0, medWidth, intendedHeight
    }
    else
    {
      WinMove, %currentWindow%,, 0, 0, maxWidth, intendedHeight
    }
  }
  else
  {
    WinMove, %currentWindow%,, 0, 0, maxWidth, intendedHeight
  }
return

#Right::
  WinGetTitle, currentWindow, A ; get the active window title
  WinGetPos, aeroX, aeroY, aeroWidth, aeroHeight, A ; get active window x,y,W,H
  WinGet, active_id, ID, A ; get active window ID (like 0xc00dc)
  
  maxWidth := A_ScreenWidth / 3 * 2
  medWidth := A_ScreenWidth / 2
  minWidth := A_ScreenWidth / 3

  intendedHeight := (A_ScreenHeight - 1)

  if (aeroX + aeroWidth = A_ScreenWidth && aeroY = 0 && aeroHeight = intendedHeight)
  {
    if (aeroWidth <= minWidth) {
      WinMove, %currentWindow%,, 0, 0, minWidth, intendedHeight
    }
    else if (aeroWidth <= medWidth) {
      WinMove, %currentWindow%,, A_ScreenWidth - minWidth, 0, minWidth, intendedHeight
    }
    else if (aeroWidth <= maxWidth) {
      WinMove, %currentWindow%,, A_ScreenWidth - medWidth, 0, medWidth, intendedHeight
    }
    else {
      WinMove, %currentWindow%,, A_ScreenWidth - maxWidth, 0, maxWidth, intendedHeight
    }
  }
  else {
    WinMove, %currentWindow%,, A_ScreenWidth - maxWidth, 0, maxWidth, intendedHeight
  }
return