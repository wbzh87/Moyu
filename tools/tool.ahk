; =========== ****** 脚本信息 ****** ===========
; 脚本名称: 实时监测窗口信息
;   快捷键提示:
;   - 按Ctrl+数字键1：显示鼠标所在窗口的详细信息
;   - 按Ctrl+数字键2：显示当前活动窗口信息
;   - 按Ctrl+数字键3：显示简洁版窗口信息（在工具提示中）
;   - 按Ctrl+数字键0：切换实时坐标监控
; =============================================


#Requires AutoHotkey v2.0
#SingleInstance Force   ;只启动一个


; 全局变量，用于控制实时监控状态
global isMonitoring := false


; 按Ctrl+数字键1：显示鼠标所在窗口的详细信息
^Numpad1:: {
    ; 如果正在监控，先暂停一下
    if (isMonitoring) {
        SetTimer(MonitorMousePosition, 0)  ; 临时停止监控
        originalMonitoring := true
    } else {
        originalMonitoring := false
    }

    ; 获取鼠标当前位置坐标（窗口相对坐标和屏幕绝对坐标）
    MouseGetPos &mouseX, &mouseY, &winID, &controlClassNN, 2
    CoordMode "Mouse", "Screen"  ; 切换到屏幕坐标系
    MouseGetPos &screenX, &screenY  ; 获取屏幕绝对坐标
    CoordMode "Mouse", "Window"   ; 切换回窗口坐标系

    ; 获取窗口信息
    winClass := WinGetClass("ahk_id " winID)
    winTitle := WinGetTitle("ahk_id " winID)
    winProcess := WinGetProcessName("ahk_id " winID)
    winPID := WinGetPID("ahk_id " winID)
    winProcessPath := WinGetProcessPath("ahk_id " winID)

    ; 获取控件信息
    controlText := ""
    try {
        controlText := ControlGetText(controlClassNN, "ahk_id " winID)
        controlText := StrLen(controlText) > 50 ? SubStr(controlText, 1, 50) "..." : controlText
    }

    ; 构建显示信息
    info := "🖱️ 鼠标位置:`n"
    info .= "  - 窗口坐标: X" mouseX ", Y" mouseY " (相对于当前窗口)`n"
    info .= "  - 屏幕坐标: X" screenX ", Y" screenY " (相对于整个屏幕)`n`n"
    info .= "📋 窗口信息:`n"
    info .= "标题: " winTitle "`n"
    info .= "类名: " winClass "`n"
    info .= "ID: " winID "`n"
    info .= "进程: " winProcess "`n"
    info .= "PID: " winPID "`n"
    info .= "路径: " winProcessPath "`n`n"
    info .= "🎯 控件信息:`n"
    info .= "类名: " (controlClassNN ? controlClassNN : "无") "`n"
    info .= "文本: " (controlText ? controlText : "无") "`n`n"
    info .= "💡 提示：确定后信息将自动复制到剪贴板"

    ; 显示信息对话框
    result := MsgBox(info, "窗口信息查看器", "OKCancel")

    ; 复制信息到剪贴板
    if (result = "OK") {
        copyText := "窗口坐标: X" mouseX ", Y" mouseY " (相对于当前窗口)`n"
        copyText .= "屏幕坐标: X" screenX ", Y" screenY " (相对于整个屏幕)`n"
        copyText .= "窗口标题: " winTitle "`n"
        copyText .= "窗口类名: " winClass "`n"
        copyText .= "窗口ID: " winID "`n"
        copyText .= "进程名: " winProcess "`n"
        copyText .= "进程ID: " winPID "`n"
        copyText .= "进程路径: " winProcessPath "`n"
        copyText .= "控件类名: " (controlClassNN ? controlClassNN : "无") "`n"
        copyText .= "控件文本: " (controlText ? controlText : "无")

        A_Clipboard := copyText
        ToolTip("信息已复制到剪贴板！", 500, 500)
        SetTimer(() => ToolTip(), -1000)
    }

    ; 如果原本在监控，恢复监控
    if (originalMonitoring) {
        SetTimer(MonitorMousePosition, 100)
    }
}

; 按Ctrl+数字键2：显示当前活动窗口信息
^Numpad2:: {
    ; 如果正在监控，先暂停一下
    if (isMonitoring) {
        SetTimer(MonitorMousePosition, 0)
        originalMonitoring := true
    } else {
        originalMonitoring := false
    }

    ; 获取活动窗口信息
    activeClass := WinGetClass("A")
    activeTitle := WinGetTitle("A")
    activeProcess := WinGetProcessName("A")
    activePID := WinGetPID("A")
    activeProcessPath := WinGetProcessPath("A")
    activeID := WinGetID("A")

    ; 构建显示信息
    info := "🎯 当前活动窗口信息:`n`n"
    info .= "📋 基本信息:`n"
    info .= "标题: " activeTitle "`n"
    info .= "类名: " activeClass "`n"
    info .= "ID: " activeID "`n"
    info .= "进程: " activeProcess "`n"
    info .= "PID: " activePID "`n"
    info .= "路径: " activeProcessPath "`n`n"
    info .= "💡 提示：确定后信息将自动复制到剪贴板"

    ; 显示信息
    result := MsgBox(info, "活动窗口信息", "OKCancel")

    if (result = "OK") {
        copyText := "活动窗口标题: " activeTitle "`n"
        copyText .= "活动窗口类名: " activeClass "`n"
        copyText .= "活动窗口ID: " activeID "`n"
        copyText .= "活动进程名: " activeProcess "`n"
        copyText .= "活动进程ID: " activePID "`n"
        copyText .= "活动进程路径: " activeProcessPath

        A_Clipboard := copyText
        ToolTip("信息已复制到剪贴板！", 500, 500)
        SetTimer(() => ToolTip(), -1000)
    }

    ; 如果原本在监控，恢复监控
    if (originalMonitoring) {
        SetTimer(MonitorMousePosition, 100)
    }
}

;  按Ctrl+数字键3：显示简洁版窗口信息（在工具提示中）
^Numpad3:: {
    ; 如果正在监控，先暂停一下
    if (isMonitoring) {
        SetTimer(MonitorMousePosition, 0)
        originalMonitoring := true
    } else {
        originalMonitoring := false
    }

    MouseGetPos &mouseX, &mouseY, &winID
    CoordMode "Mouse", "Screen"
    MouseGetPos &screenX, &screenY
    CoordMode "Mouse", "Window"

    winClass := WinGetClass("ahk_id " winID)
    winTitle := WinGetTitle("ahk_id " winID)

    ToolTip("窗口坐标: " mouseX "," mouseY "`n屏幕坐标: " screenX "," screenY "`n类名: " winClass "`n标题: " winTitle, mouseX + 20, mouseY + 20)
    SetTimer(() => ToolTip(), -3000)

    ; 如果原本在监控，恢复监控
    if (originalMonitoring) {
        SetTimer(MonitorMousePosition, 100)
    }
}

^Numpad0:: {  ; 按Ctrl+数字键0：切换实时坐标监控
    global isMonitoring
    isMonitoring := !isMonitoring  ; 切换状态

    if (isMonitoring) {
        ; 显示状态提示（使用一个特定的工具提示函数）
        ShowStatusToolTip("✅ 实时坐标监控已开启", 10, 10)
        SetTimer(MonitorMousePosition, 100)  ; 每100毫秒更新一次
    } else {
        SetTimer(MonitorMousePosition, 0)  ; 停止定时器
        ShowStatusToolTip("❌ 实时坐标监控已关闭", 10, 10)
        ; 关闭监控时也清除实时监控的工具提示
        ToolTip(, , , 2)  ; 清除第二个工具提示（实时监控的）
    }

    ; 2秒后关闭状态提示（不影响实时监控的工具提示）
    SetTimer(HideStatusToolTip, -2000)
}

; 显示状态提示（使用不同的工具提示窗口编号，避免冲突）
ShowStatusToolTip(text, x, y) {
    ToolTip(text, x, y, 1)  ; 使用编号1表示状态提示
}

; 隐藏状态提示（只关闭编号1的工具提示）
HideStatusToolTip() {
    ToolTip(, , , 1)  ; 只关闭编号1的工具提示
}

; 修改MonitorMousePosition函数，使用编号2的工具提示
; 实时监控鼠标位置的函数
MonitorMousePosition() {
    if (!isMonitoring) {
        return
    }

    MouseGetPos &mouseX, &mouseY, &winID
    CoordMode "Mouse", "Screen"
    MouseGetPos &screenX, &screenY
    CoordMode "Mouse", "Window"

    winClass := WinGetClass("ahk_id " winID)
    winTitle := WinGetTitle("ahk_id " winID)
    shortTitle := StrLen(winTitle) > 30 ? SubStr(winTitle, 1, 30) "..." : winTitle

    ; 使用字符串连接
    tooltipText := "🎯 实时坐标监控 [Ctrl+数字键0：关闭]`n"
        . "──────────────────`n"
        . "📍 窗口坐标: X" mouseX ", Y" mouseY "`n"
        . "📍 屏幕坐标: X" screenX ", Y" screenY "`n"
        . "🏷️ 类名: " winClass "`n"
        . "📋 标题: " shortTitle "`n"
        . "──────────────────`n"
        . "💡 提示: 按Ctrl+数字键1：查看详细信息"

    ToolTip(tooltipText, 10, 10, 2)
}