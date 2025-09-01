#Requires AutoHotkey v2.0

Edge() {  ; 切换浏览器显示/隐藏状态
    static lastState := "show"  ; 静态变量记录最后一次操作
    if (lastState = "show") {
        ; 尝试隐藏
        try {
            if WinExist("ahk_exe msedge.exe") {
                WinHide "ahk_exe msedge.exe"
                lastState := "hide"
                ; ToolTip "隐藏成功"
            }
        }
    } else {
        ; 尝试显示
        try {
            ; 即使窗口隐藏，ProcessExist也能找到
            if ProcessExist("msedge.exe") {
                WinShow "ahk_exe msedge.exe"
                WinActivate "ahk_exe msedge.exe"
                lastState := "show"
                ; ToolTip "显示成功"
            }
        }
    }
    return
}