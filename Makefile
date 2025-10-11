.PHONY: up down logs psql build
ARGS ?= transacciones -c1=userB

# Listar containers
ps:
	docker ps -a

# Levantar todo
up:
	docker-compose up -d

# Apagar todo
down:
	docker-compose down

# Apagar todo
down-db:
	docker-compose down -v

# Reconstruir imagen de la app
build:
	docker-compose build --no-cache ledger_app

# Logs de la app
logs-app:
	docker-compose logs -f ledger_app

# Logs de la DB
logs-db:
	docker-compose logs -f db

# Abrir psql dentro del contenedor
psql:
	docker-compose exec db psql -U postgres -d ledger_db

# Crear y migrar la DB
migrate:
	docker-compose exec ledger_app sh -c "mix ecto.create && mix ecto.migrate"

# Abrir shell dentro del contenedor de la app
shell:
	docker exec -it ledger_app_container /bin/sh

run-dev:
	docker run --rm -it \
  	  -v $(PWD):/ledger-container \
	  -w /ledger-container \
	  -e DATABASE_URL="ecto://postgres:postgres@host.docker.internal:5432/ledger_db" \
	  elixir:1.18.4-alpine \
	  sh -c "mix local.hex --force && mix local.rebar --force && mix deps.get && mix escript.build && ./_build/dev/bin/ledger $(ARGS)"
