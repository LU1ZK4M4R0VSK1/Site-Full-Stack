# Continuação do script setup.ps1...

# Função para criar arquivos de suporte
function Create-Support-Files {
    param([string]$Path)
    
    Write-Host "`nCriando arquivos de suporte..." -ForegroundColor Cyan
    
    # .gitignore
    $gitignore = @"
# Dependencies
node_modules/
.vscode/
.idea/
.vs/
.vscode/settings.json
.vscode/tasks.json
.vscode/launch.json
.vscode/extensions.json

# Build outputs
dist/
build/
bin/
obj/
out/
Release/
Debug/

# Database
*.db
*.db-journal
*.sqlite*
app.db
database/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)
.grunt

# Bower dependency directory (https://bower.io/)
bower_components/

# node-waf configuration
.lock-wscript

# Compiled binary addons (https://nodejs.org/api/addons.html)
build/Release/

# Dependency directories
jspm_packages/

# TypeScript cache
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
# Comment in the public line in if your project uses Gatsby and not Next.js
# https://nextjs.org/blog/next-9-1#public-directory-support
# public

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless/

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# yarn v2
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz
.pnp.*

# JetBrains Rider
*.sln.iml

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Windows shortcuts
*.lnk

# Temporary files
*.tmp
*.temp
"@
    $gitignore | Out-File "$Path/.gitignore" -Encoding UTF8
    Write-Host "  .gitignore criado" -ForegroundColor Gray
    
    # README.md
    $readme = @"
# 🚀 Full Stack Project

Este projeto foi gerado automaticamente pelo **Full Stack Project Installer**.

## 📋 Tecnologias

### Frontend
- **Vite** - Build tool moderno e rápido
- **React 18** - Biblioteca para interfaces
- **TypeScript** - Tipagem estática
- **Axios** - Cliente HTTP

### Backend
- **.NET 8** - Framework para APIs
- **C#** - Linguagem de programação
- **Entity Framework Core** - ORM
- **SQLite** - Banco de dados (para desenvolvimento)

### Ferramentas
- **Swagger** - Documentação da API
- **ESLint** - Linter para JavaScript/TypeScript
- **CORS** configurado

## 🏗️ Estrutura do Projeto

\`\`\`
$Path
├── frontend/                 # Aplicação React
│   ├── public/              # Arquivos estáticos
│   └── src/                 # Código fonte
│       ├── assets/          # Imagens, fontes, etc.
│       ├── components/      # Componentes React
│       ├── pages/           # Páginas/rotas
│       ├── services/        # APIs e serviços
│       ├── types/           # Tipos TypeScript
│       ├── utils/           # Funções utilitárias
│       └── hooks/           # Custom hooks
├── backend/                 # API .NET
│   ├── Controllers/         # Controladores API
│   ├── Data/               # Contexto do banco
│   ├── DTOs/               # Data Transfer Objects
│   ├── Models/             # Modelos de dados
│   ├── Repositories/       # Acesso a dados
│   ├── Services/           # Lógica de negócio
│   └── Middlewares/        # Middlewares HTTP
├── database/               # Scripts SQL
├── docs/                   # Documentação
├── tests/                  # Testes
├── scripts/                # Scripts de automação
└── README.md              # Este arquivo
\`\`\`

## 🚀 Como Executar

### 1. Instalar Dependências

#### Frontend:
\`\`\`bash
cd frontend
npm install
\`\`\`

#### Backend:
\`\`\`bash
cd backend
dotnet restore
\`\`\`

### 2. Iniciar Servidores

#### Opção A: Iniciar separadamente

**Backend (Terminal 1):**
\`\`\`bash
cd backend
dotnet run
\`\`\`
API disponível em: http://localhost:5000
Swagger em: http://localhost:5000/swagger

**Frontend (Terminal 2):**
\`\`\`bash
cd frontend
npm run dev
\`\`\`
App disponível em: http://localhost:5173

#### Opção B: Usar os scripts

**Windows:**
\`\`\`bash
.\start.bat
\`\`\`
Ou:
\`\`\`powershell
.\start.ps1
\`\`\`

## 🔧 Configuração

### Variáveis de Ambiente

**Frontend (.env):**
\`\`\`env
VITE_API_URL=http://localhost:5000
VITE_APP_NAME=Full Stack Project
\`\`\`

**Backend (appsettings.json):**
- Conexão com SQLite: \`Data Source=app.db\`
- Configurações de JWT
- URLs do frontend para CORS

### Banco de Dados

O projeto usa SQLite por padrão. O arquivo \`app.db\` será criado automaticamente na primeira execução.

Para migrar para MySQL no futuro:

1. Instalar pacote MySQL:
   \`\`\`bash
   dotnet add package Pomelo.EntityFrameworkCore.MySql
   \`\`\`

2. Atualizar connection string:
   \`\`\`json
   "ConnectionStrings": {
     "DefaultConnection": "server=localhost;database=mydb;user=root;password=123456"
   }
   \`\`\`

## 📡 Endpoints da API

### Exemplo
- \`GET /api/example\` - Status da API
- \`GET /api/example/health\` - Health check
- \`POST /api/example/echo\` - Echo endpoint

### Swagger UI
Acesse http://localhost:5000/swagger para documentação interativa.

## 🧪 Testes

### Frontend:
\`\`\`bash
cd frontend
npm test
\`\`\`

### Backend:
\`\`\`bash
cd backend
dotnet test
\`\`\`

## 📦 Build para Produção

### Frontend:
\`\`\`bash
cd frontend
npm run build
\`\`\`
Arquivos gerados em \`frontend/dist/\`

### Backend:
\`\`\`bash
cd backend
dotnet publish -c Release -o ./publish
\`\`\`
Arquivos gerados em \`backend/publish/\`

## 🔍 Debug

### VS Code
Configurações de debug estão incluídas no diretório \`.vscode/\`.

### Visual Studio
Abra \`backend/backend.sln\` para desenvolvimento .NET.

## 🤝 Contribuindo

1. Crie uma branch: \`git checkout -b feature/nova-funcionalidade\`
2. Commit suas mudanças: \`git commit -m 'Adiciona nova funcionalidade'\`
3. Push para a branch: \`git push origin feature/nova-funcionalidade\`
4. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.

## 🆘 Suporte

Problemas ou dúvidas? Consulte:

1. Documentação em \`docs/\`
2. Issues no GitHub
3. Stack Overflow com tag \`[fullstack]\`

---
*Projeto gerado em $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')*
"@
    $readme | Out-File "$Path/README.md" -Encoding UTF8
    Write-Host "  README.md criado" -ForegroundColor Gray
    
    # start.bat
    $startBat = @"
@echo off
chcp 65001 >nul
echo ====================================
echo   🚀 Full Stack Project Launcher
echo ====================================
echo.

:menu
cls
echo Opções:
echo   1. Iniciar Backend (.NET API)
echo   2. Iniciar Frontend (Vite/React)
echo   3. Iniciar Ambos (Recomendado)
echo   4. Instalar Dependências
echo   5. Build para Produção
echo   6. Testar
echo   7. Abrir no VS Code
echo   8. Sair
echo.

set /p choice="Escolha uma opção (1-8): "

if "%choice%"=="1" goto backend
if "%choice%"=="2" goto frontend
if "%choice%"=="3" goto both
if "%choice%"=="4" goto install
if "%choice%"=="5" goto build
if "%choice%"=="6" goto test
if "%choice%"=="7" goto vscode
if "%choice%"=="8" goto end
goto menu

:backend
echo.
echo Iniciando Backend...
cd backend
dotnet run
goto end

:frontend
echo.
echo Iniciando Frontend...
cd frontend
npm run dev
goto end

:both
echo.
echo Iniciando Backend e Frontend...
echo.
echo Abrindo Backend em nova janela...
start "Backend API" cmd /k "cd /d "%cd%\backend" && echo Iniciando Backend... && dotnet run"
timeout /t 5 /nobreak >nul
echo.
echo Abrindo Frontend em nova janela...
start "Frontend App" cmd /k "cd /d "%cd%\frontend" && echo Iniciando Frontend... && npm run dev"
echo.
echo Servidores iniciados!
echo.
echo URLs:
echo   Frontend: http://localhost:5173
echo   Backend API: http://localhost:5000
echo   Swagger: http://localhost:5000/swagger
echo.
pause
goto end

:install
echo.
echo Instalando dependências...
echo.
echo Frontend...
cd frontend
call npm install
echo.
echo Backend...
cd ..\backend
call dotnet restore
echo.
echo Dependências instaladas!
pause
goto menu

:build
echo.
echo Build para produção...
echo.
echo Frontend...
cd frontend
call npm run build
echo.
echo Backend...
cd ..\backend
call dotnet publish -c Release -o ./publish
echo.
echo Build concluído!
echo Frontend: frontend/dist/
echo Backend: backend/publish/
pause
goto menu

:test
echo.
echo Executando testes...
echo.
echo Frontend...
cd frontend
call npm test
echo.
echo Backend...
cd ..\backend
call dotnet test
echo.
echo Testes concluídos!
pause
goto menu

:vscode
echo.
echo Abrindo no VS Code...
code .
goto end

:end
echo.
echo Pressione qualquer tecla para sair...
pause >nul
"@
    $startBat | Out-File "$Path/start.bat" -Encoding ASCII
    Write-Host "  start.bat criado" -ForegroundColor Gray
    
    # start.ps1
    $startPs1 = @"
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  🚀 Full Stack Project Launcher  " -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

function Show-Menu {
    Clear-Host
    Write-Host "Opções:" -ForegroundColor White
    Write-Host "  1. Iniciar Backend (.NET API)" -ForegroundColor Gray
    Write-Host "  2. Iniciar Frontend (Vite/React)" -ForegroundColor Gray
    Write-Host "  3. Iniciar Ambos (Recomendado)" -ForegroundColor Green
    Write-Host "  4. Instalar Dependências" -ForegroundColor Gray
    Write-Host "  5. Build para Produção" -ForegroundColor Gray
    Write-Host "  6. Testar" -ForegroundColor Gray
    Write-Host "  7. Abrir no VS Code" -ForegroundColor Blue
    Write-Host "  8. Sair" -ForegroundColor Red
    Write-Host ""
}

do {
    Show-Menu
    $choice = Read-Host "Escolha uma opção (1-8)"
    
    switch ($choice) {
        "1" {
            Write-Host "`nIniciando Backend..." -ForegroundColor Green
            Set-Location "backend"
            dotnet run
            Set-Location ".."
        }
        "2" {
            Write-Host "`nIniciando Frontend..." -ForegroundColor Green
            Set-Location "frontend"
            npm run dev
            Set-Location ".."
        }
        "3" {
            Write-Host "`nIniciando Backend e Frontend..." -ForegroundColor Green
            Write-Host ""
            Write-Host "Abrindo Backend em nova janela..." -ForegroundColor Yellow
            Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$pwd\backend'; Write-Host 'Iniciando Backend...' -ForegroundColor Green; dotnet run"
            Start-Sleep -Seconds 5
            Write-Host "`nAbrindo Frontend em nova janela..." -ForegroundColor Yellow
            Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$pwd\frontend'; Write-Host 'Iniciando Frontend...' -ForegroundColor Green; npm run dev"
            Write-Host "`nServidores iniciados!" -ForegroundColor Green
            Write-Host ""
            Write-Host "URLs:" -ForegroundColor White
            Write-Host "  Frontend: http://localhost:5173" -ForegroundColor Cyan
            Write-Host "  Backend API: http://localhost:5000" -ForegroundColor Cyan
            Write-Host "  Swagger: http://localhost:5000/swagger" -ForegroundColor Cyan
            Write-Host ""
            Read-Host "Pressione Enter para continuar"
        }
        "4" {
            Write-Host "`nInstalando dependências..." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Frontend..." -ForegroundColor Gray
            Set-Location "frontend"
            npm install
            Write-Host "`nBackend..." -ForegroundColor Gray
            Set-Location "..\backend"
            dotnet restore
            Set-Location ".."
            Write-Host "`nDependências instaladas!" -ForegroundColor Green
            Read-Host "Pressione Enter para continuar"
        }
        "5" {
            Write-Host "`nBuild para produção..." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Frontend..." -ForegroundColor Gray
            Set-Location "frontend"
            npm run build
            Write-Host "`nBackend..." -ForegroundColor Gray
            Set-Location "..\backend"
            dotnet publish -c Release -o ./publish
            Set-Location ".."
            Write-Host "`nBuild concluído!" -ForegroundColor Green
            Write-Host "Frontend: frontend/dist/" -ForegroundColor Cyan
            Write-Host "Backend: backend/publish/" -ForegroundColor Cyan
            Read-Host "Pressione Enter para continuar"
        }
        "6" {
            Write-Host "`nExecutando testes..." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Frontend..." -ForegroundColor Gray
            Set-Location "frontend"
            npm test
            Write-Host "`nBackend..." -ForegroundColor Gray
            Set-Location "..\backend"
            dotnet test
            Set-Location ".."
            Write-Host "`nTestes concluídos!" -ForegroundColor Green
            Read-Host "Pressione Enter para continuar"
        }
        "7" {
            Write-Host "`nAbrindo no VS Code..." -ForegroundColor Blue
            if (Get-Command code -ErrorAction SilentlyContinue) {
                code .
            } else {
                Write-Host "VS Code não encontrado. Por favor, instale-o ou abra manualmente." -ForegroundColor Red
            }
            Read-Host "Pressione Enter para continuar"
        }
        "8" {
            Write-Host "`nSaindo..." -ForegroundColor Red
            return
        }
        default {
            Write-Host "Opção inválida. Tente novamente." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($true)
"@
    $startPs1 | Out-File "$Path/start.ps1" -Encoding UTF8
    Write-Host "  start.ps1 criado" -ForegroundColor Gray
    
    # Criar arquivo de configuração VS Code
    $vscodeSettings = @"
{
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": "explicit"
    },
    "files.exclude": {
        "**/.git": true,
        "**/.svn": true,
        "**/.hg": true,
        "**/CVS": true,
        "**/.DS_Store": true,
        "**/Thumbs.db": true,
        "**/node_modules": true,
        "**/bin": true,
        "**/obj": true,
        "**/.vs": true
    },
    "typescript.preferences.importModuleSpecifier": "relative",
    "javascript.preferences.importModuleSpecifier": "relative",
    "[typescript]": {
        "editor.defaultFormatter": "vscode.typescript-language-features"
    },
    "[typescriptreact]": {
        "editor.defaultFormatter": "vscode.typescript-language-features"
    },
    "[json]": {
        "editor.defaultFormatter": "vscode.json-language-features"
    },
    "[csharp]": {
        "editor.defaultFormatter": "ms-dotnettools.csharp"
    }
}
"@
    
    New-Item -ItemType Directory -Path "$Path/.vscode" -Force | Out-Null
    $vscodeSettings | Out-File "$Path/.vscode/settings.json" -Encoding UTF8
    Write-Host "  Configurações VS Code criadas" -ForegroundColor Gray
    
    # launch.json para debug
    $launchJson = @"
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": ".NET Core Launch (backend)",
            "type": "coreclr",
            "request": "launch",
            "preLaunchTask": "build",
            "program": "\${workspaceFolder}/backend/bin/Debug/net8.0/backend.dll",
            "args": [],
            "cwd": "\${workspaceFolder}/backend",
            "console": "internalConsole",
            "stopAtEntry": false
        },
        {
            "name": "Launch Chrome",
            "request": "launch",
            "type": "chrome",
            "url": "http://localhost:5173",
            "webRoot": "\${workspaceFolder}/frontend"
        }
    ],
    "compounds": [
        {
            "name": "Full Stack Debug",
            "configurations": [".NET Core Launch (backend)", "Launch Chrome"]
        }
    ]
}
"@
    $launchJson | Out-File "$Path/.vscode/launch.json" -Encoding UTF8
    Write-Host "  Configurações de debug criadas" -ForegroundColor Gray
    
    Write-Host "`nArquivos de suporte criados com sucesso!" -ForegroundColor Green
}

# Função para instalar dependências
function Install-Dependencies {
    param([string]$Path)
    
    Write-Host "`nInstalando dependências..." -ForegroundColor Cyan
    
    try {
        # Frontend
        Write-Host "  Frontend..." -ForegroundColor Gray
        Set-Location "$Path/frontend"
        npm install 2>&1 | Out-Null
        
        # Backend
        Write-Host "  Backend..." -ForegroundColor Gray
        Set-Location "$Path/backend"
        dotnet restore 2>&1 | Out-Null
        
        Write-Host "  Dependências instaladas com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "  Erro ao instalar dependências: $_" -ForegroundColor Red
    }
}

# Função principal
function Main {
    param([string]$ProjectDir)
    
    # Verificar se o diretório existe
    if (-not (Test-Path $ProjectDir)) {
        New-Item -ItemType Directory -Path $ProjectDir -Force | Out-Null
    }
    
    Write-Host "Iniciando criação do projeto Full Stack..." -ForegroundColor Yellow
    
    # Criar estrutura
    $projectPath = Create-FullStack-Project -Path $ProjectDir
    
    # Criar arquivos frontend
    Create-Frontend-Files -Path $projectPath
    
    # Criar arquivos backend
    Create-Backend-Files -Path $projectPath
    
    # Criar arquivos de suporte
    Create-Support-Files -Path $projectPath
    
    # Instalar dependências
    Install-Dependencies -Path $projectPath
    
    Write-Host "`n" + ("=" * 50) -ForegroundColor Cyan
    Write-Host "✅ PROJETO CRIADO COM SUCESSO!" -ForegroundColor Green
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📁 Local do projeto: $projectPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🚀 Para iniciar o projeto:" -ForegroundColor White
    Write-Host "   1. Navegue até a pasta do projeto" -ForegroundColor Gray
    Write-Host "   2. Execute um dos scripts:" -ForegroundColor Gray
    Write-Host "      • Windows: execute 'start.bat'" -ForegroundColor Cyan
    Write-Host "      • PowerShell: execute '.\start.ps1'" -ForegroundColor Cyan
    Write-Host "   3. Escolha a opção 3 (Iniciar Ambos)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🌐 URLs do projeto:" -ForegroundColor White
    Write-Host "   • Frontend: http://localhost:5173" -ForegroundColor Cyan
    Write-Host "   • Backend API: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "   • Swagger: http://localhost:5000/swagger" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📚 Documentação completa em README.md" -ForegroundColor Gray
    Write-Host ""
    
    # Abrir pasta no explorador
    $openExplorer = Read-Host "Deseja abrir a pasta do projeto agora? (S/N)"
    if ($openExplorer -eq "S" -or $openExplorer -eq "s") {
        Invoke-Item $projectPath
    }
    
    Write-Host "`nProcesso concluído! 🎉" -ForegroundColor Green
}

# Executar função principal
if ($projectDir) {
    Main -ProjectDir $projectDir
} else {
    Write-Host "Erro: Diretório do projeto não especificado." -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
}