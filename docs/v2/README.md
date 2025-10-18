# Version TP2 (2.0): Ledger CLI Trabajo Práctico Taller de Programacion (Rocío Gallo, 97490)

## Prerequisitos

Antes de comenzar, asegurate de tener instalados:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)

## Inicializacion del Entorno

Para construir las imágenes, levantar la base de datos, ejecutar migraciones y dejar todo listo:

```bash
make setup
```

Esto:

1. Levanta la base de datos postgres en un contenedor.  
2. Genera un contenedor efímero que aplica las migraciones. Luego de ejecutadas se cierra.
3. Construye la imagen de la aplicación.  
4. Levanta el contenedor principal con la aplicación disponibilizada.  

Una vez completado, el entorno estará listo con la base inicializada y la aplicación compilada.

### Acceder a la terminal del contenedor

Para entrar al contenedor donde está la aplicación compilada:

```bash
make shell
```

Esto abrirá una terminal dentro del contenedor de la aplicación.  

Ahí se pueden ejecutar los comandos requeridos para la segunda entrega del trabajo práctico.

```bash
ledger crear_moneda -n=USD -p=1
ledger crear_usuario -n=rocio -b=1994-10-18
ledger alta_cuenta -u=1 -m=1 -a=1500
```

## Estructura del entorno con contenedores

El entorno define tres servicios principales:

- **ledger_app:** es el contenedor principal donde corre la aplicación Elixir.  
  - Se construye a partir del Dockerfile del proyecto.  
  - Monta la carpeta de datos local para que los archivos estén disponibles dentro del contenedor.  
  - Configura las variables de entorno necesarias para conectarse a la base de datos.  
  - Utiliza el comando `tail -f /dev/null` para mantenerse activo, permitiendo acceder a una shell dentro del contenedor y ejecutar comandos manualmente, por ejemplo:
  
    ``` bash
    make shell
    ```

  - Este enfoque facilita la ejecución de pruebas o comandos del tipo `mix` sin tener que levantar toda la aplicación permanentemente.

- **ledger_migrate:** es un contenedor auxiliar que se usa para ejecutar migraciones de base de datos.  
  - Utiliza la misma imagen de la aplicación.  
  - Ejecuta el comando `mix ecto.migrate` y luego se apaga automáticamente.  
  - Se puede invocar manualmente con:
  
    ``` bash
    make migrate
    ```

- **db:** es la base de datos PostgreSQL utilizada en el entorno de desarrollo.  
  - Usa la imagen oficial `postgres:16-alpine`.  
  - Expone el puerto `5433` para evitar conflictos con instalaciones locales de Postgres.  
  - Recibe las credenciales desde el archivo `.env`.

### Ventajas de la arquitectura basada en contenedores

- No requiere tener PostgreSQL ni Elixir instalados localmente.  
- Permite reiniciar o eliminar todo el entorno sin afectar la máquina del desarrollador.  
- Garantiza que todos los que usen el sistema trabajen con la misma configuración.  
- Facilita la ejecución de comandos aislados, como migraciones o pruebas, sin levantar servicios innecesarios.

### Entorno de desarrollo

El archivo `docker-compose.dev.yml` define un entorno de desarrollo liviano y reproducible que permite ejecutar la aplicación y la base de datos sin necesidad de instalar dependencias locales.

Este entorno está pensado para levantar un contenedor pequeño de desarrollo cada vez que se ejecuta un comando. De esta forma, se puede trabajar de manera aislada, manteniendo el desarrollo sobre contenedores.

Para levantar la base de desarrollo y aplicar sus migraciones, se puede usar el siguiente comando:

``` bash
make db-up-dev
```

Este comando construirá y levantará los contenedores necesarios, aplicará las migraciones y dejará la base lista para ejecutar comandos dentro del entorno de desarrollo.

Al momento de probar una ejecución, durante el desarrollo, se usó:

``` bash
make setup-dev
```

para crear dos monedas y dos usuarios. De forma tal que el desarrollador pueda tener estos recursos disponibles al momento de probar los métodos sobre transacciones.

Para probar un comando nuevo se usó el esquema:

``` bash
make run-dev ARGS="${SUBCOMANDO} ${OPCIONES}"
```

Por ejemplo:

``` bash
make run-dev ARGS="alta_cuenta -u=1 -m=1 -a=1500"
```

esto por detrás construye aplicacion y la sube a un contenedor de desarrollo, aplica el comando con los argumentos indicados y lo cierra al terminar el comando. La definición en el Makefile es:

``` make
run-dev:
  docker-compose -f docker-compose.dev.yml run --rm --build ledger_app && \
  sh -c "mix escript.build && ./_build/dev/bin/ledger $(ARGS)"
```

## Arquitectura del sistema

El proyecto está desarrollado en Elixir y utiliza Docker para garantizar un entorno reproducible y completamente portable.

### Decisiones de diseño

La desarrolladora del sistema consideró de valor aprender a armar una arquitectura portable basada en contenedores, ya que es algo que no había experimentado por cuenta propia en el pasado.

Esta arquitectura permite que el sistema pueda ejecutarse de forma agnóstica, mientras que el servidor tenga acceso a un cliente de Docker, sin instalar recursos externos en su dispositivo.

Definir el proyecto de esta forma, le dio la oportunidad a la desarrolladora de experimentar con contenedores efímeros, crear imágenes customizadas, hacer overrides de configuraciones de contenedores segun el entorno y de paso, simplificar estos comandos definiendo un Makefile.

### Contenedores

El sistema se compone de los siguientes servicios:

- Base de datos:
Se levanta una instancia de PostgreSQL dentro de un contenedor Docker.
Los datos se almacenan en un volumen persistente, de forma que se conservan entre ejecuciones.

- Migraciones:
Las migraciones de la base de datos se ejecutan mediante un contenedor efímero, que se crea exclusivamente para aplicar los cambios del esquema y se elimina automáticamente al finalizar.
Esto asegura que el entorno quede limpio y sin procesos residuales.

- Ledger CLI:
La interfaz de línea de comandos del sistema corre en un contenedor independiente.
Desde allí se pueden ejecutar todas las operaciones del sistema (crear entidades, listar registros, realizar transacciones, etc.).
Esto permite que el sistema sea 100 % portable, sin depender de configuraciones locales ni instalaciones adicionales.

#### Ventajas del enfoque

Entorno de desarrollo y ejecución idéntico para todo aquel que interactúe con el sistema.

- Despliegue y uso simplificado mediante Docker Compose.

- Ejecución aislada de las migraciones y la lógica de negocio.

- Portabilidad total: sólo se requiere Docker para correr el sistema en cualquier máquina.

## Comandos soportados y limitaciones de la entrega

### Comandos soportados

Los comandos soportados son:

- Los comandos de la primera entrega en su formato original.
- Los comandos requeridos para la segunda entrega, con limitaciones mencionadas más adelante.

### Limitaciones de la segunda entrega

Las limitacions de la entrega actual son:

- El cubrimiento de tests no está al 90%.
- Faltan validaciones de la lógica de negocio sobre la que se basan las transacciones
  - Las transferencias no validan que las cuentas estén dadas de alta.
  - Deshacer una transacción no valida que sea la última del usuario.
  - Los comandos del TP1 funcionan de forma aislada con el nuevo diseño de sistema. No se adaptaron para funcionar con la nueva arquitectura.
  
### Notas de la desarrolladora

Las limitaciones del proyecto actual son entregadas a conciencia por la desarrolladora, dado que consideró de mayor valor investigar sobre como armar una arquitectura portable usando contenedores. Estas limitaciones serán abordadas en los próximos días a la entrega y quedarán registradas en el repositorio de la desarrolladora.
