@echo off
REM BetBot - Script de Inicializacao para Windows

echo ============================================================
echo Iniciando BetBot...
echo ============================================================
echo.

if not exist venv (
    echo Erro: Ambiente virtual nao encontrado.
    echo Execute primeiro: setup.bat
    pause
    exit /b 1
)

if not exist env.py (
    echo Erro: Arquivo env.py nao encontrado.
    echo Execute primeiro: setup.bat
    pause
    exit /b 1
)

call venv\Scripts\activate.bat
python main.py

pause
