; 脚本由 Inno Setup 脚本向导 生成！
; 有关创建 Inno Setup 脚本文件的详细资料请查阅帮助文档！

#define MyAppName "小类串并"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "北京海鑫科金高科技股份有限公司"
#define MyAppURL "http://www.hisign.com.cn"
#define MyAppEnName "hisignXlcb"
#define MyAppExeName "hisignXlcb.exe"
#define ExeOutputDir "C:\"
#define AppDistDir "D:\code\one-client\tmp"
[Setup]
; 注: AppId的值为单独标识该应用程序。
; 不要为其他安装程序使用相同的AppId值。
; (生成新的GUID，点击 工具|在IDE中生成GUID。)
AppId={{C1CD70E3-B62A-4AD8-8C2D-F38E25F80360}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppEnName}
DefaultGroupName={#MyAppName}
OutputDir={#ExeOutputDir}
OutputBaseFilename={#MyAppEnName}Setup
SetupIconFile={#AppDistDir}\favicon.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkablealone

[Files]
Source: "{#AppDistDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#AppDistDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; 注意: 不要在任何共享系统文件上使用“Flags: ignoreversion”

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}";IconFilename: "{app}\favicon.ico"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Registry] 
Root: HKLM; Subkey: "SOFTWARE\{#MyAppEnName}\Install"; ValueType: string; ValueName: "path"; ValueData: "{app}\{#MyAppExeName}" ;Flags: uninsdeletekey 
[code]


function IsAppRunning(const FileName : string): Boolean;
var
    FSWbemLocator: Variant;
    FWMIService   : Variant;
    FWbemObjectSet: Variant;
begin
    Result := false;
    FSWbemLocator := CreateOleObject('WBEMScripting.SWBEMLocator');
    FWMIService := FSWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
    FWbemObjectSet := FWMIService.ExecQuery(Format('SELECT Name FROM Win32_Process Where Name="%s"',[FileName]));
    Result := (FWbemObjectSet.Count > 0);
    FWbemObjectSet := Unassigned;
    FWMIService := Unassigned;
    FSWbemLocator := Unassigned;
end;

function InitializeUninstall():Boolean;
var ifRunning:boolean;
var appWnd: HWND;
var ifStop:boolean;
begin
   ifRunning := IsAppRunning('{#MyAppExeName}');
   if ifRunning then
        ifStop := MsgBox('检测到客户端正在运行，卸载前须退出程序，是否继续？', mbConfirmation, MB_YESNO) = idYes;

        if ifStop then

        appWnd := FindWindowByClassName('Chrome_WidgetWin_0');
        if (appWnd <> 0) then
         begin
            PostMessage(appWnd, 18, 0, 0);       // quit
             Result := true;
         end;

        if ifStop = false then
           Result := false;

   if ifRunning = false then
      Result := true;
end;

function InitializeSetup(): Boolean;
var ifRunning:boolean;
var appWnd: HWND;
var ifStop:boolean;
begin
 ifRunning := IsAppRunning('{#MyAppExeName}');
  if ifRunning then
     ifStop := MsgBox('检测到客户端正在运行，安装前须退出程序，是否继续？', mbConfirmation, MB_YESNO) = idYes;
     if ifStop then
     appWnd := FindWindowByClassName('Chrome_WidgetWin_0');
        if (appWnd <> 0) then
         begin
            PostMessage(appWnd, 18, 0, 0);       // quit
             Result := true;
         end;
  if ifStop = false then
         Result := false;

  if ifRunning = false then
          Result := true;


end;