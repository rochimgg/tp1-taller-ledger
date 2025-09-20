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

## Compilar con escript

### Para generar un ejecutable de línea de comandos

1. Construye el ejecutable:

`mix escript.build`

Esto generará un binario ledger en la raíz del proyecto.

2. Ejecuta tu CLI:

`./ledger balance --c1 userA --m USD --t "path/to/transactions.csv"`

## Uso

### Ejemplos de comandos

- Balance de una cuenta:

`./ledger balance --c1 userA --m USD`

- Listar transacciones:

`./ledger transacciones --t "transactions.csv"`

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

## Ledger - Esquemas y errores soportados

### 1. Currency

Campos: `currency_name`, `usd_exchange_rate`  

Errores posibles:

- `currency_name`  
  - `"can't be blank"`: no se pasó `currency_name`.
- `usd_exchange_rate`  
  - `"can't be blank"`: no se pasó `usd_exchange_rate`.  
  - `"must be greater than 0"`: valor <= 0.  
  - `"is invalid"`: valor no convertible a float.

### 2. Transaction

Campos: `timestamp`, `origin_currency`, `destination_currency`, `amount`, `origin_account`, `destination_account`, `type`  

Errores posibles:

- `timestamp`  
  - `"can't be blank"`: falta timestamp.
- `origin_currency`  
  - `"can't be blank"`: falta origin_currency.  
  - `"is not a valid currency"`: no está en el lookup de monedas.
- `destination_currency`  
  - `"is not a valid currency"`: no está en el lookup (si no es `nil`).
- `amount`  
  - `"can't be blank"`: falta amount.  
  - `"must be greater than 0"`: valor <= 0.
- `type`  
  - `"can't be blank"`: falta type.  
  - `"is invalid"`: valor no está en `Type.all()`.
- `origin_account`  
  - `"can't be blank"`: falta origin_account.
- `destination_account`  
  - `"can't be blank"`: si `type == :transferencia`.  
  - `"cannot be the same as origin_account"`: si `type == :transferencia` y destino = origen.
  
## Nota de limitación

Actualmente, como limitación del proyecto, **no se ha implementado la salida en archivo** mediante el flag `-o`. Todas las operaciones imprimen los resultados por terminal.
