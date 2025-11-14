# AlquilerVehiculos

Proyecto de la clase de sistemas expertos, despliegue  de la infraestructura de una plataforma de renta de vehiculos usando terraform.

## Escenario General

Una empresa de seguridad y logística lanza una aplicación para la renta de
vehículos blindados. La plataforma debe:
Gestionar operaciones en tiempo real: reservas, contratos y estado de la flota.
Permitir analítica avanzada sin afectar la operación.
La arquitectura soportará dos cargas conectadas:
1. **Operaciones (OLTP):** Base transaccional de alta disponibilidad y baja latencia.
2. **Analítica (Batch/OLAP):** Procesamiento por lotes para patrones de uso,
rentabilidad y mantenimiento.

## Requisitos de la infraestructura

1. **Base de datos transaccional:** Relacional, segura y escalable.
2. **Almacenamiento analítico:** Centralizado para históricos y logs de telemetría
en JSON.
3. **Orquestación de datos:** Proceso batch programado para mover datos del
OLTP al Almacenamiento analítico.
4. **Plataforma de análisis:** Espacio de trabajo con notebooks y soporte Spark.
5. **Gestión de secretos:** Almacén seguro de credenciales.

## Justificación de servicios elegidos

1. **Base de datos transaccional:** *SQL Database -* Basado en el motor SQL Server está diseñado para manejar cargar transaccionales con alta disponibilidad (del 99.99% según el portal oficial de Microsoft) y facil escalabilidad a través de sus modelos de compra (DTU y vCores).

2. **Almacenamiento analítico:** *DataLakeGen2* - Está construido encima de BlobStorage con funcionalidades adicionales orientadas al análisis de datos además que permite organizar los archivos y mantener una jerarquía de directorios.

3. **Orquestación de datos**: *DataFactory* - Permite programar ETLs (y otros workflows) que se ejecuten con una frecuencia programada (una vez a la semana por ejemplo) a través de triggers basados en eventos.

4. **Plataforma de Análisis:** *DataBricks* - Utiliza Apache Spark y un entorno colaborativo de notebooks, además tiene una integración nativa con el servicio de DataLake.  

5. **Gestión de Secretos:** *Azure Key Vault -* Es un servicio dedicado especificamente para el almacenamiento de información sensible como tokens, llaves y certificados. Además de que ofrece una opción de cifrado con hardware (HSM) que no se utiliza en este caso pero resulta robusto para soluciones en ámbitos empresariales.

## Diagrama de la Solución

![Diagrama de la solución](/screenshots/ProyectoTerraform.png "Diagrama de Arquitectura")

## Evidencias de Despliegue

![Evidencia de Despligue](/screenshots/evidenciaDataBricks.png "Despligue exitoso")

![Evidencia de Despligue](/screenshots/evidenciaPortalAzure.png "Despligue exitoso")

## Reflexiones finales

1. Se identificaron ciertas depenencias implícitas como que antes de crear la base de datos se debe crear el servidor de base de datos. También que antes de crear el servicio data factory se debe crear los recursos OLTP y OLAP.

2. Se separan los almacenamientos OLTP y OLAP, principalmente porque sirven diferentes propósitos además de que ambas tienen una gran cantidad de consultas de modo que si fueran una sola, la experiencia de usuario se vería serveramente afectada debido a la sobre carga de consultas en una sola base de datos.

3. La principal ventaja que tiene usar un servicio de orquestación frente a un script manual programado es la capacidad de responder a eventos dentro de la arquitectura, además que ofrece la opción de configurar alertas.