@echo off
echo Construindo Full Stack Project Installer...
echo.

REM Verificar se o Chocolatey está instalado
WHERE choco >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo "Chocolatey não encontrado. Por favor, instale-o: https://chocolatey.org/install"
    pause
    exit /b 1
)

REM Instalar/Atualizar o Inno Setup
echo "Verificando Inno Setup via Chocolatey..."
choco install innosetup -y --no-progress

REM Compilar o instalador
echo Compilando com Inno Setup...
iscc setup.iss

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ INSTALADOR CRIADO COM SUCESSO!
    echo.
    echo Arquivo gerado: output\FullStackProjectSetup.exe
    echo.
    echo Para testar, execute o arquivo acima.
) else (
    echo.
    echo ❌ ERRO durante a compilação.
)

echo.
pause