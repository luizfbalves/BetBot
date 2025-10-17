#!/usr/bin/env python3
"""
BetBot - Setup Automático (Python)
Funciona em Windows, macOS e Linux
"""

import os
import sys
import subprocess
import platform
from pathlib import Path

# Cores (desabilitadas no Windows)
class Colors:
    RED = '\033[91m' if platform.system() != "Windows" else ''
    GREEN = '\033[92m' if platform.system() != "Windows" else ''
    YELLOW = '\033[93m' if platform.system() != "Windows" else ''
    BLUE = '\033[94m' if platform.system() != "Windows" else ''
    END = '\033[0m' if platform.system() != "Windows" else ''

def print_title(msg):
    print(f"\n{Colors.BLUE}▸ {msg}{Colors.END}")

def print_success(msg):
    print(f"{Colors.GREEN}✓ {msg}{Colors.END}")

def print_error(msg):
    print(f"{Colors.RED}✗ {msg}{Colors.END}")

def print_warning(msg):
    print(f"{Colors.YELLOW}⚠ {msg}{Colors.END}")

def run_command(cmd, show_output=False):
    """Executa um comando e retorna o resultado"""
    try:
        if show_output:
            return subprocess.run(cmd, shell=True, check=True).returncode == 0
        else:
            subprocess.run(cmd, shell=True, check=True, 
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            return True
    except subprocess.CalledProcessError:
        return False

def check_python():
    """Verifica versão do Python"""
    print_title("Verificando Python 3.9+")
    version = sys.version_info
    if version.major >= 3 and version.minor >= 9:
        print_success(f"Python {version.major}.{version.minor} encontrado")
        return True
    else:
        print_error(f"Python 3.9+ requerido. Encontrado: {version.major}.{version.minor}")
        return False

def setup_venv():
    """Cria e ativa ambiente virtual"""
    print_title("Configurando ambiente virtual")
    venv_path = Path("venv")
    
    if not venv_path.exists():
        if run_command(f"{sys.executable} -m venv venv"):
            print_success("Ambiente virtual criado")
        else:
            print_error("Falha ao criar ambiente virtual")
            return False
    else:
        print_success("Ambiente virtual já existe")
    
    return True

def install_dependencies():
    """Instala dependências do projeto"""
    print_title("Instalando dependências")
    
    # Determinar pip baseado no OS
    pip_cmd = "pip" if platform.system() == "Windows" else "pip3"
    
    if run_command(f"{pip_cmd} install --upgrade pip"):
        print_success("pip atualizado")
    
    if run_command(f"{pip_cmd} install -r requirements.txt"):
        print_success("Dependências instaladas")
        return True
    else:
        print_error("Falha ao instalar dependências")
        return False

def setup_env_file():
    """Cria arquivo env.py se não existir"""
    print_title("Configurando arquivo env.py")
    
    env_path = Path("env.py")
    if env_path.exists():
        print_success("env.py já configurado")
        return True
    
    print("\n📝 Você precisa configurar o MongoDB Atlas:")
    print("   1. Acesse: https://www.mongodb.com/cloud/atlas")
    print("   2. Crie uma conta e um Cluster")
    print("   3. Crie a Database 'betbot' com Collection 'users'")
    print("   4. Gere a connection string (Database > Connect > Python)\n")
    
    mongo_string = input("Cole sua connection string do MongoDB: ").strip()
    
    if not mongo_string.startswith("mongodb+srv://"):
        print_error("Connection string inválida")
        return False
    
    with open("env.py", "w") as f:
        f.write(f'# MongoDB Atlas Connection String\nautenticacao = "{mongo_string}"\n')
    
    print_success("env.py criado")
    return True

def register_user():
    """Registra novo usuário (opcional)"""
    print_title("Criação de usuário (opcional)")
    
    resp = input("Deseja registrar um novo usuário? (s/n): ").lower()
    if resp != 's':
        print("Pulando registro de usuário")
        return True
    
    username = input("Username (seu login Bet365): ").strip()
    password = input("Senha (sua senha Bet365): ").strip()
    
    if not username or not password:
        print_error("Username ou senha vazio")
        return False
    
    try:
        sys.path.insert(0, str(Path.cwd()))
        from src.database import MongoDB
        MongoDB.cadastrar(username, password)
        print_success("Usuário registrado com sucesso!")
        return True
    except Exception as e:
        print_error(f"Erro ao registrar: {e}")
        return False

def check_browsers():
    """Verifica navegadores disponíveis"""
    print_title("Verificando navegadores")
    
    browsers = {
        "google-chrome": "Chrome",
        "chromium": "Chromium",
        "chrome": "Chrome",
        "firefox": "Firefox",
    }
    
    found = []
    for cmd, name in browsers.items():
        if run_command(f"which {cmd}" if platform.system() != "Windows" else f"where {cmd}"):
            found.append(name)
    
    if found:
        print_success(f"Navegadores encontrados: {', '.join(found)}")
        if "Chrome" not in found and "Chromium" not in found:
            print_warning("Chrome é recomendado para melhor compatibilidade")
    else:
        print_warning("Nenhum navegador Chrome/Chromium encontrado")
        print("   Recomendado: https://www.google.com/chrome/")

def print_completion():
    """Imprime mensagem de conclusão"""
    print("\n" + "═" * 60)
    print(f"{Colors.GREEN}✓ Setup Completo!{Colors.END}")
    print("=" * 60)
    print("\n🚀 Para iniciar o BetBot:")
    
    if platform.system() == "Windows":
        print(f"   {Colors.BLUE}venv\\Scripts\\activate{Colors.END}")
        print(f"   {Colors.BLUE}python main.py{Colors.END}")
    else:
        print(f"   {Colors.BLUE}source venv/bin/activate{Colors.END}")
        print(f"   {Colors.BLUE}python3 main.py{Colors.END}")
    
    print(f"\n💡 Ou execute o script de inicialização:")
    if platform.system() == "Windows":
        print(f"   {Colors.BLUE}start.bat{Colors.END}")
    else:
        print(f"   {Colors.BLUE}bash start.sh{Colors.END}")
    
    print()

def main():
    """Função principal"""
    print("\n╔" + "═" * 58 + "╗")
    print("║" + " " * 58 + "║")
    print("║" + "  🎯 BetBot - Setup Automático v1.0".center(58) + "║")
    print("║" + " " * 58 + "║")
    print("╚" + "═" * 58 + "╝")
    
    # Executar checklist
    if not check_python():
        return False
    
    if not setup_venv():
        return False
    
    if not install_dependencies():
        return False
    
    if not setup_env_file():
        return False
    
    register_user()
    check_browsers()
    print_completion()
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n⚠️  Setup cancelado pelo usuário")
        sys.exit(1)
    except Exception as e:
        print_error(f"Erro inesperado: {e}")
        sys.exit(1)
