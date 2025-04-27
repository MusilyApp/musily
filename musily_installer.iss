; musily_installer.iss
[Setup]
AppName=Musily
AppVersion=3.1.1
DefaultDirName={localappdata}\Musily
OutputBaseFilename=musily-installer
DefaultGroupName=Musily
Compression=lzma
SolidCompression=yes

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\Musily"; Filename: "{app}\Musily.exe"
