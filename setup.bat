@echo off
REM BetBot - Setup Automático para Windows

setlocal enabledelayedexpansion

echo.
echo ============================================================
echo.
echo   Game BetBot - Setup Automatico v1.0
echo.
echo ============================================================
echo.

REM Verificar Python
echo Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo Erro: Python nao encontrado. Instale Python 3.9+
    pause
    exit /b 1
)
echo [OK] Python encontrado

REM Criar venv
if not exist venv (
    echo Criando ambiente virtual...
    python -m venv venv
    if errorlevel 1 (
        echo Erro ao criar venv
        pause
        exit /b 1
    )
    echo [OK] venv criado
) else (
    echo [OK] venv ja existe
)

REM Ativar venv
echo Ativando venv...
call venv\Scripts\activate.bat

REM Instalar dependencias
echo Instalando dependencias...
pip install --upgrade pip >nul 2>&1
pip install -r requirements.txt >nul 2>&1
if errorlevel 1 (
    echo Erro ao instalar dependencias
    pause
    exit /b 1
)
echo [OK] Dependencias instaladas

REM Verificar env.py
if not exist env.py (
    echo.
    echo Configure MongoDB Atlas:
    echo   1. Acesse: https://www.mongodb.com/cloud/atlas
    echo   2. Crie uma conta e um Cluster
    echo   3. Crie Database 'betbot' com Collection 'users'
    echo   4. Copie a connection string (Database Connect Python)
    echo.
    set /p MONGO_STRING="Cole sua connection string: "
    
    (
        echo # MongoDB Atlas Connection String
        echo autenticacao = "!MONGO_STRING!"
    ) > env.py
    
    echo [OK] env.py criado
) else (
    echo [OK] env.py ja existe
)

echo.
echo ============================================================
echo [OK] Setup Completo!
echo ============================================================
echo.
echo Para iniciar o BetBot:
echo   python main.py
echo.
echo Ou use: start.bat
echo.
pause
