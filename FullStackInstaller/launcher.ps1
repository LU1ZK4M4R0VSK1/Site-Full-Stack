# launcher.ps1
Write-Host "🚀 Full Stack Project Launcher" -ForegroundColor Cyan
Write-Host ""

$projectPath = Read-Host "Digite o caminho do seu projeto Full Stack (ou deixe em branco para procurar)"

if ([string]::IsNullOrWhiteSpace($projectPath)) {
    Add-Type -AssemblyName System.Windows.Forms
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Selecione a pasta do projeto Full Stack"
    
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $projectPath = $folderDialog.SelectedPath
    } else {
        Write-Host "Nenhuma pasta selecionada." -ForegroundColor Red
        Read-Host "Pressione Enter para sair"
        exit
    }
}

if (Test-Path "$projectPath\start.ps1") {
    Set-Location $projectPath
    .\start.ps1
} else {
    Write-Host "Projeto Full Stack não encontrado na pasta especificada." -ForegroundColor Red
    Write-Host "Certifique-se de que o projeto foi criado pelo instalador." -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
}