#Requires -Version 5.1
<#
.SYNOPSIS
    Script de instalacao Full Stack (.NET + React)
.PARAMETER ProjectDir
    Diretorio onde o projeto sera criado
#>

param (
    [string]$ProjectDir = ""
)

# ==================================================
# CONFIGURACOES
# ==================================================
$BackendPort = 5000
$BackendUrl = "http://localhost:$BackendPort"
$HealthCheckTimeout = 30
$BackendProcess = $null

# ==================================================
# FUNCOES DE LOG
# ==================================================
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "Info"
    )
    
    $icon = switch ($Level) {
        "Info"    { "INFO" }
        "Success" { "OK" }
        "Warning" { "WARN" }
        "Error"   { "ERRO" }
        "Header"  { "====" }
    }
    
    $color = switch ($Level) {
        "Info"    { "Cyan" }
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error"   { "Red" }
        "Header"  { "Magenta" }
    }
    
    Write-Host "[$icon] $Message" -ForegroundColor $color
    
    # Tenta enviar para API
    try {
        $body = @{ Message = "[$icon] $Message" } | ConvertTo-Json
        Invoke-RestMethod -Uri "$BackendUrl/api/logs" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 1 -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        # Ignora erros de envio de log
    }
}

# ==================================================
# VALIDACAO
# ==================================================
function Test-Tool {
    param([string]$Command)
    
    $found = Get-Command $Command -ErrorAction SilentlyContinue
    return ($null -ne $found)
}

function Test-Prerequisites {
    Write-Log "Verificando pre-requisitos..." -Level Info
    
    $allOk = $true
    
    if (Test-Tool "dotnet") {
        $version = dotnet --version
        Write-Log "dotnet encontrado: $version" -Level Success
    }
    else {
        Write-Log ".NET SDK nao encontrado!" -Level Error
        $allOk = $false
    }
    
    if (Test-Tool "npm") {
        $version = npm --version
        Write-Log "npm encontrado: $version" -Level Success
    }
    else {
        Write-Log "Node.js/npm nao encontrado!" -Level Error
        $allOk = $false
    }
    
    if (-not $allOk) {
        throw "Pre-requisitos nao atendidos"
    }
}

# ==================================================
# GERENCIAMENTO BACKEND
# ==================================================
function Start-Backend {
    param([string]$Path)
    
    $backendPath = Join-Path $Path "backend"
    
    if (-not (Test-Path $backendPath)) {
        Write-Log "Backend ainda nao existe" -Level Warning
        return $false
    }
    
    try {
        Write-Log "Compilando backend..." -Level Info
        Push-Location $backendPath
        
        dotnet build --verbosity quiet | Out-Null
        
        Write-Log "Iniciando servidor backend..." -Level Info
        
        $script:BackendProcess = Start-Process -FilePath "dotnet" -ArgumentList "run --urls $BackendUrl" -WorkingDirectory $backendPath -WindowStyle Hidden -PassThru
        
        Write-Log "Backend iniciado (PID: $($script:BackendProcess.Id))" -Level Success
        
        if (Wait-Backend) {
            Write-Log "Backend online!" -Level Success
            return $true
        }
        else {
            Write-Log "Backend nao respondeu" -Level Warning
            return $false
        }
    }
    catch {
        Write-Log "Erro ao iniciar backend: $_" -Level Error
        return $false
    }
    finally {
        Pop-Location
    }
}

function Wait-Backend {
    Write-Log "Aguardando backend..." -Level Info
    
    for ($i = 0; $i -lt $HealthCheckTimeout; $i++) {
        try {
            $response = Invoke-WebRequest "$BackendUrl/health" -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                return $true
            }
        }
        catch {
            # Continua tentando
        }
        
        Start-Sleep -Seconds 1
        
        if (($i % 5) -eq 0 -and $i -gt 0) {
            Write-Log "Aguardando... ($i/$HealthCheckTimeout seg)" -Level Info
        }
    }
    
    return $false
}

function Stop-Backend {
    if ($script:BackendProcess -and -not $script:BackendProcess.HasExited) {
        try {
            Write-Log "Encerrando backend..." -Level Info
            $script:BackendProcess.Kill()
            $script:BackendProcess.WaitForExit(5000)
            Write-Log "Backend encerrado" -Level Success
        }
        catch {
            Write-Log "Erro ao encerrar backend: $_" -Level Warning
        }
    }
}

# ==================================================
# CRIACAO DE PROJETOS
# ==================================================
function New-Backend {
    param([string]$Path)
    
    Write-Log "Criando projeto Backend (.NET)..." -Level Header
    
    $backendPath = Join-Path $Path "backend"
    
    try {
        dotnet new webapi -n "backend" -o $backendPath --no-https --force | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            throw "dotnet new falhou"
        }
        
        Write-Log "Projeto .NET criado" -Level Success
        
        # Copia templates
        $templatePath = Join-Path $PSScriptRoot "templates\backend"
        if (Test-Path $templatePath) {
            Copy-Item "$templatePath\*" $backendPath -Recurse -Force -ErrorAction SilentlyContinue
            
            Get-ChildItem $backendPath -Recurse -Filter "*.txt" -ErrorAction SilentlyContinue | ForEach-Object {
                $newName = $_.FullName -replace "\.txt$", ""
                Rename-Item $_.FullName $newName -Force -ErrorAction SilentlyContinue
            }
            
            Write-Log "Templates aplicados" -Level Success
        }
        
        return $true
    }
    catch {
        Write-Log "Erro ao criar backend: $_" -Level Error
        return $false
    }
}

function New-Frontend {
    param([string]$Path)
    
    Write-Log "Criando projeto Frontend (Vite+React)..." -Level Header
    
    $frontendPath = Join-Path $Path "frontend"
    
    try {
        if (Test-Path $frontendPath) {
            Remove-Item $frontendPath -Recurse -Force
        }
        
        npm create vite@latest $frontendPath -- --template react-ts | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            throw "npm create vite falhou"
        }
        
        Write-Log "Projeto Vite criado" -Level Success
        
        # Copia templates
        $templatePath = Join-Path $PSScriptRoot "templates\frontend"
        if (Test-Path $templatePath) {
            Copy-Item "$templatePath\*" $frontendPath -Recurse -Force -ErrorAction SilentlyContinue
            
            Get-ChildItem $frontendPath -Recurse -Filter "*.txt" -ErrorAction SilentlyContinue | ForEach-Object {
                $newName = $_.FullName -replace "\.txt$", ""
                Rename-Item $_.FullName $newName -Force -ErrorAction SilentlyContinue
            }
            
            Write-Log "Templates aplicados" -Level Success
        }
        
        return $true
    }
    catch {
        Write-Log "Erro ao criar frontend: $_" -Level Error
        return $false
    }
}

# ==================================================
# DEPENDENCIAS
# ==================================================
function Install-Dependencies {
    param([string]$Path)
    
    Write-Log "Instalando dependencias..." -Level Header
    
    # Backend
    try {
        Write-Log "Restaurando pacotes .NET..." -Level Info
        Push-Location (Join-Path $Path "backend")
        dotnet restore --verbosity quiet | Out-Null
        Write-Log "Pacotes .NET OK" -Level Success
    }
    catch {
        Write-Log "Erro ao restaurar .NET: $_" -Level Error
    }
    finally {
        Pop-Location
    }
    
    # Frontend
    try {
        Write-Log "Instalando pacotes npm..." -Level Info
        Push-Location (Join-Path $Path "frontend")
        npm install --silent | Out-Null
        Write-Log "Pacotes npm OK" -Level Success
    }
    catch {
        Write-Log "Erro ao instalar npm: $_" -Level Error
    }
    finally {
        Pop-Location
    }
}

# ==================================================
# ARQUIVOS DE SUPORTE
# ==================================================
function New-SupportFiles {
    param([string]$Path)
    
    Write-Log "Criando arquivos de suporte..." -Level Header
    
    # .gitignore
    $gitignore = @"
node_modules/
/dist
/build
/publish
.vs/
.vscode/
*.user
*.suo
bin/
obj/
*.db
*.log
"@
    
    Set-Content -Path (Join-Path $Path ".gitignore") -Value $gitignore -Encoding UTF8
    
    # README.md
    $readme = @"
# Full Stack Project

Projeto gerado com FullStackInstaller.

## Como usar

### Backend
``````bash
cd backend
dotnet restore
dotnet run
``````

### Frontend
``````bash
cd frontend
npm install
npm run dev
``````

## URLs
- Frontend: http://localhost:5173
- Backend: http://localhost:5000
"@
    
    Set-Content -Path (Join-Path $Path "README.md") -Value $readme -Encoding UTF8
    
    Write-Log "Arquivos criados" -Level Success
}

# ==================================================
# FUNCAO PRINCIPAL
# ==================================================
function Start-Setup {
    param([string]$Dir)
    
    $success = $false
    
    try {
        # Banner
        Write-Host ""
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host "  FULL STACK INSTALLER v2.0" -ForegroundColor Cyan
        Write-Host "  .NET + React + Vite + TypeScript" -ForegroundColor Cyan
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host ""
        
        # Valida diretorio
        if ([string]::IsNullOrWhiteSpace($Dir)) {
            Write-Log "Diretorio nao especificado" -Level Error
            $Dir = Read-Host "Digite o caminho do projeto"
            
            if ([string]::IsNullOrWhiteSpace($Dir)) {
                throw "Caminho invalido"
            }
        }
        
        Write-Log "Diretorio: $Dir" -Level Info
        
        # Cria diretorio
        if (-not (Test-Path $Dir)) {
            New-Item -ItemType Directory -Path $Dir -Force | Out-Null
            Write-Log "Diretorio criado" -Level Success
        }
        
        # Valida pre-requisitos
        Test-Prerequisites
        
        Write-Host ""
        Write-Log "INICIANDO INSTALACAO" -Level Header
        Write-Host ""
        
        # Cria projetos
        if (-not (New-Backend -Path $Dir)) {
            throw "Falha ao criar backend"
        }
        
        if (-not (New-Frontend -Path $Dir)) {
            throw "Falha ao criar frontend"
        }
        
        # Inicia backend
        Start-Backend -Path $Dir | Out-Null
        
        # Cria suporte
        New-SupportFiles -Path $Dir
        
        # Instala dependencias
        Install-Dependencies -Path $Dir
        
        # Sucesso
        Write-Host ""
        Write-Log "PROJETO CRIADO COM SUCESSO!" -Level Success
        Write-Host ""
        Write-Log "Localizacao: $Dir" -Level Info
        Write-Log "Consulte o README.md" -Level Info
        Write-Host ""
        
        $success = $true
        
        # Pergunta se quer abrir
        $response = Read-Host "Abrir pasta do projeto? (S/N)"
        if ($response -match "^[Ss]$") {
            Invoke-Item $Dir
        }
    }
    catch {
        Write-Host ""
        Write-Log "ERRO DURANTE INSTALACAO" -Level Error
        Write-Log $_.Exception.Message -Level Error
        Write-Host ""
    }
    finally {
        Stop-Backend
        
        Write-Host ""
        Write-Log "Pressione ENTER para sair..." -Level Info
        Read-Host
    }
    
    return $success
}

# ==================================================
# EXECUCAO
# ==================================================

# Le caminho salvo
$projectPathFile = Join-Path $PSScriptRoot "project-path.txt"
if ([string]::IsNullOrWhiteSpace($ProjectDir) -and (Test-Path $projectPathFile)) {
    $ProjectDir = (Get-Content $projectPathFile -Raw).Trim()
}

# Executa
$result = Start-Setup -Dir $ProjectDir

# Exit code
if ($result) {
    exit 0
}
else {
    exit 1
}