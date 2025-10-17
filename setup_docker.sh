#!/bin/bash

# BetBot - Setup MongoDB Docker
# Extrai connection string de container MongoDB e cria env.py

echo "╔════════════════════════════════════════════════════════════╗"
echo "║      🐳 BetBot - Configurar MongoDB Docker               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# 1. Verificar se Docker está instalado
print_info "Procurando por MongoDB Docker..."
if ! command -v docker &> /dev/null; then
    print_error "Docker não encontrado. Instale Docker primeiro."
    exit 1
fi

# 2. Procurar container MongoDB
MONGO_CONTAINER=$(docker ps --filter "ancestor=mongo" --format "{{.Names}}" | head -1)

if [ -z "$MONGO_CONTAINER" ]; then
    print_warning "Nenhum container MongoDB em execução encontrado"
    echo ""
    echo "Opções:"
    echo "  1. Inicie seu container MongoDB:"
    echo "     docker run -d --name mongodb -p 27017:27017 mongo"
    echo ""
    echo "  2. Ou configure manualmente:"
    echo "     bash setup_env.sh"
    echo ""
    exit 1
fi

print_success "Container MongoDB encontrado: $MONGO_CONTAINER"

# 3. Obter IP do container
MONGO_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$MONGO_CONTAINER")

if [ -z "$MONGO_IP" ]; then
    print_error "Não consegui obter o IP do container"
    exit 1
fi

print_success "IP do container: $MONGO_IP"

# 4. Construir connection string
MONGO_STRING="mongodb://$MONGO_IP:27017/betbot"

echo ""
print_info "Connection string detectada:"
echo "   $MONGO_STRING"
echo ""

# 5. Testar conexão
print_info "Testando conexão com MongoDB..."
if docker exec "$MONGO_CONTAINER" mongosh --eval "db.adminCommand('ping')" &> /dev/null || \
   docker exec "$MONGO_CONTAINER" mongo --eval "db.adminCommand('ping')" &> /dev/null; then
    print_success "Conexão com MongoDB OK"
else
    print_warning "Não consegui testar a conexão (MongoDB pode estar iniciando)"
fi

# 6. Criar env.py
echo ""
print_info "Criando env.py..."

if cat > env.py << EOF
# MongoDB Docker Connection String
# Gerado por: setup_docker.sh
autenticacao = "$MONGO_STRING"

# ℹ️  Nota:
# - Este é um container MongoDB local
# - Database "betbot" será criada automaticamente
# - Collection "users" será criada no primeiro uso
EOF
then
    print_success "env.py criado com sucesso"
    echo ""
    print_success "Arquivo: env.py"
    cat env.py
else
    print_error "Erro ao criar env.py"
    exit 1
fi

# 7. Criar database e collection (opcional)
echo ""
read -p "Deseja criar database 'betbot' e collection 'users' agora? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    print_info "Criando database e collection..."
    {
        docker exec "$MONGO_CONTAINER" mongosh --eval "use betbot; db.users.insertOne({_id: 'init', created: new Date()}); db.users.deleteOne({_id: 'init'})" || \
        docker exec "$MONGO_CONTAINER" mongo --eval "use betbot; db.users.insertOne({_id: 'init', created: new Date()}); db.users.deleteOne({_id: 'init'})"
    } &> /dev/null
    print_success "Database 'betbot' e collection 'users' criadas"
fi

# 8. Próximos passos
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  ✓ Pronto!                                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
print_success "env.py está configurado para MongoDB Docker"
echo ""
print_info "Próximos passos:"
echo "   1. bash setup.sh      (instalar dependências)"
echo "   2. bash start.sh      (iniciar BetBot)"
echo ""
print_warning "Certifique-se que o container MongoDB está em execução:"
echo "   docker ps | grep mongo"
echo ""
