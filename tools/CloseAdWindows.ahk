#Requires AutoHotkey v2.0

; 设置一个定时器，每2000毫秒（2秒）自动执行一次CloseAdWindows函数
; SetTimer 是AHK的定时器功能，可以定期重复执行某个函数
SetTimer CloseAdWindows, 5000  ; 每2秒检查一次

; 定义关闭广告窗口的函数
CloseAdWindows() {
    ; 创建一个包含常见广告窗口类名的数组
    ; 这些类名是通过观察各种广告弹窗的窗口类名收集的
    adClasses := [
        "这里添加后续收集到的弹窗类名"  ;这里添加后续收集到的弹窗类名
    ]

    ; 遍历数组中的每一个广告窗口类名
    ; For...in 循环用于遍历数组中的每个元素
    ; className 变量会依次取数组中的每个类名值
    For className in adClasses {
        ; 使用while循环：只要存在这个类名的窗口，就持续关闭
        ; WinExist() 函数检查指定类名的窗口是否存在
        ; 如果存在，返回非零值（真）；不存在返回0（假）
        while WinExist("ahk_class " className) {
            ; 获取这个广告窗口的ID
            ; WinGetID() 函数根据窗口类名获取窗口的唯一ID
            adID := WinGetID("ahk_class " className)

            ; 使用获取到的窗口ID来精确关闭这个特定的广告窗口
            ; WinClose() 函数关闭指定窗口
            ; 使用 "ahk_id " adID 来确保只关闭这个特定的窗口，不会误关其他同类窗口
            WinClose("ahk_id " adID)

            ; 短暂等待100毫秒，避免操作太快导致系统卡顿
            ; 也给窗口关闭操作留出时间
            Sleep 100
        }
    }
}