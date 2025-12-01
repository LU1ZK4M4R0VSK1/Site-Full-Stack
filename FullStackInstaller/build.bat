@echo off
echo Construindo Full Stack Project Installer...
echo.

REM Verificar se o Inno Setup está instalado
if not exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" (
    echo ERRO: Inno Setup não encontrado!
    echo.
    echo Baixe e instale o Inno Setup de:
    echo https://jrsoftware.org/isinfo.php
    echo.
    pause
    exit /b 1
)

REM Compilar o instalador
echo Compilando com Inno Setup...
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" setup.iss

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