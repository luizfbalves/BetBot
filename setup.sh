#!/bin/bash

# BetBot - Setup Automático
# Este script configura tudo que você precisa para rodar o BetBot

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           🎯 BetBot - Setup Automático v1.0               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir títulos
print_title() {
    echo -e "\n${BLUE}▸ $1${NC}"
}

# Função para imprimir sucesso
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Função para imprimir erro
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Função para imprimir aviso
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Função para tratar erros
handle_error() {
    print_error "$1"
    exit 1
}

# 1. Verificar Python
print_title "Verificando Python 3.9+"
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null || echo "unknown")
    print_success "Python $PYTHON_VERSION encontrado"
else
    handle_error "Python 3.9+ não encontrado. Por favor, instale Python primeiro."
fi

# 2. Criar e ativar venv
print_title "Configurando ambiente virtual"
if [ ! -d "venv" ]; then
    python3 -m venv venv || handle_error "Falha ao criar ambiente virtual"
    print_success "Ambiente virtual criado"
else
    print_success "Ambiente virtual já existe"
fi

# Ativar venv
source venv/bin/activate || handle_error "Falha ao ativar venv"
print_success "Ambiente virtual ativado"

# 3. Instalar dependências
print_title "Instalando dependências"
pip install --upgrade pip 2>&1 | grep -E "(Successfully|already)" || true
if pip install -r requirements.txt 2>&1 | tail -5; then
    print_success "Dependências instaladas"
else
    print_error "Aviso: Possível erro ao instalar algumas dependências"
    print_warning "Tentando continuar mesmo assim..."
fi

# 4. Verificar/criar env.py
print_title "Configurando arquivo env.py"
if [ ! -f "env.py" ]; then
    echo ""
    echo "📝 Você precisa configurar o MongoDB Atlas:"
    echo ""
    echo "   Passos:"
    echo "   1. Acesse: https://www.mongodb.com/cloud/atlas"
    echo "   2. Crie uma conta (grátis)"
    echo "   3. Crie um Cluster"
    echo "   4. Crie Database 'betbot' com Collection 'users'"
    echo "   5. Clique: Database > Connect > Python"
    echo "   6. Copie a connection string (mongodb+srv://...)"
    echo ""
    
    # Loop para validar input
    while true; do
        read -p "💾 Cole sua connection string (ou 'skip' para pular): " MONGO_STRING
        
        if [ "$MONGO_STRING" = "skip" ] || [ "$MONGO_STRING" = "SKIP" ]; then
            print_warning "env.py não foi criado. Você criará manualmente depois."
            break
        elif [[ "$MONGO_STRING" == mongodb+srv://* ]]; then
            if cat > env.py << EOF
# MongoDB Atlas Connection String
autenticacao = "$MONGO_STRING"
EOF
            then
                print_success "env.py criado com sucesso"
            else
                print_error "Erro ao criar env.py"
            fi
            break
        else
            print_error "String inválida (deve começar com 'mongodb+srv://' ou digite 'skip')"
        fi
    done
else
    print_success "env.py já configurado"
fi

# 5. Registrar novo usuário (opcional)
print_title "Criação de usuário (opcional)"
read -p "Deseja registrar um novo usuário Bet365? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    if [ ! -f "env.py" ]; then
        print_error "env.py não existe. Crie primeiro e tente depois."
    else
        read -p "Username (seu login Bet365): " BET_USERNAME
        read -sp "Senha (sua senha Bet365): " BET_PASSWORD
        echo ""
        
        python3 << PYTHON_SCRIPT 2>&1 | head -20
from src.database import MongoDB
try:
    MongoDB.cadastrar("$BET_USERNAME", "$BET_PASSWORD")
    print("✓ Usuário registrado com sucesso!")
except Exception as e:
    print(f"✗ Erro ao registrar: {e}")
    print(f"   Verifique se env.py está correto")
PYTHON_SCRIPT
    fi
else
    print_warning "Pulando registro de usuário (pode fazer depois na interface)"
fi

# 6. Verificar Chrome/Firefox
print_title "Verificando navegadores"
BROWSER_FOUND=false
if command -v google-chrome &> /dev/null || command -v chromium &> /dev/null; then
    print_success "Chrome/Chromium encontrado (recomendado)"
    BROWSER_FOUND=true
elif command -v firefox &> /dev/null; then
    print_warning "Apenas Firefox encontrado (Chrome é recomendado)"
    BROWSER_FOUND=true
fi

if [ "$BROWSER_FOUND" = false ]; then
    print_warning "Nenhum navegador Chrome/Firefox encontrado"
    echo "   ℹ️  Instale em: https://www.google.com/chrome/"
fi

# 7. Resumo final
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
if [ -f "env.py" ]; then
    echo "║              ✓ Setup Completo!                          ║"
else
    echo "║         ⚠️  Setup Parcial (sem env.py)                  ║"
fi
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ -f "env.py" ]; then
    echo "✅ Tudo pronto! Inicie o BetBot com:"
    echo ""
    echo -e "   ${BLUE}bash start.sh${NC}"
    echo ""
    echo "   Ou execute diretamente:"
    echo -e "   ${BLUE}python3 main.py${NC}"
else
    echo "⚠️  Você precisa criar env.py primeiro:"
    echo ""
    echo "   Opção 1 - Rode setup.sh novamente e insira a connection string"
    echo "   Opção 2 - Crie env.py manualmente com:"
    echo ""
    echo "   autenticacao = \"mongodb+srv://USER:PASS@cluster.mongodb.net/betbot?retryWrites=true&w=majority\""
fi
echo ""
