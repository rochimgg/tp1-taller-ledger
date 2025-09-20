# Ledger CLI Trabajo Práctico Taller de Programacion (Rocío Gallo, 97490)

Ledger es un servicio CLI para gestionar transacciones y balances de cuentas. Permite leer archivos CSV con transacciones o monedas y generar reportes de balances.

## Instalación

### Clonar el repositorio

`git clone https://github.com/rochimgg/tp1-taller-ledger`

`cd tp1-taller-ledger`

### Instala las dependencias

`mix deps.get`

### Correr los tests para verificar que todo funcione

`mix test`

## Compilar con Escript

### Para generar un ejecutable de línea de comandos

1. Construye el ejecutable: `mix escript.build`. Esto generará un binario ledger en `./_build/dev/bin/ledger.`

2. Moverse hasta el directorio donde se encuentra el ejecutable: `cd _build/dev/bin`

3. Ejecuta el CLI: `./ledger balance -c1 userA -m USD -t "path/to/transactions.csv"`

## Uso

### Ejemplos de comandos

- Balance de una cuenta: `./ledger balance -c1 userA -m USD`

- Listar transacciones: `./ledger transacciones -t "transactions.csv"`

## Testing

Todos los tests se ejecutan con:

`mix test`

## Estructura del proyecto

``` bash
├── ledger
│   ├── cli
│   │   ├── balance.ex
│   │   ├── cli.ex
│   │   ├── constants.ex
│   │   └── transactions.ex
│   ├── currency
│   │   ├── csv_reader.ex
│   │   └── service.ex
│   ├── schemas
│   │   ├── balance.ex
│   │   ├── currency.ex
│   │   └── transaction.ex
│   ├── transaction
│   │   ├── csv_reader.ex
│   │   └── service.ex
│   └── types
│       └── type.ex
└── ledger.ex
```

## Esquemas y errores soportados

## Esquemas y errores que podrías encontrar

### 1. Currency (Monedas)

Cada moneda tiene estos campos: `currency_name` y `usd_exchange_rate`.  

Posibles errores:

- `currency_name`  
  - `"can't be blank"`: no se indicó el nombre de la moneda.
- `usd_exchange_rate`  
  - `"can't be blank"`: no se indicó la tasa de cambio.  
  - `"must be greater than 0"`: la tasa debe ser mayor que cero.  
  - `"is invalid"`: el valor ingresado no es un número válido.

### 2. Transaction (Transacciones)

Cada transacción tiene estos campos:  
`timestamp`, `origin_currency`, `destination_currency`, `amount`, `origin_account`, `destination_account` y `type`.  

Posibles errores:

- `timestamp`  
  - `"can't be blank"`: falta la fecha/hora de la transacción.
- `origin_currency`  
  - `"can't be blank"`: no se indicó la moneda de origen.  
  - `"is not a valid currency"`: la moneda no existe en el sistema.
- `destination_currency`  
  - `"is not a valid currency"`: la moneda de destino no existe (si se especifica).
- `amount`  
  - `"can't be blank"`: falta indicar el monto.  
  - `"must be greater than 0"`: el monto debe ser mayor que cero.
- `type`  
  - `"can't be blank"`: falta indicar el tipo de transacción.  
  - `"is invalid"`: el tipo no está permitido.
- `origin_account`  
  - `"can't be blank"`: no se indicó la cuenta de origen.
- `destination_account`  
  - `"can't be blank"`: obligatorio si la transacción es una transferencia.  
  - `"cannot be the same as origin_account"`: la cuenta de destino no puede ser la misma que la de origen en transferencias.
  
## Nota de limitación

Actualmente, como limitación del proyecto, **no se ha implementado la salida en archivo** mediante el flag `-o`. Todas las operaciones imprimen los resultados por terminal.
