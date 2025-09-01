; =========== ****** 脚本信息 ****** ===========
; 脚本名称: ID95摸鱼脚本
; 版本: v1.0
; 作者: ID95
; 创建日期: 2025年8月
; 描述: 多功能工具集合
;
; 快捷键提示:
;   - Home: 帮助信息，提示快捷键
;   - End：暂停部分功能（目前是暂停Tab和~波浪键功能）
;
;   - F8: 快速切换静音状态
;   - Tab：最小化当前活动窗口并设置静音
;   - Alt+1：切换Edge的状态（隐藏/显示）
;   - 波浪号(~)：打开选中的网址或路径（如果路径是可执行程序则打开它）
;
; =============================================

#Requires AutoHotkey v2.0
#SingleInstance Force   ;只启动一个
#Include tools\F8QieHuanJingYin.ahk  ; 引用F8静音功能
#Include tools\TabZuiXiaoHua.ahk  ; 引用Tab最小化功能
#Include tools\HideEdge.ahk  ; 引用Alt+1切换Edge的状态（隐藏/显示）
#Include tools\OpenUrlOrPath.ahk   ; ;波浪号(~)：打开选中的网址或路径（如果路径是可执行程序则打开它）

; ===== 请求管理员权限 =====
if not A_IsAdmin
{
    try
    {
        Run '*RunAs "' A_ScriptFullPath '"'
        ExitApp
    }
    catch
    {
        MsgBox "无法以管理员权限运行脚本。"
        ExitApp
    }
}

; ===== 全局变量定义区域 =====
global ScriptPaused := false    ; 暂停函数使用的变量，只控制某些需要暂停的功能热键

; ===== 辅助提示函数区域 =====
QuickTip(message, duration := 2000) {
    ToolTip(message)
    SetTimer(() => ToolTip(), -duration)
}

; ===== 设置脚本图标 =====
try {
    TraySetIcon("src/logo/taiji.ico", , 1)
} catch {
    QuickTip("图标文件未找到，使用默认图标。", 3000)
}

; ===== 创建托盘图标 =====
CreateTrayIcon()
{
    try {
        A_TrayMenu.Delete() ; 清理自带的系统托盘功能
    }
    A_TrayMenu.Add("帮助(Home键)", (*) => HelpScript())  ; 帮助
    A_TrayMenu.Add()
    A_TrayMenu.Add("暂停(End键)", (*) => PauseScript())  ; 暂停脚本
    A_TrayMenu.Add()
    A_TrayMenu.Add("退出", (*) => ExitScript())  ; 退出脚本

    try {   ;加载系统托盘的图标
        TraySetIcon("src/logo/taiji.ico", , 1)
    }
    TrayTip("ID95脚本已启动")     ; 右下角出现气泡提示信息
}

; ===== 暂停函数 =====
PauseScript() {
    global ScriptPaused            ; 这里写暂停状态下的变量
    ScriptPaused := !ScriptPaused     ; 这里写暂停状态下的变量
    if (ScriptPaused) {
        try {
            TraySetIcon("src/logo/taijihong.ico", , 1)  ; 暂停状态图标
        } catch {
            ; 如果暂停图标不存在，可以保持原图标或使用其他处理方式
        }
        ;TrayTip("脚本已暂停")  ;右下角系统气泡提示
    } else {
        try {
            TraySetIcon("src/logo/taiji.ico", , 1)   ; 恢复正常状态图标
        } catch {
            ; 如果图标不存在，使用默认图标
        }
        ;TrayTip("脚本已恢复")  ;右下角系统气泡提示
    }
}

; ===== 退出函数 =====
ExitScript() {
    ExitApp()      ; 退出脚本
}

; ===== 帮助函数 =====
HelpScript() {
    QuickTip("
        (
        F8：切换静音/不静音
        Tab：最小化当前活动窗口并设置静音
        Alt+1：切换Edge的状态（隐藏/显示）
        波浪号(~)：打开选中的网址或路径（如果路径是可执行程序则打开它）
        )", 3000)
    return
}

; ===== 系统 - 快捷键定义区 =====
Home:: {    ; 帮助提示
    HelpScript()
    return
}

End:: {    ; 暂停脚本
    PauseScript()
    return
}

; ===== 功能 - 快捷键定义区 =====
F8:: {    ; 切换静音
    QieHuanJingYin()            ; ← 只有在未暂停时才执行
    return
}

Tab:: {     ; 最小化当前活动窗口并设置静音
    global ScriptPaused
    if (ScriptPaused) {
        QuickTip("Tab最小化功能已暂停", 1000)
        return
    }
    ZuiXiaoHua()
    return
}

!1:: {      ; 切换Edge的状态（隐藏/显示）
    Edge()
    return
}

`:: {   ;波浪号(~)：打开选中的网址或路径（如果路径是可执行程序则打开它）
    global ScriptPaused
    if (ScriptPaused) {
        QuickTip("波浪号功能已暂停", 1000)
        return
    }
    OpenUrlOrPath()
    return
}

; ===== 在脚本启动时执行的代码 =====
CreateTrayIcon()    ;创建托盘图标
