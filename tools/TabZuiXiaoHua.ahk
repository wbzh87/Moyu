#Requires AutoHotkey v2.0

ZuiXiaoHua() {   ;最小化当前活动的窗口并设置成静音
    activeHwnd := WinGetID("A")  ; 获取当前最前面、正在使用的窗口的ID编号（每个窗口的唯一身份证）
    WinMinimize(activeHwnd)  ; 使用窗口的ID来最小化这个窗口（让它缩到任务栏）
    SoundSetMute true       ; 最小化并设置静音
    return
}