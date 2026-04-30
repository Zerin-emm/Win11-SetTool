#Requires AutoHotkey v2.0
#SingleInstance Off
#NoTrayIcon
;@Ahk2Exe-SetName        Win11 SetTool
;@Ahk2Exe-SetVersion     1.0.0
;@Ahk2Exe-SetCompanyName Zerin
;@Ahk2Exe-SetCopyright   Copyright © 2026 Zerin
;@Ahk2Exe-SetDescription Windows 11 设置工具
;@Ahk2Exe-SetLanguage    0x0804
DllCall("SetProcessDPIAware")

if (!A_IsAdmin) {
    Run Format('*RunAs "{1}"', A_ScriptFullPath)
    ExitApp
}

global g_Initializing := true

MainGui := Gui(, "Win11 SetTool")
MainGui.BackColor := "0xF8FBFD"
MainGui.SetFont("s12", "Microsoft YaHei")

FileMenu := Menu()
FileMenu.Add("退出(&E)", (*) => ExitApp())
helpMenu := Menu()
helpMenu.Add("帮助(&H)", (*) => Run("https://zcn2uzvdaiwh.feishu.cn/wiki/RJRqwq5BpiSmWkksq3McyE7Qn6d"))
helpMenu.Add("关于(&A)", (*) => About())
menus := MenuBar()
menus.Add("文件(&F)", FileMenu)
menus.Add("帮助(&H)", helpMenu)
MainGui.MenuBar := menus

About(*) {
    global MainGui
    
    MainGui.Opt("-Disabled")
    MainGui.Opt("+Disabled") 
    AboutGui := Gui("+Owner" . MainGui.Hwnd . " -MaximizeBox -MinimizeBox", "关于")
    AboutGui.BackColor := "0xF8FBFD"
    AboutGui.SetFont("s12", "Microsoft YaHei")
    AboutGui.Add("Text", "x10 y10", "Win11 SetTool v1.0.0")
    AboutGui.Add("Text", "x10 y35", "作者: Zerin")
    AboutGui.Add("Text", "x10 y60 cBlue", "GitHub").OnEvent("Click", (*) => Run("https://github.com/Zerin-emm/Win11-SetTool"))
    AboutGui.Add("Button", "x240 y66 h25 Default", "确定").OnEvent("Click", (*) => (AboutGui.Destroy(), MainGui.Opt("-Disabled"), WinActivate("ahk_id " . MainGui.Hwnd)))
    AboutGui.OnEvent("Close", (*) => (AboutGui.Destroy(), MainGui.Opt("-Disabled"), WinActivate("ahk_id " . MainGui.Hwnd)))
    AboutGui.Show("w300 h100")
}

SetRegValue(key, valueName, value, type := "REG_DWORD") {
    try {
        RegWrite value, type, key, valueName
        return true
    } catch as e {
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "注册表写入失败`n`n错误信息: " . e.Message, "Str", "错误", "UInt", 0x10)
        return false
    }
}

GetRegValue(key, valueName, default := "") {
    try {
        return RegRead(key, valueName)
    } catch {
        return default
    }
}

RegKeyExists(key) {
    try {
        RegRead key
        return true
    } catch {
        return false
    }
}

WrapHandler(callback) {
    return (c, *) => (g_Initializing ? "" : callback(c))
}

MainGui.Add("GroupBox", "x10 y10 w300 h440", "资源管理器设置")
global ctl_1001 := MainGui.Add("Checkbox", "x20 y35", "显示项目复选框")
global ctl_1002 := MainGui.Add("Checkbox", "x20 y65", "显示文件拓展名")
global ctl_1003 := MainGui.Add("Checkbox", "x20 y95", "显示隐藏的项目")
global ctl_1004 := MainGui.Add("Checkbox", "x20 y125", "显示常用文件夹")
global ctl_1005 := MainGui.Add("Checkbox", "x20 y155", "去除快捷方式小箭头")
global ctl_1006 := MainGui.Add("Checkbox", "x20 y185", "去除管理员盾牌标识")
global ctl_1007 := MainGui.Add("Checkbox", "x20 y215", "在标题栏中显示完整路径")
global ctl_1008 := MainGui.Add("Checkbox", "x20 y245", "创建快捷方式时不加`"快捷方式`"后缀")
MainGui.Add("Text", "x19 y275", "资源管理器风格:")
global ctl_1009 := MainGui.Add("DDL", "x145 w100 y275", ["Win10", "Win11"])
MainGui.Add("Text", "x19 y305", "打开资源管理器时打开:")
global ctl_1010 := MainGui.Add("DDL", "x190 w100 y305", ["此电脑", "主文件夹"])
MainGui.Add("Text", "x19 y335", "右键菜单风格:")
global ctl_1011_1 := MainGui.Add("Radio", "x19 y365", "Win10 经典风格")
global ctl_1011_2 := MainGui.Add("Radio", "x19 y395", "Win11 现代风格")
global ctl_1012 := MainGui.Add("Checkbox", "x20 y425", "关闭打开文件安全警告")

MainGui.Add("GroupBox", "x320 y10 w140 h440", "快捷方式")
MainGui.Add("Button", "x340 y45 w100 h50", "重启`n资源管理器").OnEvent("Click", AHK_1013)
MainGui.Add("Text", "x340 y120 w100 h1 BackgroundDCDCDC")
MainGui.Add("Button", "x340 y145 w100 h50", "刷新`n图标缓存").OnEvent("Click", AHK_1014)
MainGui.Add("Button", "x340 y225 w100 h50", "清空回收站").OnEvent("Click", AHK_1015)
MainGui.Add("Button", "x340 y305 w100 h50", "性能选项").OnEvent("Click", AHK_1016)
MainGui.Add("Button", "x340 y385 w100 h50", "桌面`n图标设置").OnEvent("Click", AHK_1017)

MainGui.Add("GroupBox", "x470 y10 w340 h180", "任务栏设置")
MainGui.Add("Text", "x480 y35", "搜索按钮:")
global ctl_1018 := MainGui.Add("DDL", "x560 w120 y35", ["隐藏", "仅搜索图标", "搜索框", "搜索框和标签"])
global ctl_1019 := MainGui.Add("Checkbox", "x480 y65", "自动隐藏任务栏")
global ctl_1020 := MainGui.Add("Checkbox", "x640 y65", "显示任务视图")
global ctl_1021 := MainGui.Add("Checkbox", "x480 y95", "托盘时间显示秒")
global ctl_1022 := MainGui.Add("Checkbox", "x640 y95", "右键结束任务")
MainGui.Add("Text", "x479 y125", "任务栏对齐:")
global ctl_1023 := MainGui.Add("DDL", "x574 w55 y125", ["靠左", "居中"])
global ctl_1024 := MainGui.Add("Checkbox", "x640 y125", "关闭小组件")
MainGui.Add("Text", "x480 y155", "任务栏按钮合并:")
global ctl_1025 := MainGui.Add("DDL", "x605 w120 y155", ["始终", "任务栏已满时", "从不"])

MainGui.Add("GroupBox", "x470 y200 w340 h250", "Windows设置")
MainGui.Add("Button", "x480 y225 w90 h30", "控制面板").OnEvent("Click", AHK_1026)
MainGui.Add("Button", "x585 y225 w90 h30", "磁盘管理").OnEvent("Click", AHK_1027)
MainGui.Add("Button", "x690 y225 w90 h30", "设备管理器").OnEvent("Click", AHK_1028)
MainGui.Add("Text", "x480 y265 w300 h1 BackgroundDCDCDC")
global ctl_1029 := MainGui.Add("Checkbox", "x480 y275", "关闭搜索要点")
global ctl_1030 := MainGui.Add("Checkbox", "x640 y275", "关闭推荐的项目")
global ctl_1031 := MainGui.Add("Checkbox", "x480 y305", "关闭广告追踪")
global ctl_1032 := MainGui.Add("Checkbox", "x640 y305", "禁用UAC提示")
global ctl_1033 := MainGui.Add("Checkbox", "x480 y335", "关闭搜索历史记录")
global ctl_1034 := MainGui.Add("Checkbox", "x640 y335", "禁用粘滞键")
MainGui.Add("Text", "x480 y365", "电源计划:")
global ctl_1035 := MainGui.Add("DDL", "x555 w70 y365", ["平衡", "高性能"])
global ctl_1036 := MainGui.Add("Checkbox", "x640 y365", "禁用PCA")
global ctl_1037 := MainGui.Add("Checkbox", "x480 y395", "Windows 更新延长至2035/01/01")
MainGui.Add("Text", "x480 y425", "<更改即时生效, 未生效刷新资源管理器>")

SyncSettings()
ctl_1001.OnEvent("Click", WrapHandler(AHK_1001))
ctl_1002.OnEvent("Click", WrapHandler(AHK_1002))
ctl_1003.OnEvent("Click", WrapHandler(AHK_1003))
ctl_1004.OnEvent("Click", WrapHandler(AHK_1004))
ctl_1005.OnEvent("Click", WrapHandler(AHK_1005))
ctl_1006.OnEvent("Click", WrapHandler(AHK_1006))
ctl_1007.OnEvent("Click", WrapHandler(AHK_1007))
ctl_1008.OnEvent("Click", WrapHandler(AHK_1008))
ctl_1009.OnEvent("Change", WrapHandler(AHK_1009))
ctl_1010.OnEvent("Change", WrapHandler(AHK_1010))
ctl_1011_1.OnEvent("Click", WrapHandler(AHK_1011_1))
ctl_1011_2.OnEvent("Click", WrapHandler(AHK_1011_2))
ctl_1012.OnEvent("Click", WrapHandler(AHK_1012))
ctl_1018.OnEvent("Change", WrapHandler(AHK_1018))
ctl_1019.OnEvent("Click", WrapHandler(AHK_1019))
ctl_1020.OnEvent("Click", WrapHandler(AHK_1020))
ctl_1021.OnEvent("Click", WrapHandler(AHK_1021))
ctl_1022.OnEvent("Click", WrapHandler(AHK_1022))
ctl_1023.OnEvent("Change", WrapHandler(AHK_1023))
ctl_1024.OnEvent("Click", WrapHandler(AHK_1024))
ctl_1025.OnEvent("Change", WrapHandler(AHK_1025))
ctl_1029.OnEvent("Click", WrapHandler(AHK_1029))
ctl_1030.OnEvent("Click", WrapHandler(AHK_1030))
ctl_1031.OnEvent("Click", WrapHandler(AHK_1031))
ctl_1032.OnEvent("Click", WrapHandler(AHK_1032))
ctl_1033.OnEvent("Click", WrapHandler(AHK_1033))
ctl_1035.OnEvent("Change", WrapHandler(AHK_1035))
ctl_1034.OnEvent("Click", WrapHandler(AHK_1034))
ctl_1036.OnEvent("Click", WrapHandler(AHK_1036))
ctl_1037.OnEvent("Click", WrapHandler(AHK_1037))
MainGui.Show("w821 h460")

SyncSettings() {
    global ctl_1001, ctl_1002, ctl_1003, ctl_1004, ctl_1005, ctl_1006, ctl_1007, ctl_1008, ctl_1009, ctl_1010, ctl_1011_1, ctl_1011_2, ctl_1012, ctl_1018, ctl_1019, ctl_1020, ctl_1021, ctl_1022, ctl_1023, ctl_1024, ctl_1025, ctl_1029, ctl_1030, ctl_1031, ctl_1032, ctl_1033, ctl_1034, ctl_1035, ctl_1036, ctl_1037
    global g_Initializing
    ctl_1001.Value := GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "AutoCheckSelect", 0)
    ctl_1002.Value := !GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "HideFileExt", 1)
    ctl_1003.Value := (GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", 2) = 1)
    ctl_1004.Value := GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "ShowFrequent", 0)
    ctl_1005.Value := (GetRegValue("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "29", "") != "")
    ctl_1006.Value := (GetRegValue("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "77", "") != "")
    ctl_1007.Value := GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState", "FullPath", 0)
    ctl_1008.Value := (GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "Link", 1) = 0)
    ctl_1009.Choose(RegKeyExists("HKCU\SOFTWARE\Classes\CLSID\{2aa9162e-c906-4dd9-ad0b-3d24a8eef5a0}") ? 1 : 2)
    ctl_1010.Choose(GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "LaunchTo", 1) = 1 ? 1 : 2)
    ctl_1011 := RegKeyExists("HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InProcServer32")
    ctl_1011_1.Value := ctl_1011
    ctl_1011_2.Value := !ctl_1011
    ctl_1012.Value := (GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3", "1806", 1) = 0)
    ctl_1018.Choose(GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search", "SearchboxTaskbarMode", 3) + 1)
    ctl_1019.Value := AHK_1019_1()
    ctl_1020.Value := GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowTaskViewButton", 1)
    ctl_1021.Value := GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowSecondsInSystemClock", 0)
    ctl_1022.Value := GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings", "TaskbarEndTask", 0)
    ctl_1023.Choose(GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarAl", 0) + 1)
    ctl_1024.Value := (GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarDa", 1) = 0)
    ctl_1025.Choose(GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarGlomLevel", 1) + 1)
    ctl_1029.Value := !GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsDynamicSearchBoxEnabled", 1)
    ctl_1030.Value := !GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start", "ShowRecentList", 1)
    ctl_1031.Value := !GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo", "Enabled", 1)
    AHK_1032_1 := GetRegValue("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin", 5)
    AHK_1032_2 := GetRegValue("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "PromptOnSecureDesktop", 1)
    ctl_1032.Value := (AHK_1032_1 = 0 && AHK_1032_2 = 0)
    ctl_1033.Value := !GetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsDeviceSearchHistoryEnabled", 1)
    ctl_1035.Choose(AHK_1035_1())
    ctl_1034.Value := (GetRegValue("HKCU\Control Panel\Accessibility\StickyKeys", "Flags", "510") = "26")
    ctl_1036.Value := (GetRegValue("HKLM\SYSTEM\ControlSet001\Services\PcaSvc", "Start", 2) = 4)
    ctl_1037.Value := (GetRegValue("HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings", "PauseUpdatesExpiryTime", "") = "2035-01-01T08:00:00Z")
    g_Initializing := false
}

AHK_1001(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "AutoCheckSelect", c.Value)
}

AHK_1002(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "HideFileExt", !c.Value)
}

AHK_1003(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", c.Value ? 1 : 2)
}

AHK_1004(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "ShowFrequent", c.Value)
}

AHK_1005(c, *) {
    if c.Value {
        SetRegValue("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "29", "C:\Windows\System32\imageres.dll,197", "REG_SZ")
        AHK_1013()
    } else {
        try {
            RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "29"
            AHK_1013()
        } catch as e {
            DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "去除快捷方式小箭头关闭失败`n`n错误信息: " . e.Message, "Str", "错误", "UInt", 0x10)
        }
    }
}

AHK_1006(c, *) {
    if c.Value {
        SetRegValue("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "77", "C:\Windows\System32\imageres.dll,197", "REG_SZ")
        AHK_1014()
    } else {
        try {
            RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "77"
            AHK_1014()
        } catch as e {
            DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "去除管理员盾牌关闭失败`n`n错误信息: " . e.Message, "Str", "错误", "UInt", 0x10)
        }
    }
}

AHK_1007(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState", "FullPath", c.Value)
}

AHK_1008(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "Link", c.Value ? 0 : 1)
    AHK_1013()
}

AHK_1009(c, *) {
    if (c.Value = 1) {
        try RegWrite "CLSID_ItemsViewAdapter", "REG_SZ", "HKCU\SOFTWARE\Classes\CLSID\{2aa9162e-c906-4dd9-ad0b-3d24a8eef5a0}"
        try RegWrite "C:\Windows\System32\Windows.UI.FileExplorer.dll_", "REG_SZ", "HKCU\SOFTWARE\Classes\CLSID\{2aa9162e-c906-4dd9-ad0b-3d24a8eef5a0}\InProcServer32"
        try RegWrite "Apartment", "REG_SZ", "HKCU\SOFTWARE\Classes\CLSID\{2aa9162e-c906-4dd9-ad0b-3d24a8eef5a0}\InProcServer32", "ThreadingModel"
        try RegWrite "File Explorer Xaml Island View Adapter", "REG_SZ", "HKCU\SOFTWARE\Classes\CLSID\{6480100b-5a83-4d1e-9f69-8ae5a88e9a33}"
        try RegWrite "C:\Windows\System32\Windows.UI.FileExplorer.dll_", "REG_SZ", "HKCU\SOFTWARE\Classes\CLSID\{6480100b-5a83-4d1e-9f69-8ae5a88e9a33}\InProcServer32"
        try RegWrite "Apartment", "REG_SZ", "HKCU\SOFTWARE\Classes\CLSID\{6480100b-5a83-4d1e-9f69-8ae5a88e9a33}\InProcServer32", "ThreadingModel"
        try RegWrite "13000000000000000000000018000000", "REG_BINARY", "HKCU\SOFTWARE\Microsoft\Internet Explorer\Toolbar\ShellBrowser", "ITBar7Layout"
        AHK_1013()
    } else {
        try Run("reg delete `"HKCU\SOFTWARE\Classes\CLSID\{2aa9162e-c906-4dd9-ad0b-3d24a8eef5a0}`" /f", , "Hide")
        try Run("reg delete `"HKCU\SOFTWARE\Classes\CLSID\{6480100b-5a83-4d1e-9f69-8ae5a88e9a33}`" /f", , "Hide")
        try Run("reg delete `"HKCU\SOFTWARE\Microsoft\Internet Explorer\Toolbar\ShellBrowser\ITBar7Layout`" /f", , "Hide")
        AHK_1013()
    }
}

AHK_1010(c, *) {
    if (c.Value = 1) {
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "LaunchTo", 1)
    } else {
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "LaunchTo", 0)
    }
}

AHK_1011_1(c, *) {
    try {
        RegWrite("", "REG_SZ", "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InProcServer32")
        AHK_1013()
    } catch as e {
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "切换右键菜单风格失败`n`n错误信息: " . e.Message, "Str", "错误", "UInt", 0x10)
    }
}

AHK_1011_2(c, *) {
    Run("reg delete `"HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}`" /f", , "Hide")
    AHK_1013()
}

AHK_1012(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3", "1806", c.Value ? 0 : 1)
}

AHK_1013(*) {
    RunWait("taskkill /f /im explorer.exe", , "Hide")
    Sleep(1000)
    Run("explorer.exe")
}

AHK_1014(*) {
    RunWait("taskkill /f /im explorer.exe", , "Hide")
    Sleep(500)
    
    localAppData := EnvGet("LOCALAPPDATA")
    appData := EnvGet("APPDATA")
    try FileDelete(localAppData . "\IconCache.db")
    explorerCache := localAppData . "\Microsoft\Windows\Explorer\"
    Loop Files explorerCache . "thumbcache_*.db"
        try FileDelete(A_LoopFileFullPath)
    Loop Files explorerCache . "iconcache_*.db"
        try FileDelete(A_LoopFileFullPath)
    try FileDelete(appData . "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\IconCache.db")

    Run("explorer.exe")
}

AHK_1015(*) {
    DllCall("shell32\SHEmptyRecycleBinW", "Ptr", 0, "Ptr", 0, "UInt", 0)
}

AHK_1016(*) {
    Run("systempropertiesperformance.exe")
}

AHK_1017(*) {
    Run("control.exe desk.cpl,,0")
}


AHK_1018(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search", "SearchboxTaskbarMode", c.Value - 1)
}

AHK_1019_1() {
    try {
        settings := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3", "Settings")
        if Type(settings) = "String" {
            hexStr := StrReplace(settings, " ")
            if StrLen(hexStr) >= 18 {
                byte9 := "0x" . SubStr(hexStr, 17, 2)
                return (byte9 = 0x03)
            }
        }
        return false
    } catch {
        return false
    }
}

AHK_1019_2(enable) {
    try {
        settings := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3", "Settings")
        if Type(settings) = "String" {
            hexStr := StrReplace(settings, " ")
            if StrLen(hexStr) >= 18 {
                newVal := enable ? "03" : "02"
                newHexStr := SubStr(hexStr, 1, 16) . newVal . SubStr(hexStr, 19)
                RegWrite(newHexStr, "REG_BINARY", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3", "Settings")
                AHK_1013()
            }
        }
    } catch as e {
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "切换自动隐藏任务栏失败`n`n错误信息: " . e.Message, "Str", "错误", "UInt", 0x10)
    }
}

AHK_1019(c, *) {
    AHK_1019_2(c.Value)
}

AHK_1020(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowTaskViewButton", c.Value ? 1 : 0)
    DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "可能会导致任务视图图标显示异常，如有异常请刷新图标缓存", "Str", "提示", "UInt", 0x40)
}

AHK_1021(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowSecondsInSystemClock", c.Value ? 1 : 0)
}

AHK_1022(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings", "TaskbarEndTask", c.Value ? 1 : 0)
}

AHK_1023(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarAl", c.Value - 1)
    Run(A_ScriptFullPath)
    ExitApp()
}

AHK_1024(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarDa", c.Value ? 0 : 1)
    Sleep(1000)
    Run("ms-settings:taskbar")
    DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "该选项因权限原因，有可能有效有可能无效`n`n如果无效请尝试手动关闭", "Str", "提示", "UInt", 0x40)
}

AHK_1025(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarGlomLevel", c.Value - 1)
}

AHK_1026(*) {
    Run("control.exe")
}

AHK_1027(*) {
    Run("diskmgmt.msc")
}

AHK_1028(*) {
    Run("devmgmt.msc")
}

AHK_1029(c, *) {
    SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsDynamicSearchBoxEnabled", c.Value ? 0 : 1)
}

AHK_1030(c, *) {
    if c.Value {
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start", "ShowRecentList", 0)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start", "ShowFrequentList", 0)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Start_TrackDocs", 0)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Start_IrisRecommendations", 0)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Start_AccountNotifications", 0)
        Run("ms-settings:personalization-start")
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "已关闭推荐的项目", "Str", "提示", "UInt", 0x40)
    } else {
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start", "ShowRecentList", 1)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start", "ShowFrequentList", 1)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Start_TrackDocs", 1)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Start_IrisRecommendations", 1)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Start_AccountNotifications", 1)
        Run("ms-settings:personalization-start")
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "已启用推荐的项目", "Str", "提示", "UInt", 0x40)
    }
}

AHK_1031(c, *) {
    if c.Value {
        RegWrite(0, "REG_DWORD", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo", "Enabled")
        RegWrite(0, "REG_DWORD", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-338393Enabled")
        RegWrite(0, "REG_DWORD", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-353694Enabled")
        RegWrite(0, "REG_DWORD", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-353696Enabled")
        try RegDelete("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo", "Id")
        Run("ms-settings:privacy-general")
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "已关闭广告跟踪", "Str", "提示", "UInt", 0x40)
    } else {
        RegWrite(1, "REG_DWORD", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo", "Enabled")
        RegWrite(1, "REG_DWORD", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-338393Enabled")
        RegWrite(1, "REG_DWORD", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-353694Enabled")
        RegWrite(1, "REG_DWORD", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", "SubscribedContent-353696Enabled")
        Run("ms-settings:privacy-general")
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "已开启广告跟踪", "Str", "提示", "UInt", 0x40)
    }
}

AHK_1032(c, *) {
    if c.Value {
        Run("useraccountcontrolsettings.exe")
        Sleep(500)
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "该选项建议手动设置`n`n禁用 - 始终不要通知我 - 从不通知", "Str", "提示", "UInt", 0x40040)
    } else {
        Run("useraccountcontrolsettings.exe")
        Sleep(500)
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "该选项建议手动设置`n`n默认 - 仅当应用尝试更改我的计算机时通知我", "Str", "提示", "UInt", 0x40040)
    }
}

AHK_1033(c, *) {
    if c.Value {
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsDeviceSearchHistoryEnabled", 0)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsMSACloudSearchEnabled", 0)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsAADCloudSearchEnabled", 0)
        Run("ms-settings:search")
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "关闭历史记录后需手动清理一下历史记录", "Str", "提示", "UInt", 0x40)
    } else {
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsDeviceSearchHistoryEnabled", 1)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsMSACloudSearchEnabled", 1)
        SetRegValue("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings", "IsAADCloudSearchEnabled", 1)
    }
}

AHK_1034(c, *) {
    SetRegValue("HKCU\Control Panel\Accessibility\StickyKeys", "Flags", c.Value ? "26" : "510", "REG_SZ")
    if DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "该设置需要重启电脑才能完全生效`n`n是否立即重启电脑？", "Str", "重启电脑", "UInt", 0x24) = 6
        Shutdown(2)
}

AHK_1035_1() {
    try {
        tempFile := EnvGet("TEMP") . "\powerplan.txt"
        RunWait('powershell -NoProfile -Command "powercfg /getactivescheme | Out-File -FilePath `"' . tempFile . '`" -Encoding UTF8"', , "Hide")
        content := FileRead(tempFile)
        FileDelete(tempFile)
        if InStr(content, "381b4222-f694-41f0-9685-ff5bb260df2e")
            return 1
        else if InStr(content, "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c")
            return 2
        return 1
    } catch {
        return 1
    }
}

AHK_1035(c, *) {
    if (c.Value = 1) {
        RunWait('powershell -Command "powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e"', , "Hide")
    } else if (c.Value = 2) {
        RunWait('powershell -Command "powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"', , "Hide")
    }
}

AHK_1036(c, *) {
    SetRegValue("HKLM\SYSTEM\ControlSet001\Services\PcaSvc", "Start", c.Value ? 4 : 2)
    Run(c.Value ? "sc stop PcaSvc" : "sc start PcaSvc", , "Hide")
}

AHK_1037(c, *) {
    if c.Value {
        Run('reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v FlightSettingsMaxPauseDays /t REG_DWORD /d 3652 /f', , "Hide")
        Run('reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesStartTime /t REG_SZ /d "2026-01-01T08:00:00Z" /f', , "Hide")
        Run('reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesEndTime /t REG_SZ /d "2035-01-01T08:00:00Z" /f', , "Hide")
        Run('reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesStartTime /t REG_SZ /d "2026-01-01T08:00:00Z" /f', , "Hide")
        Run('reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesEndTime /t REG_SZ /d "2035-01-01T08:00:00Z" /f', , "Hide")
        Run('reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesStartTime /t REG_SZ /d "2026-01-01T08:00:00Z" /f', , "Hide")
        Run('reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /t REG_SZ /d "2035-01-01T08:00:00Z" /f', , "Hide")
        Run("ms-settings:windowsupdate")
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "Windows更新已延长`n如果失败请手动暂停更新", "Str", "提示", "UInt", 0x40)
    } else {
        Run('reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v FlightSettingsMaxPauseDays /f', , "Hide")
        Run('reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesStartTime /f', , "Hide")
        Run('reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesEndTime /f', , "Hide")
        Run('reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesStartTime /f', , "Hide")
        Run('reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesEndTime /f', , "Hide")
        Run('reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesStartTime /f', , "Hide")
        Run('reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /f', , "Hide")
        Run("ms-settings:windowsupdate")
        DllCall("user32\MessageBox", "Ptr", MainGui.Hwnd, "Str", "Windows更新已恢复`n您可继续更新", "Str", "提示", "UInt", 0x40)
    }
}