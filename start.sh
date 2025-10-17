#!/bin/bash

# BetBot - Script de Inicialização
# Use este script para iniciar o BetBot facilmente

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              🚀 Iniciando BetBot...                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se venv existe
if [ ! -d "venv" ]; then
    echo "⚠️  Ambiente virtual não encontrado."
    echo "Execute primeiro: bash setup.sh"
    exit 1
fi

# Ativar venv
source venv/bin/activate

# Verificar se env.py existe
if [ ! -f "env.py" ]; then
    echo "⚠️  Arquivo env.py não encontrado."
    echo "Execute primeiro: bash setup.sh"
    exit 1
fi

# Iniciar BetBot
echo "✓ Iniciando aplicação..."
echo ""
python3 main.py
