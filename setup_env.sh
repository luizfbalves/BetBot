#!/bin/bash

# BetBot - Setup Rápido do env.py
# Use este script se setup.sh teve problemas com a criação de env.py

echo "╔════════════════════════════════════════════════════════════╗"
echo "║        🔧 BetBot - Configurar MongoDB (env.py)           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ -f "env.py" ]; then
    echo "✓ env.py já existe!"
    read -p "Deseja sobrescrever? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Cancelado"
        exit 0
    fi
fi

echo ""
echo "📝 Você precisa de uma connection string do MongoDB Atlas:"
echo ""
echo "   Passos para obter:"
echo ""
echo "   1. Acesse: https://www.mongodb.com/cloud/atlas"
echo "   2. Faça login (ou crie conta)"
echo "   3. Vá em: Deployments > Clusters"
echo "   4. Clique no seu cluster > Connect"
echo "   5. Escolha: Drivers > Python"
echo "   6. COPIE a string (começa com 'mongodb+srv://')"
echo ""

while true; do
    read -p "Cole aqui sua connection string: " MONGO_STRING
    
    # Se o input for vazio ou "skip", trat como skip
    if [ -z "$MONGO_STRING" ] || [ "$MONGO_STRING" = "skip" ] || [ "$MONGO_STRING" = "SKIP" ]; then
        echo "⚠️  Pulando configuração de MongoDB"
        exit 0
    fi
    
    if [[ ! "$MONGO_STRING" == mongodb+srv://* ]]; then
        echo "❌ String deve começar com 'mongodb+srv://'"
        continue
    fi
    
    if [[ "$MONGO_STRING" == *"<password>"* ]] || [[ "$MONGO_STRING" == *"<username>"* ]]; then
        echo "❌ Você ainda tem placeholders (<username> ou <password>)"
        echo "   Substitua-os com suas credenciais reais"
        continue
    fi
    
    # Tudo OK, criar arquivo
    cat > env.py << EOF
# MongoDB Atlas Connection String
# Gerado por: setup_env.sh
autenticacao = "$MONGO_STRING"
EOF
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ env.py criado com sucesso!"
        echo ""
        echo "Próximos passos:"
        echo "  1. Execute: bash start.sh"
        echo "  2. Ou: python3 main.py"
        echo ""
        exit 0
    else
        echo "❌ Erro ao criar env.py"
        exit 1
    fi
done
