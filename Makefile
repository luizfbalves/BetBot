.PHONY: setup run help clean venv install

help:
	@echo "BetBot - Comandos Disponíveis"
	@echo ""
	@echo "  make setup        - Setup completo (venv + dependências + env.py)"
	@echo "  make run          - Iniciar BetBot"
	@echo "  make clean        - Limpar ambiente virtual"
	@echo "  make venv         - Criar apenas venv"
	@echo "  make install      - Instalar apenas dependências"
	@echo ""

setup: venv install
	@echo ""
	@echo "✓ Setup completo!"
	@echo ""
	@if [ ! -f env.py ]; then \
		echo "Configure MongoDB:"; \
		echo "  1. https://www.mongodb.com/cloud/atlas"; \
		echo "  2. Crie um Cluster"; \
		echo "  3. Database 'betbot' com Collection 'users'"; \
		echo "  4. Connect > Python"; \
		read -p "Connection string: " MONGO; \
		echo "autenticacao = \"$$MONGO\"" > env.py; \
		echo "✓ env.py criado"; \
	else \
		echo "✓ env.py já existe"; \
	fi

venv:
	@if [ ! -d venv ]; then \
		echo "Criando ambiente virtual..."; \
		python3 -m venv venv; \
		echo "✓ venv criado"; \
	else \
		echo "✓ venv já existe"; \
	fi

install: venv
	@echo "Instalando dependências..."
	@. venv/bin/activate && pip install --upgrade pip > /dev/null 2>&1
	@. venv/bin/activate && pip install -r requirements.txt > /dev/null 2>&1
	@echo "✓ Dependências instaladas"

run:
	@if [ ! -d venv ]; then \
		echo "Erro: venv não encontrado. Execute: make setup"; \
		exit 1; \
	fi
	@if [ ! -f env.py ]; then \
		echo "Erro: env.py não encontrado. Execute: make setup"; \
		exit 1; \
	fi
	@. venv/bin/activate && python3 main.py

clean:
	@echo "Limpando..."
	@rm -rf venv
	@echo "✓ Ambiente removido"

.DEFAULT_GOAL := help
