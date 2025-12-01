; Script de instalação do Full Stack Project
; Compilado com Inno Setup 6

#define MyAppName "Full Stack Project Template"
#define MyAppVersion "1.0"
#define MyAppPublisher "FullStack Dev"
#define MyAppURL "https://github.com"

[Setup]
AppId={{F47AC10B-58CC-4372-A567-0E02B2C3D479}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
OutputDir=output
OutputBaseFilename=FullStackProjectSetup

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1

[Files]
Source: "setup.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "launcher.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\launcher.ps1"""
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\launcher.ps1"""; Tasks: desktopicon

[Run]
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\setup.ps1"""; StatusMsg: "Configurando ambiente..."; Flags: runhidden

[Code]
// Página personalizada para selecionar local do projeto
var
  ProjectDirPage: TInputDirWizardPage;

procedure InitializeWizard;
begin
  // Criar página personalizada para selecionar diretório do projeto
  ProjectDirPage := CreateInputDirPage(
    wpSelectDir,
    'Selecione o local do projeto',
    'Onde você deseja criar o projeto Full Stack?',
    'Selecione a pasta onde o projeto será criado.',
    False,
    ''
  );
  
  ProjectDirPage.Add('Pasta do projeto:');
  ProjectDirPage.Values[0] := ExpandConstant('{userdocs}\Projects\FullStackApp');
end;

function GetProjectDir(Param: String): String;
begin
  Result := ProjectDirPage.Values[0];
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // Salvar o diretório do projeto
    SaveStringToFile(ExpandConstant('{app}\project-path.txt'), GetProjectDir(''), False);
  end;
end;