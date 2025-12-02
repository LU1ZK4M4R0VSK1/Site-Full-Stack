# Script de configuração do Full Stack Project

# Parâmetros
param (
    [string]$ProjectDir
)

# --- Configurações ---
$BackendPort = 5000
$BackendUrl = "http://localhost:$BackendPort"

# Variável global para rastrear o processo do backend
$global:BackendProcess = $null

# --- Funções ---

# Função para enviar logs para a API do backend (com tentativas)
function Send-Log {
    param([string]$Message)
    
    # Escreve o log no console local
    Write-Host $Message
    
    # Tenta enviar o log para a API do backend 3 vezes
    for ($i = 0; $i -lt 3; $i++) {
        try {
            $body = @{ Message = $Message } | ConvertTo-Json
            Invoke-RestMethod -Uri "$BackendUrl/api/logs" `
                -Method Post `
                -Body $body `
                -ContentType "application/json" `
                -TimeoutSec 2 | Out-Null
            return # Sai da função se o envio for bem-sucedido
        } catch {
            if ($i -eq 2) {
                Write-Host "  ⚠️ Não foi possível enviar log para a interface gráfica após 3 tentativas."
            }
            Start-Sleep -Seconds 1
        }
    }
}

# Função para iniciar o backend em background para receber os logs
function Start-Backend-For-Logs {
    param([string]$Path)
    
    $backendPath = "$Path\backend"
    
    if (Test-Path $backendPath) {
        try {
            Send-Log "  - Compilando o backend para garantir que está pronto..."
            Set-Location $backendPath
            dotnet build | Out-Null
            
            Send-Log "  - Iniciando o processo do backend em background..."
            # Força a porta para evitar conflitos se a porta padrão 5000 estiver ocupada
            $global:BackendProcess = Start-Process dotnet -ArgumentList "run --urls $BackendUrl" `
                -WorkingDirectory $backendPath `
                -WindowStyle Hidden `
                -PassThru
            
            Send-Log "  - Backend iniciado para logs (PID: $($global:BackendProcess.Id)) em $BackendUrl"
            
            # Espera inteligente pelo backend responder, com timeout
            Send-Log "  - Aguardando o backend ficar online..."
            $timeout = 30 # segundos
            $started = $false
            for ($i = 0; $i -lt $timeout; $i++) {
                try {
                    # O endpoint /api/logs deve estar disponível
                    $response = Invoke-WebRequest "$BackendUrl/api/logs" -TimeoutSec 2 -ErrorAction SilentlyContinue
                    if ($response) {
                        Send-Log "  - Backend está online!"
                        $started = $true
                        break
                    }
                } catch {}
                Start-Sleep -Seconds 1
            }
            
            if (-not $started) {
                Send-Log "  ⚠️ ATENÇÃO: Backend não respondeu após $timeout segundos. A interface de logs pode não funcionar."
            }
            
        } catch {
            Send-Log "❌ Erro crítico ao tentar iniciar o backend para logs: $_"
        } finally {
            Set-Location $PSScriptRoot
        }
    }
}

# Função para parar o backend de logs
function Stop-Backend-For-Logs {
    if ($global:BackendProcess -and (-not $global:BackendProcess.HasExited)) {
        Send-Log "  - Encerrando o processo do backend de logs..."
        $global:BackendProcess.Kill()
        Send-Log "  - Processo do backend finalizado."
    }
}

# Função para verificar se um comando existe
function Test-CommandExists {
    param([string]$command)
    return (Get-Command $command -ErrorAction SilentlyContinue)
}

# Função para criar o projeto backend
function Create-Backend-Project {
    param([string]$Path)
    
    Send-Log "✨ Criando projeto Backend (.NET)..."
    
    if (-not (Test-CommandExists "dotnet")) {
        Send-Log "❌ ERRO: .NET SDK não encontrado. Instale-o para continuar."
        exit 1
    }
    
    try {
        dotnet new webapi -n "backend" -o "$Path\backend" --no-https --force | Out-Null
        Send-Log "  ✅ Projeto .NET criado com 'dotnet new'"
    } catch {
        Send-Log "  ❌ Falha ao executar 'dotnet new'. Detalhes: $_"
        exit 1
    }

    Send-Log "  - Copiando arquivos de template do backend..."
    $templatePath = Join-Path $PSScriptRoot "templates/backend"
    Copy-Item -Path "$templatePath/*" -Destination "$Path\backend" -Recurse -Force
    
    Get-ChildItem -Path "$Path\backend" -Recurse -Filter *.txt | ForEach-Object {
        $newName = $_.FullName.Replace(".txt", "")
        Rename-Item -Path $_.FullName -NewName $newName -Force
    }

    Send-Log "  ✅ Arquivos do Backend configurados."
}

# Função para criar o projeto frontend
function Create-Frontend-Project {
    param([string]$Path)
    
    Send-Log "✨ Criando projeto Frontend (Vite/React)..."
    
    if (-not (Test-CommandExists "npm")) {
        Send-Log "❌ ERRO: Node.js/npm não encontrado. Instale-o para continuar."
        exit 1
    }
    
    try {
        # O vite precisa de um diretório vazio ou inexistente
        if(Test-Path "$Path\frontend"){ Remove-Item -Recurse -Force "$Path\frontend" }
        npm create vite@latest "$Path\frontend" -- --template react-ts | Out-Null
        Send-Log "  ✅ Projeto Vite/React criado com 'npm create vite'"
    } catch {
        Send-Log "  ❌ Falha ao executar 'npm create vite'. Detalhes: $_"
        exit 1
    }
    
    Send-Log "  - Copiando arquivos de template do frontend..."
    $templatePath = Join-Path $PSScriptRoot "templates/frontend"
    Copy-Item -Path "$templatePath/*" -Destination "$Path\frontend" -Recurse -Force

    Get-ChildItem -Path "$Path\frontend" -Recurse -Filter *.txt | ForEach-Object {
        $newName = $_.FullName.Replace(".txt", "")
        Rename-Item -Path $_.FullName -NewName $newName -Force
    }

    Send-Log "  ✅ Arquivos do Frontend configurados."
}

# Função para criar arquivos de suporte
function Create-Support-Files {
    param([string]$Path)
    
    Send-Log "✨ Criando arquivos de suporte..."
    
    @"
/node_modules
/dist
/build
/publish
/.vs
/.vscode
/bin
/obj
*.user
*.suo
app.db
*.log
"@ | Out-File -FilePath "$Path/.gitignore" -Encoding utf8
    Send-Log "  - .gitignore criado."
    
    @"
Write-Host "🚀 Full Stack Project Launcher"
# Adicionar lógica de menu aqui se desejar
# ...
"@ | Out-File -FilePath "$Path/start.ps1" -Encoding utf8
    Send-Log "  - start.ps1 criado."

    @"
# 🚀 Full Stack Project

Projeto gerado com o FullStackInstaller.

## Para começar

1.  **Instale as dependências:**
    *   `cd backend && dotnet restore`
    *   `cd frontend && npm install`

2.  **Execute os projetos:**
    *   Backend: `cd backend && dotnet run`
    *   Frontend: `cd frontend && npm run dev`
"@ | Out-File -FilePath "$Path/README.md" -Encoding utf8
    Send-Log "  - README.md criado."
    
    Send-Log "  ✅ Arquivos de suporte criados."
}

# Função para instalar dependências
function Install-Dependencies {
    param([string]$Path)
    
    Send-Log "⚙️ Instalando dependências..."
    
    try {
        Send-Log "  - Restaurando pacotes .NET..."
        Set-Location "$Path/backend"
        dotnet restore | Out-Null
        Send-Log "    ✅ Dependências do Backend instaladas."
    } catch {
        Send-Log "    ❌ Erro ao instalar dependências do Backend. Detalhes: $_"
    }
    
    try {
        Send-Log "  - Instalando pacotes npm..."
        Set-Location "$Path/frontend"
        npm install | Out-Null
        Send-Log "    ✅ Dependências do Frontend instaladas."
    } catch {
        Send-Log "    ❌ Erro ao instalar dependências do Frontend. Detalhes: $_"
    }
    
    Set-Location $Path
}


# --- Função Principal ---
function Main {
    param([string]$ProjectDir)
    
    if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
        Send-Log "❌ ERRO: O diretório do projeto não foi fornecido."
        Read-Host "Pressione Enter para sair"
        exit 1
    }
    
    if (-not (Test-Path $ProjectDir)) {
        Send-Log "  - Criando diretório do projeto em: $ProjectDir"
        New-Item -ItemType Directory -Path $ProjectDir -Force | Out-Null
    }
    
    Send-Log "🚀 Iniciando criação do projeto Full Stack em: $ProjectDir"
    Send-Log ("-" * 60)
    
    # 1. Cria a estrutura base primeiro
    Create-Backend-Project -Path $ProjectDir
    Create-Frontend-Project -Path $ProjectDir
    
    # 2. Agora, inicia o backend para que ele possa receber os logs
    Start-Backend-For-Logs -Path $ProjectDir
    
    # 3. Continua com o resto do setup, agora enviando logs
    Create-Support-Files -Path $ProjectDir
    Install-Dependencies -Path $ProjectDir
    
    Send-Log ("-" * 60)
    Send-Log "✅ PROJETO CRIADO COM SUCESSO!"
    Send-Log ("-" * 60)
    Send-Log "📁 O projeto está em: $ProjectDir"
    Send-Log "🚀 Para iniciar, navegue até a pasta e siga as instruções do README.md"
    Send-Log "🎉 A interface com os logs da instalação pode ser vista no seu navegador."
    
    # 4. Para o processo do backend
    Stop-Backend-For-Logs
    
    # Perguntar se quer abrir a pasta
    $open = Read-Host "Deseja abrir a pasta do projeto no Windows Explorer? (S/N)"
    if ($open -eq 'S' -or $open -eq 's') {
        Invoke-Item $ProjectDir
    }
}

# --- Execução ---
# Tenta ler o caminho do projeto salvo pelo Inno Setup
$projectPathFile = Join-Path $PSScriptRoot "project-path.txt"
$savedProjectDir = ""
if (Test-Path $projectPathFile) {
    $savedProjectDir = Get-Content $projectPathFile -Raw
}

# Se o parâmetro não foi passado, usa o salvo.
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = $savedProjectDir
}

Main -ProjectDir $ProjectDir