#define WA_Version "3.8.1"
#define CZ_Version "3.1"

[PreCompile]
Name: "prepare.bat"; Flags: abortonerror cmdprompt

[Setup]
AppVersion={#CZ_Version}
VersionInfoVersion={#CZ_Version}

AppName=Worms Armageddon Èeština
AppId=WormsArmageddonCZ
DefaultDirName={code:GetDirName}
AppendDefaultDirName=no
Compression=lzma2
SolidCompression=yes
DirExistsWarning=no
DisableStartupPrompt=no
OutputBaseFilename=wa_cestina
OutputDir=output
ArchitecturesInstallIn64BitMode=x64 ia64
AppPublisher=Robert Pösel (Robyer)
AppPublisherURL=http://www.robyer.cz/cestiny/worms-armageddon
InfoBeforeFile=text_before.txt
InfoAfterFile=text_after.txt
EnableDirDoesntExistWarning=no
Uninstallable=no
WizardStyle=modern
WizardSmallImageFile=wa_cestina_top.bmp
WizardImageFile=wa_cestina_side.bmp
SetupIconFile=wa_cestina_icon.ico
DisableWelcomePage=False

[Languages]
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"

[Files]
Source: "output\Czech.txt"; DestDir: "{app}\Data\User\Languages\{#WA_Version}"
Source: "..\fonts\Worms Armageddon\*"; DestDir: "{app}"; Flags: recursesubdirs
Source: "..\media\Worms Armageddon\*"; DestDir: "{app}"; Flags: recursesubdirs onlyifdoesntexist

[Run]
Filename: {code:GetFileName}; Description: Spustit Worms Armageddon; Flags: postinstall shellexec skipifsilent

[Code]
/////////////////////////////////////////////////////////////////////
function NextButtonClick(PageId: Integer): Boolean;
begin
  Result := True;
  if (PageId = wpSelectDir) then
  begin
    if (not FileExists(ExpandConstant('{app}\WA.exe'))) then begin
      if MsgBox('Vybraná složka není správná (neobsahuje soubor WA.exe)!' + #13 + 'Pøejete si i pøesto instalovat èeštinu do vybrané složky?', mbError, MB_YESNO or MB_DEFBUTTON2) <> IDYES then begin
        Result := False;
        exit;
      end;
    end;
  end;
end;

/////////////////////////////////////////////////////////////////////
function WAManifestExists(Directory: string): Boolean;
begin
  Result := FileExists(Directory + '/appmanifest_217200.acf')
end;

function GetDirName(Value: string): string;
var
  SteamPath: string;
  SteamLibraryPath: string;
  SteamLibraryFolders: TArrayOfString;
  I, X: integer;
  Line: string;
begin
  // Try 32-bit path
  SteamPath := ExpandConstant('{reg:HKLM\SOFTWARE\Valve\Steam,InstallPath}');
  if (SteamPath = '') then
  begin
    // Try 64-bit path
    SteamPath := ExpandConstant('{reg:HKLM\SOFTWARE\WOW6432Node\Valve\Steam,InstallPath}');
  end;
  if (SteamPath = '') then
  begin
    // Steam not installed? Try to use default Steam folder.
    SteamPath := ExpandConstant('{commonpf32}\Steam');
  end;

  SteamLibraryPath := SteamPath + '\steamapps';
  if WAManifestExists(SteamLibraryPath) then
  begin
    Result := SteamLibraryPath + '\common\Worms Armageddon'
    exit;
  end;

  // Try to find other library folders where WA could be installed
  if (LoadStringsFromFile(SteamLibraryPath + '\libraryfolders.vdf', SteamLibraryFolders)) then
  begin
    for I := 1 to GetArrayLength(SteamLibraryFolders) do begin
      Line := SteamLibraryFolders[I-1];
      X := Pos(':\\', Line);
      if (X > 0) then
      begin  
        // This contains the library path, extract it
        Delete(Line, 1, X-3)
        Line := RemoveQuotes(Trim(Line));
        // Replace double '\\' in path
        StringChange(Line, '\\', '\');

        SteamLibraryPath := Line + '\steamapps';
        // Test it for the WA manifest
        if WAManifestExists(SteamLibraryPath) then
        begin
          Result := SteamLibraryPath + '\common\Worms Armageddon'
          exit;
        end;
      end;
    end;
  end;

  // WA was not found in any Steam library, return default path
  Result := 'C:\Hry\Worms Armageddon';
end;

function GetFileName(Value: string): string;
begin
  Result := ExpandConstant('{app}\WA.exe')
end;