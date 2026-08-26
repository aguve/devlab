# DevLab

Entorno de desarrollo modular basado en Docker. Un workspace compartido con múltiples contenedores para Python, Java, utilidades y base de datos, accesibles de forma independiente o conjunta.

## Quick Start

```bash
git clone https://github.com/aguve/devlab
cd devlab

cp .env.example .env

./scripts/build.sh
./scripts/start.sh
```

> **Nota:** El directorio data/opencode/ se crea automáticamente para persistir la configuración y estado de OpenCode. Los datos de MySQL se almacenan en el volumen Docker mysql-data.

### Check the environment

```bash
./scripts/status.sh
```

### Start Python or Java when needed

```bash
./scripts/start.sh python
./scripts/python.sh /workspace/my-project
```

```bash
./scripts/start.sh java
./scripts/java.sh /workspace/my-project
```

### Use OpenCode in a project

```bash
./scripts/opencode.sh /workspace/my-project
```

## Qué incluye

| Servicio | Imagen | Descripción | Puertos |
|----------|--------|-------------|---------|
| **opencode** | `ghcr.io/anomalyco/opencode` | Asistente de código AI | — |
| **python** | `devlab/python-dev:1.0` | Python 3.11 + data science, web, testing | 8000, 8888 |
| **java** | `devlab/java-dev:1.0` | Java 21 + Maven + Gradle | — |
| **tools** | `devlab/tools:1.0` | CLI utilities (ripgrep, fd, bat, gh, mysql-client...) | — |
| **mysql** | `mysql:8.4` | Base de datos MySQL | 3306 |

## Arquitectura

                         ┌─────────────────┐
                         │     Host        │
                         │     Ubuntu      │
                         └────────┬────────┘
                                  │
                           /workspace
                                  │
              ┌───────────────────┼───────────────────┐
              │                   │                   │
        ┌─────▼─────┐       ┌─────▼─────┐       ┌─────▼─────┐
        │  Python   │       │   Java    │       │   Tools   │
        └─────┬─────┘       └─────┬─────┘       └─────┬─────┘
              │                   │                   │
              └───────────────────┼───────────────────┘
                                  │
                         ┌────────▼────────┐
                         │     MySQL       │
                         └─────────────────┘

                         ┌─────────────────┐
                         │    OpenCode     │
                         └─────────────────┘

Todos los contenedores comparten un workspace (`/workspace`) montado desde el host y se comunican entre sí a través de la red `devlab`.

## Requisitos

- Docker Engine 20.10+
- Docker Compose v2

## Instalación

```bash
git clone https://github.com/aguve/devlab
cd devlab
```

Copiar el archivo de ejemplo y ajustar las variables:

```bash
cp .env.example .env
# Editar .env con tus valores
```

Levantar:

```bash
./scripts/build.sh
./scripts/start.sh
```

### Servicios base

Por defecto, DevLab inicia:

- OpenCode
- MySQL

Los entornos de desarrollo se pueden activar bajo demanda:

./scripts/start.sh python
./scripts/start.sh java
./scripts/start.sh tools

## Configuración

Todas las variables están en el archivo `.env` (ver `.env.example`):

```env
# Timezone
TZ=Europe/Barcelona

# Workspace del host (se monta en todos los contenedores)
HOST_WORKSPACE=${HOME}/workspace

# MySQL
MYSQL_ROOT_PASSWORD=changeme
MYSQL_DATABASE=devlab
MYSQL_USER=developer
MYSQL_PASSWORD=changeme

# Versiones
OPENCODE_VERSION=1.17.11
PYTHON_VERSION=3.11-slim
JAVA_VERSION=21-jdk
MYSQL_VERSION=8.4

# UID/GID del usuario del host
```

## Uso

### Scripts de gestión

| Script | Descripción |
|--------|-------------|
| `./scripts/build.sh` | Construir imágenes Docker |
| `./scripts/start.sh` | Iniciar opencode + mysql (por defecto) |
| `./scripts/stop.sh` | Detener opencode + mysql (por defecto) |
| `./scripts/restart.sh` | Reiniciar opencode + mysql (por defecto) |
| `./scripts/status.sh` | Ver estado de los contenedores |
| `./scripts/logs.sh` | Ver logs (con `-f` para seguir en tiempo real) |

`start.sh`, `stop.sh` y `restart.sh` operan sobre opencode y mysql por defecto. Se puede pasar un servicio adicional como parámetro:

```bash
./scripts/start.sh              # Inicia opencode + mysql
./scripts/start.sh python       # Inicia opencode + mysql + python
./scripts/stop.sh               # Detiene opencode + mysql
./scripts/stop.sh python        # Detiene opencode + mysql + python
./scripts/restart.sh java       # Reinicia opencode + mysql + java
```

Los demás scripts aceptan parámetros para filtrar por servicio:

```bash
./scripts/logs.sh mysql          # Solo logs de MySQL
```

### Acceso a contenedores

| Script | Acción |
|--------|--------|
| `./scripts/python.sh` | Shell bash en el contenedor Python |
| `./scripts/java.sh` | Shell bash en el contenedor Java |
| `./scripts/tools.sh` | Shell bash en el contenedor Tools |
| `./scripts/opencode.sh` | Shell sh en el contenedor OpenCode (usa busybox, no bash) |
| `./scripts/mysql.sh` | Cliente MySQL interactivo (lee credenciales de `.env`) |

Los scripts de acceso aceptan un parámetro opcional con el directorio de trabajo:

```bash
./scripts/opencode.sh                    # Abre en /workspace
./scripts/opencode.sh /workspace/webcv   # Abre en /workspace/webcv
./scripts/java.sh /workspace/webcv       # Abre Java en /workspace/webcv
./scripts/python.sh /workspace/mi-proyecto  # Abre Python en /workspace/mi-proyecto
```

### Puertos expuestos

| Servicio | Puerto Host → Contenedor |
|----------|--------------------------|
| Python (dev server) | `8000:8000` |
| JupyterLab | `8888:8888` |
| MySQL | `3306:3306` |

### Conexión con MySQL Workbench

Crear una nueva conexión con los siguientes datos:

| Campo | Valor |
|-------|-------|
| **Hostname** | `127.0.0.1` |
| **Port** | `3306` |
| **Username** | `${MYSQL_USER}` |
| **Password** | `${MYSQL_PASSWORD}` |
| **Default Schema** | `${MYSQL_DATABASE}` |

Ver valores reales en el archivo `.env`.

## Añadir un nuevo contenedor

### 1. Crear el Dockerfile

Crear un directorio en `images/` con el nombre del servicio:

```bash
mkdir images/mi-servicio
```

Crear `images/mi-servicio/Dockerfile`:

```dockerfile
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    curl \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]
```

> Los contenedores de desarrollo (python, java, tools) permanecen activos mediante tail -f /dev/null y se utilizan principalmente mediante docker exec. Los servicios de infraestructura y OpenCode utilizan sus propios procesos de ejecución.

### 2. Añadir el servicio en docker-compose.yml

Añadir un nuevo bloque dentro de `services:`:

```yaml
  mi-servicio:
    build:
      context: ./images/mi-servicio

    image: devlab/mi-servicio:1.0

    container_name: devlab-mi-servicio

    restart: unless-stopped

    stdin_open: true
    tty: true

    working_dir: /workspace

    volumes:
      - ${HOST_WORKSPACE}:/workspace

    depends_on:
      mysql:
        condition: service_healthy

    networks:
      - devlab
```

Opciones según necesidad:
- **Sin dependencia de MySQL**: eliminar el bloque `depends_on`
- **Puertos expuestos**: añadir bloque `ports:` (ej: `"9000:9000"`)
- **Variables de entorno**: añadir bloque `environment:`

### 3. Crear script de acceso

Crear `scripts/mi-servicio.sh`:

```bash
#!/bin/bash
docker exec -it devlab-mi-servicio bash "$@"
```

Hacerlo ejecutable:

```bash
chmod +x scripts/mi-servicio.sh
```

### 4. Construir y arrancar

```bash
./scripts/build.sh mi-servicio
./scripts/start.sh mi-servicio
./scripts/mi-servicio.sh
```

## Estructura del proyecto

```
devlab/
├── .env                         # Variables de configuración (no se sube a git)
├── .env.example                 # Plantilla de variables de ejemplo
├── .gitignore                   # Archivos ignorados por git
├── docker-compose.yml           # Definición de servicios
├── images/
│   ├── base/Dockerfile          # Imagen base (template)
│   ├── python-dev/Dockerfile    # Python 3.11
│   ├── java-dev/Dockerfile      # Java 21
│   └── tools/Dockerfile         # Utilidades CLI
├── scripts/
│   ├── lib/
│   │   └── common.sh             # Funciones compartidas
│   ├── build.sh                 # Construir imágenes
│   ├── start.sh                 # Iniciar contenedores
│   ├── stop.sh                  # Detener contenedores
│   ├── restart.sh               # Reiniciar contenedores
│   ├── status.sh                # Ver estado
│   ├── logs.sh                  # Ver logs
│   ├── python.sh                # Acceso a Python
│   ├── java.sh                  # Acceso a Java
│   ├── tools.sh                 # Acceso a Tools
│   ├── opencode.sh              # Acceso a OpenCode
│   └── mysql.sh                 # Cliente MySQL
├── data/                        # Datos persistentes (no se sube a git)
│   ├── mysql/                   # Archivos de MySQL (auto-generados)
│   └── opencode/                # Datos de OpenCode (auto-generados)
│       ├── config/              # Configuración de OpenCode
│       ├── share/               # Base de datos compartida
│       ├── cache/               # Caché temporal
│       └── state/               # Estado de la aplicación
└── data-example/                # Estructura de ejemplo de data/
    ├── mysql/                   # (vacío, se genera automáticamente)
    └── opencode/
        └── config/
            └── opencode.jsonc   # Configuración mínima de OpenCode
```

> **Nota:** El directorio `data/` se crea automáticamente en el primer arranque. No es necesario crearlo manualmente. El directorio `data-example/` muestra la estructura esperada.

## Estado

**v1.0.0 — Development environment operational**

| Component | Status |
|---|---|
| Python | ✅ |
| Java | ✅ |
| Tools | ✅ |
| MySQL | ✅ |
| OpenCode | ✅ |
| Management scripts | ✅ |

## Roadmap

### v1.1
- [ ] Script de actualización de servicio *(en desarrollo)*
- [ ] Mejorar la documentación *(en desarrollo)*
- [ ] Usuario 'developer'
- [ ] UID/GID
- [ ] Tests autmáticos
- [ ] CI con GitHub Actions

## Notas

- El workspace del host (`${HOME}/workspace`) se comparte con todos los contenedores en `/workspace`
- MySQL tiene un healthcheck configurado; los contenedores dependientes esperan a que esté sano
- Los datos de MySQL se persisten en `data/mysql/` (auto-generado)
- La configuración de OpenCode se persiste en `data/opencode/` (auto-generado)
- La imagen `images/base/Dockerfile` es una plantilla base no utilizada actualmente, disponible para nuevos servicios
- El directorio `data/` se crea automáticamente en el primer arranque; no es necesario crearlo manualmente
