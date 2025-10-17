import eel, time, threading
from datetime import datetime
from src.database import MongoDB
from src.bot import BetBot
from typing import Dict, Any, Union

@eel.expose
def ping():
    print("🏓 Ping recebido do JavaScript!")
    return "pong"

@eel.expose
def handle_register(account: dict):
    username = account.get("username", "").strip()
    password = account.get("password", "")
    confirm_password = account.get("confirm_password", "")
    
    print(f"🔍 handle_register chamado com: {username}")
    
    # Validações
    if not username or not password:
        print("❌ Dados incompletos")
        return {"success": False, "message": "Usuário e senha são obrigatórios"}
    
    if password != confirm_password:
        print("❌ Senhas não coincidem")
        return {"success": False, "message": "As senhas não coincidem"}
    
    if len(password) < 6:
        print("❌ Senha muito curta")
        return {"success": False, "message": "A senha deve ter pelo menos 6 caracteres"}
    
    # Verificar se usuário já existe
    existing_user = MongoDB.Users_collection.find_one({"username": username})
    if existing_user:
        print(f"❌ Usuário {username} já existe")
        return {"success": False, "message": "Este usuário já existe"}
    
    # Criar usuário
    try:
        MongoDB.cadastrar(username, password)
        print(f"✅ Usuário {username} criado com sucesso")
        return {"success": True, "message": "Conta criada com sucesso! Faça login."}
    except Exception as e:
        print(f"❌ Erro ao criar usuário: {e}")
        return {"success": False, "message": "Erro interno do servidor"}

@eel.expose
def handle_login(account:dict):
    print(f"🔍 handle_login chamado com: {account}")
    conta = MongoDB.login(
        account["username"], account["password"])
    print(f"📊 Resultado do MongoDB.login: {conta}")
    if conta and isinstance(conta, dict):
        conta['password'] = account["password"]
        print(f"✅ Login bem-sucedido para: {conta['username']}")
        return conta
    print("❌ Login falhou - usuário/senha incorretos")
    return False

@eel.expose
def operate(account:dict):
    bot = BetBot(account)
    threading.Thread(target=bot.start,
        daemon = True).start()

eel.init('src/web')
eel.start('index.html')