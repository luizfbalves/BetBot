# 🚀 Setup do BetBot - Instruções Definitivas

## ⚡ Forma Rápida (3 passos)

### Passo 1: Executar Setup

```bash
bash setup.sh
```

### Passo 2: Configurar MongoDB (se não fez no step 1)

```bash
bash setup_env.sh
```

E cole sua connection string do MongoDB Atlas

### Passo 3: Iniciar

```bash
bash start.sh
```

---

## 📋 Obter Connection String MongoDB (5 min)

### Pré-requisito

- Conta no MongoDB (grátis em https://www.mongodb.com/cloud/atlas)

### Passos

1. Acesse: **https://www.mongodb.com/cloud/atlas**
2. Faça login
3. Vá em: **Deployments > Clusters**
4. Clique no seu cluster > **Connect**
5. Escolha: **Drivers > Python**
6. **COPIE** a string (começa com `mongodb+srv://`)

### Exemplo

```
mongodb+srv://username:password@cluster0.abc123.mongodb.net/betbot?retryWrites=true&w=majority
```

### Importante

- Substitua `username` e `password` com suas credenciais
- NÃO inclua `<` e `>`
- A database já deve ser `betbot` na string

---

## 🔧 Se o Setup der Erro

### Erro: "env.py não encontrado"

```bash
# Use o script dedicado:
bash setup_env.sh

# Ou crie manualmente:
cat > env.py << 'EOF'
autenticacao = "cole_aqui_sua_connection_string"
EOF
```

### Erro: "Dependências não instaladas"

```bash
# Ativar venv e instalar manualmente:
source venv/bin/activate
pip install -r requirements.txt
```

### Erro: "Python não encontrado"

```bash
python3 --version
# Deve ser 3.9+. Se não, instale:
# https://www.python.org/downloads/
```

### Erro: "MongoDB connection refused"

- Verifique a connection string em `env.py`
- Certifique-se que o IP está whitelisted no MongoDB Atlas
- Verifique sua conexão com internet

---

## 📁 Arquivos Criados

```
BetBot/
├── venv/                    ← Ambiente virtual (criado pelo setup)
├── env.py                   ← Configuração MongoDB (CRIE VOCÊ)
├── env_example.py           ← Exemplo de env.py
├── setup.sh                 ← Setup completo
├── setup_env.sh             ← Setup apenas env.py
├── start.sh                 ← Inicia o BetBot
├── main.py                  ← Entrada principal
├── requirements.txt         ← Dependências
└── src/                     ← Código fonte
```

---

## ✅ Checklist

- [ ] Python 3.9+ instalado
- [ ] MongoDB Atlas conta criada
- [ ] Cluster criado no MongoDB
- [ ] Database `betbot` com Collection `users`
- [ ] Connection string obtida
- [ ] `env.py` criado
- [ ] `bash setup.sh` executado sem erros
- [ ] `bash start.sh` iniciando o BetBot
- [ ] Interface web abrindo em `localhost:8000`

---

## 🎮 Primeiros Passos na Interface

1. **Login**: Use suas credenciais Bet365
2. **Config**: Configure limites e filtros
3. **Start**: Clique para iniciar automação
4. **Monitor**: Acompanhe ganhos/perdas em tempo real

---

## 🆘 Suporte

Se ainda assim tiver problemas:

1. Leia: `HOW_TO_RUN.md`
2. Leia: `QUICKSTART.md`
3. Verifique: `.github/copilot-instructions.md` (info técnica)
4. Abra uma issue no GitHub

---

**Pronto? Comece agora:**

```bash
bash setup.sh && bash setup_env.sh && bash start.sh
```
