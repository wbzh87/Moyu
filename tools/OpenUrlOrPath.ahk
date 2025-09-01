#Requires AutoHotkey v2.0
/* 波浪号(~)热键：打开选中的网址或路径 */

OpenUrlOrPath()
{
    ; 保存当前剪贴板内容
    originalClipboard := ClipboardAll()

    try {
        ; 复制选中的文本
        A_Clipboard := "" ; 清空剪贴板
        Send("^c") ; 发送复制命令
        if !ClipWait(0.5) ; 等待剪贴板内容更新
        {
            ; 剪贴板未更新，恢复原始内容并返回
            A_Clipboard := originalClipboard
            return
        }

        selectedText := Trim(A_Clipboard)

        ; 恢复原始剪贴板内容
        A_Clipboard := originalClipboard

        ; 检查并处理选中的文本
        if (selectedText != "") {
            ; 判断是否为网址
            if IsUrl(selectedText) {
                Run(selectedText)
                return
            }

            ; 判断是否为文件路径
            if IsFilePath(selectedText) {
                ; 检查路径是否存在
                if (DirExist(selectedText) || FileExist(selectedText)) {
                    Run(selectedText)
                    return
                }

                ; 如果路径不存在，尝试去除引号后再检查
                cleanPath := StrReplace(selectedText, '"', '')
                if (DirExist(cleanPath) || FileExist(cleanPath)) {
                    Run(cleanPath)
                    return
                }
            }

            ; 如果既不是网址也不是有效路径，尝试作为网址处理
            if (!IsUrl(selectedText) && !InStr(selectedText, " ") && InStr(selectedText, ".")) {
                ; 先尝试添加https://前缀
                tryRunUrl := "https://" selectedText
                try {
                    Run(tryRunUrl)
                    return
                }

                ; 如果https失败，尝试使用http://
                try {
                    tryRunUrl := "http://" selectedText
                    Run(tryRunUrl)
                    return
                }
            }

            ; 如果以上都不适用，显示提示信息
            ToolTip("无法识别为有效网址或路径: " selectedText)
            SetTimer(() => ToolTip(), -2000) ; 2秒后关闭提示
        }
    } catch as e {
        ; 出错时恢复剪贴板并显示错误信息
        A_Clipboard := originalClipboard
        ToolTip("错误: " e.Message)
        SetTimer(() => ToolTip(), -2000)
    }
}

; 判断字符串是否为网址
IsUrl(str) {
    ; 简单的网址模式匹配
    return RegExMatch(str, "i)^(https?|ftp|file)://") ||
        RegExMatch(str, "i)^www\.") ||
        RegExMatch(str, "i)^\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b$") ; 电子邮件地址
}

; 判断字符串是否为文件路径
IsFilePath(str) {
    ; 检查常见的路径模式
    if (RegExMatch(str, "^[A-Za-z]:\\")) ; 绝对路径 (C:\...)
        return true
    if (RegExMatch(str, "^\\\\")) ; 网络路径 (\\server\share)
        return true
    if (RegExMatch(str, "^[~/\.]")) ; Unix风格路径 (~/, ./, ../)
        return true
    if (DirExist(str) || FileExist(str)) ; 直接存在的路径
        return true

    return false
}