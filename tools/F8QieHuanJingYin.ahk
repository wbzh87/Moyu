#Requires AutoHotkey v2.0

; 静音功能
QieHuanJingYin()
{
    SoundSetMute -1
    ;QuickTip("切换静音状态", 1000)
}

/*====== 以下是任务栏滚轮调节音量的代码 ======*/
; 定义检查鼠标是否悬停在任务栏的函数
IsMouseOverTaskbar() {
    MouseGetPos , , &winID
    winClass := WinGetClass("ahk_id " winID)
    return winClass = "Shell_TrayWnd" || InStr(winClass, "NotifyIconOverflowWindow")
}
; 滚轮处理函数
HandleWheelUp() {
    if (IsMouseOverTaskbar()) {
        Send "{Volume_Up}"
        return  ; 任务栏区域不传递原始事件
    }
    ; 非任务栏区域传递原始滚轮事件
    Send "{WheelUp}"
}

HandleWheelDown() {
    if (IsMouseOverTaskbar()) {
        Send "{Volume_Down}"
        return  ; 任务栏区域不传递原始事件
    }
    ; 非任务栏区域传递原始滚轮事件
    Send "{WheelDown}"
}

; 使用$修饰符：避免热键被Send命令触发，同时允许其他滚轮热键优先
$WheelUp:: HandleWheelUp()
$WheelDown:: HandleWheelDown()