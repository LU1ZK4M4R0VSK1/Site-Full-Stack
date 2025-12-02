# Script de configuração do Full Stack Project

# Parâmetros
param (
    [string]$ProjectDir
)

# --- Funções ---

# Função para verificar se um comando existe
function Test-CommandExists {
    param([string]$command)
    return (Get-Command $command -ErrorAction SilentlyContinue)
}

# Função para criar o projeto backend
function Create-Backend-Project {
    param([string]$Path)
    
    Write-Host "`n✨ Criando projeto Backend (.NET)..." -ForegroundColor Cyan
    
    if (-not (Test-CommandExists "dotnet")) {
        Write-Host "❌ ERRO: .NET SDK não encontrado. Instale-o para continuar." -ForegroundColor Red
        exit 1
    }
    
    # Criar o projeto usando 'dotnet new'
    try {
        dotnet new webapi -n "backend" -o "$Path\backend" --no-https --force | Out-Null
        Write-Host "  ✅ Projeto .NET criado com 'dotnet new'" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ Falha ao executar 'dotnet new'. Detalhes: $_" -ForegroundColor Red
        exit 1
    }

    # Copiar templates customizados
    Write-Host "  - Copiando arquivos de template do backend..."
    $templatePath = Join-Path $PSScriptRoot "templates/backend"
    Copy-Item -Path "$templatePath/*" -Destination "$Path\backend" -Recurse -Force
    
    # Renomear arquivos .txt para seus nomes originais
    Get-ChildItem -Path "$Path\backend" -Recurse -Filter *.txt | ForEach-Object {
        $newName = $_.FullName.Replace(".txt", "")
        Rename-Item -Path $_.FullName -NewName $newName -Force
    }

    Write-Host "  ✅ Arquivos do Backend configurados." -ForegroundColor Green
}

# Função para criar o projeto frontend
function Create-Frontend-Project {
    param([string]$Path)
    
    Write-Host "`n✨ Criando projeto Frontend (Vite/React)..." -ForegroundColor Cyan
    
    if (-not (Test-CommandExists "npm")) {
        Write-Host "❌ ERRO: Node.js/npm não encontrado. Instale-o para continuar." -ForegroundColor Red
        exit 1
    }
    
    # Criar o projeto usando 'npm create vite'
    try {
        npm create vite@latest "$Path\frontend" -- --template react-ts | Out-Null
        Write-Host "  ✅ Projeto Vite/React criado com 'npm create vite'" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ Falha ao executar 'npm create vite'. Detalhes: $_" -ForegroundColor Red
        exit 1
    }
    
    # Copiar templates customizados
    Write-Host "  - Copiando arquivos de template do frontend..."
    $templatePath = Join-Path $PSScriptRoot "templates/frontend"
    Copy-Item -Path "$templatePath/*" -Destination "$Path\frontend" -Recurse -Force

    # Renomear arquivos .txt para seus nomes originais
    Get-ChildItem -Path "$Path\frontend" -Recurse -Filter *.txt | ForEach-Object {
        $newName = $_.FullName.Replace(".txt", "")
        Rename-Item -Path $_.FullName -NewName $newName -Force
    }

    Write-Host "  ✅ Arquivos do Frontend configurados." -ForegroundColor Green
}

# Função para criar arquivos de suporte
function Create-Support-Files {
    param([string]$Path)
    
    Write-Host "`n✨ Criando arquivos de suporte..." -ForegroundColor Cyan
    
    # Os arquivos de suporte (README, start.bat, etc.) agora estão no setup.ps1 original.
    # Vamos recriá-los aqui de forma simplificada.
    
    # .gitignore (simplificado, pode ser movido para templates também)
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
    Write-Host "  - .gitignore criado."
    
    # start.ps1 (simplificado)
    @"
Write-Host "🚀 Full Stack Project Launcher"
# Adicionar lógica de menu aqui se desejar
# ...
"@ | Out-File -FilePath "$Path/start.ps1" -Encoding utf8
    Write-Host "  - start.ps1 criado."

    # README.md
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
    Write-Host "  - README.md criado."
    
    Write-Host "  ✅ Arquivos de suporte criados." -ForegroundColor Green
}

# Função para instalar dependências
function Install-Dependencies {
    param([string]$Path)
    
    Write-Host "`n⚙️ Instalando dependências..." -ForegroundColor Cyan
    
    # Backend
    try {
        Write-Host "  - Restaurando pacotes .NET..."
        Set-Location "$Path/backend"
        dotnet restore | Out-Null
        Write-Host "    ✅ Dependências do Backend instaladas." -ForegroundColor Green
    } catch {
        Write-Host "    ❌ Erro ao instalar dependências do Backend. Detalhes: $_" -ForegroundColor Red
    }
    
    # Frontend
    try {
        Write-Host "  - Instalando pacotes npm..."
        Set-Location "$Path/frontend"
        npm install | Out-Null
        Write-Host "    ✅ Dependências do Frontend instaladas." -ForegroundColor Green
    } catch {
        Write-Host "    ❌ Erro ao instalar dependências do Frontend. Detalhes: $_" -ForegroundColor Red
    }
    
    Set-Location $Path
}

# --- Função Principal ---
function Main {
    param([string]$ProjectDir)
    
    if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
        Write-Host "❌ ERRO: O diretório do projeto não foi fornecido." -ForegroundColor Red
        Read-Host "Pressione Enter para sair"
        exit 1
    }
    
    if (-not (Test-Path $ProjectDir)) {
        Write-Host "  - Criando diretório do projeto em: $ProjectDir"
        New-Item -ItemType Directory -Path $ProjectDir -Force | Out-Null
    }
    
    Write-Host "🚀 Iniciando criação do projeto Full Stack em: $ProjectDir" -ForegroundColor Yellow
    Write-Host ("-" * 60)
    
    Create-Backend-Project -Path $ProjectDir
    Create-Frontend-Project -Path $ProjectDir
    Create-Support-Files -Path $ProjectDir
    Install-Dependencies -Path $ProjectDir
    
    Write-Host ("-" * 60)
    Write-Host "✅ PROJETO CRIADO COM SUCESSO!" -ForegroundColor Green
    Write-Host ("-" * 60)
    Write-Host ""
    Write-Host "📁 O projeto está em: $ProjectDir"
    Write-Host "🚀 Para iniciar, navegue até a pasta e siga as instruções do README.md"
    Write-Host ""
    
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