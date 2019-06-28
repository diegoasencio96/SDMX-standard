# SDMX-standard

Este repositorio brinda una ayuda tecnológica para la implementación del estándar SDMX, exigido en las entidades públicas gubernamentales para el intercambio y la difusión de información estadística.

![Ciclo del proceso de implementación del estándar SDMX](resources/images/sdmx-estandar.jpg)

<br>

## Comenzando :clock1:

_Estas instrucciones te permitirán obtener una copia del repositorio en funcionamiento en tu máquina local para propósitos de desarrollo y pruebas._

Mira **Despliegue** para conocer como desplegar el repositorio con las aplicaciones web (WebClient y WebService).

<br>

### Pre-requisitos :clipboard:

Para la implementación del estándar SDMX se deben descargar previamente las siguientes herramientas tecnológicas.

```
- Data Structure Wizard
- Mapping Assistant
- Web Client
- Web Service
```

<br>

### Herramientas :wrench:

Las herramientas de escritorio _Data Structure Wizard_ y _Mapping Assistant_ se deben instalar en un Sistema Operativo Windows

#### Data Structure Wizard

El Data Structure Wizard (DSW) es una aplicación de escritorio independiente de Java que admite las versiones 2.0 y 2.1 del estándar SDMX. 

Otra facilidad de la aplicación es que ofrece la posibilidad de crear dinámicamente una plantilla de mensaje de datos para un DSD específico. Estas plantillas se pueden llenar y luego crear archivos de datos de muestra para transformarlos a un formato HTML y guardarlos localmente.

El DSW proporciona un mecanismo para importar/exportar DSD SDMX-ML 2.0 y 2.1 y un mecanismo para importar/exportar DSD desde/a archivos de estructura GESMES/TS. Además, los DSM SDMX-ML 2.0 y 2.1 se pueden validar con esquemas estándar SDMX.

Se puede encontrar más información sobre la aplicación en el [espacio de información SDMX](https://ec.europa.eu/eurostat/web/sdmx-infospace/sdmx-it-tools/dsw).

***Licencia:*** Open Source

***Formato(s) de entrada:*** CSV; SDMX-ML 

***Formato de salida (s):*** SDMX-ML

***Lenguaje (s) de programación:*** Java

***Sistema operativo(s):*** Sistema Operativo Independiente

***Idioma(s):*** Inglés

<br>

#### Mapping Assistant

El Mapping Assistant está destinado a facilitar el mapeo entre los metadatos estructurales proporcionados por una definición de estructura de datos (DSD) SDMX-ML y los que residen en una base de datos de difusión de un entorno de difusión. 

Mapping Assistant mantiene un Mapping Store para mantener las asignaciones entre el SDMX y el esquema de almacenamiento de datos local.

En la infraestructura de referencia SDMX, el Asistente de asignación proporciona información de mapeo al recuperador de datos. El módulo Data Retriever se conecta a la base de datos de Mapping Store y accede a las asignaciones apropiadas para traducir las consultas SDMX-ML a SQL para la base de datos de difusión.

La herramienta se desarrolló como un paquete o componente portátil que se puede instalar en otras organizaciones.

Más información en el [espacio de información SDMX de Eurostat](https://webgate.ec.europa.eu/fpfis/mwikis/sdmx/index.php/Mapping_Assistant).

***Licencia:*** European Union Public License V.1.1

***Lenguaje(s) de programación:*** .NET (C#)

***Sistema operativo(s):*** Sistema Operativo Windows

***Idioma(s):*** inglés

<br>

### Requerimientos de Software y Hardware ###

#### Software ####

* [Git](https://git-scm.com/downloads): 
* [Docker CE Desktop](https://docs.docker.com/install)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [PyCharm](https://www.jetbrains.com/pycharm/download/) (Opcional)

Asegúrese de haber instalado todos los requisitos de software.


#### Hardware ####

Se proporcionan estimaciones de recursos para dos casos:

Para un `sistema en producción` con decenas (y cientos) de usuarios, se proporcionan asignaciones minimas recomendadas **en negrilla**. Para un `sistema de demostración` que proporcionará la funcionalidad completa de SDMX-Stantard a un número muy limitado de usuarios, las _cifras en cursiva_ indican la configuración más pequeña conocida que haya ejecutado el sistema en el pasado. 

* Servidor Virtual o Físico:
  * **4 CPU cores** o más (_1 CPU cores_)
  * **8 GB RAM** o más (_2 GB RAM_)
  * **100 GB storage** espacio (_20 GB storage_)
  * **50 GB backup** almacenamiento (_0 GB backup_)
  * Conectividad a internet
* OS: Ubuntu, Debian
* Nombre de dominio


Además también deberías tener acceso a:

* [SDMX-standard](https://github.com/diegoasencio96/SDMX-standard/)

Si usted necesita acceso [por favor pregunte](https://github.com/diegoasencio96/)!

<br>

### Obtener el código fuente del proyecto  ###

Vas a clonar el repositorio. Desde el [Terminal](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) escriba:


```
$ mkdir SDMX && cd SDMX
```
Esto creara un directorio llamado ```SDMX``` en la ubicación actual y se re-ubica en el nuevo directorio después de creado.

```
$ git clone https://github.com/diegoasencio96/SDMX-standard.git
```

Esto creará un directorio llamado `SDMX-standard` en la ubicación actual (`SDMX`).

<br>

### Despliegue :rocket:

_El despliegue del proyecto se puede hacer en cualquier Sistema Operativo que tenga Docker y Docker Compose. `Preferiblemente Linux`_


Construir las imágenes de los contenedores

```
$ docker-compose build
```

Levantar los contenedores

```
$ docker-compose up
```

Cuando se complete, su terminal mostrará al final de los logs *INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 'N' ms...*

Para dejar los contenedores en segundo plano agregar el parametro `-d` seguido de `up`

```
docker-compose up -d
```

Si todo se ejecutó con exito, ya tendriamos lista la parte web (Web Client y Web Service) del estandar SDMX del lado del servidor.


Para ver su versión local del proyecto, abra su navegador en:

* [http://localhost:8080/](http://localhost:8080/) o [http://127.0.0.1:8080/](http://127.0.0.1:8080/). 

* [http://localhost:8080/nsi-client/](http://localhost:8080/nsi-client/)

* [http://localhost:8080/nsi-jax-ws/](http://127.0.0.1:8080/nsi-jax-ws/). 

Para detener el proyecto, desde el terminal use `Ctrl + C` o:

```
$ docker-compose down
```

<br>

## Construido con :hammer:

* [Docker](https://docs.docker.com/install/) - Docker
* [Docker Compose](https://docs.docker.com/compose/) - Docker Compose

<br>

## Autores :star2:

* **Diego Asencio** - *Trabajo Inicial* - [diegoasencio96](https://github.com/diegoasencio96)

También puedes mirar la lista de todos los [contribuyentes](https://github.com/diegoasencio96/SDMX-standard/graphs/contributors) quíenes han participado en este proyecto. 

<br>

## Licencia :scroll:

Este proyecto está bajo la Licencia (GNU General Public License v3.0) - mira el archivo [LICENSE](LICENSE) para detalles

<br>

## Expresiones de Gratitud :gift:

* Comenta a otros sobre este proyecto :loudspeaker:
* Invita una cerveza :beer: a alguien del equipo. 
* Da las gracias públicamente :wave:.
* Ayuda a reportar y/o corregir fallos :sos:.

<br>

---
:keyboard: con :heartpulse: por [diegoasencio96](https://github.com/diegoasencio96) :man:
