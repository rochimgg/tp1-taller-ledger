# Imagen base de Elixir + Erlang
FROM elixir:1.18.4-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache build-base git postgresql-client

# Crear directorio de trabajo
WORKDIR /ledger-container

# Copiar mix.exs y mix.lock y descargar deps
COPY mix.exs mix.lock ./
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Copiar el resto del proyecto
COPY . .

# Compilar el escript

RUN mix escript.build && \
    chmod +x _build/dev/bin/ledger && \
    cp _build/dev/bin/ledger /usr/local/bin/ledger

CMD ["tail", "-f", "/dev/null"]
