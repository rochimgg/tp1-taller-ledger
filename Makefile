.PHONY: up down logs psql build

# Listar containers
ps:
	docker ps -a

# Levantar todo
up:
	docker-compose up -d ledger_app

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
	docker-compose run --rm ledger_app sh -c "mix deps.get && mix ecto.create && mix ecto.migrate"

migrate-dev:
	docker-compose --env-file .env.dev -f docker-compose.dev.yml run --rm ledger_migrate

# Abrir shell dentro del contenedor de la app
shell:
	docker exec -it ledger_app_container /bin/sh

run-dev:
	docker-compose --env-file .env.dev -f docker-compose.dev.yml run --rm --build ledger_app && \
	sh -c "mix escript.build && ./_build/dev/bin/ledger $(ARGS)"

data-setup-dev:
	docker-compose --env-file .env.dev -f docker-compose.dev.yml run --rm --build ledger_app sh -c "\
		mix escript.build && \
		./_build/dev/bin/ledger crear_moneda -n=ARG -p=1500 && \
		./_build/dev/bin/ledger crear_moneda -n=USD -p=1 && \
		./_build/dev/bin/ledger crear_usuario -n=rocio -b=1994-10-18 && \
		./_build/dev/bin/ledger crear_usuario -n=vlad -b=1995-04-29 && \
		./_build/dev/bin/ledger alta_cuenta -u=1 -m=1 -a=1500 && \
		./_build/dev/bin/ledger alta_cuenta -u=2 -m=2 -a=1000 && \
		./_build/dev/bin/ledger realizar_transferencia -o=1 -d=2 -m=1 -a=500 && \
		./_build/dev/bin/ledger realizar_swap -u=1 -mo=1 -md=2 -a=1000 \
	"

data-setup:
	docker-compose run --rm --build ledger_app sh -c "\
		mix escript.build && \
		./_build/dev/bin/ledger crear_moneda -n=ARG -p=1500 && \
		./_build/dev/bin/ledger crear_moneda -n=USD -p=1 && \
		./_build/dev/bin/ledger crear_usuario -n=rocio -b=1994-10-18 && \
		./_build/dev/bin/ledger crear_usuario -n=vlad -b=1995-04-29 && \
		./_build/dev/bin/ledger alta_cuenta -u=1 -m=1 -a=1500 && \
		./_build/dev/bin/ledger alta_cuenta -u=2 -m=2 -a=1000 && \
		./_build/dev/bin/ledger realizar_transferencia -o=1 -d=2 -m=1 -a=500 && \
		./_build/dev/bin/ledger realizar_swap -u=1 -mo=1 -md=2 -a=1000 \
	"

db-down-dev:
	docker-compose --env-file .env.dev -f docker-compose.dev.yml down -v

db-up-reset-dev: 
	docker-compose --env-file .env.dev -f docker-compose.dev.yml down -v &&\
	docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d db
	# Esperar que la DB esté lista
	@sleep 5
	# Ejecutar migraciones desde el contenedor de la app
	docker-compose --env-file .env.dev -f docker-compose.dev.yml run --rm ledger_migrate sh -c "mix deps.get && mix ecto.create && mix ecto.migrate"

db-up-reset: 
	docker-compose -f docker-compose.yml down -v &&\
	docker-compose -f docker-compose.yml up -d db
	# Esperar que la DB esté lista
	@sleep 5
	# Ejecutar migraciones desde el contenedor de la app
	docker-compose -f docker-compose.yml run --rm ledger_migrate sh -c "mix deps.get && mix ecto.create && mix ecto.migrate"

db-up: 
	docker-compose -f docker-compose.yml down &&\
	docker-compose -f docker-compose.yml up -d db

new-migration:
	@read -p "Nombre de la migración (ej: currency_unique_index): " name; \
	mix ecto.gen.migration $$name

setup:
	make db-up-reset && \
	make build && \
	make up
