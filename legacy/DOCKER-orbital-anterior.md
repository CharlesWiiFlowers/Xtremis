# Operación Docker de ORBITAL · Mecánica orbital integrada 2D

## Ejecución local

Desde la carpeta del proyecto:

```bash
docker compose up -d --build
```

Abre **http://localhost:3010**. ORBITAL presenta una sola simulación Canvas 2D que integra el Sol, seis planetas y los objetos sintéticos del Laboratorio local. Todos aparecen en el mismo plano y comparten controles de tiempo, zoom, desplazamiento y selección. El Campo astronómico independiente fue retirado de la interfaz.

## Estado y registros

```bash
docker compose ps
curl http://localhost:3010/api/v1/status
curl http://localhost:3010/health
docker compose logs --tail 150 node
docker compose logs --tail 150 python
docker compose logs --tail 150 mysql
```

La API puede estar disponible aunque MySQL no lo esté; MySQL es almacenamiento opcional para resultados. El sistema solar de referencia y el laboratorio local funcionan sin internet.

## Actualizar el proyecto

```bash
docker compose up -d --build --force-recreate
```

## Persistencia

MySQL usa el volumen `mysql_data`. Para detener y conservar los datos:

```bash
docker compose down
```

Para borrar también la base local (acción destructiva):

```bash
docker compose down -v
```

## Variables

Copia `.env.example` a `.env` solo si necesitas cambiar credenciales o puertos. El puerto web predeterminado es `3010`; MySQL se expone localmente en `3307`.

## Pruebas

Pruebas de matemática orbital, generación de objetos locales y fichas completas:

```bash
node --test tests/*.test.mjs
```

La prueba de navegador `tests/browser-smoke.py` necesita Playwright y Chromium. Comprueba la selección por clic directo en el lienzo del Sol, los seis planetas y un orbe sintético, además de filtros y adaptación móvil.

## Compatibilidad del backend

Los servicios Node, Python y MySQL se conservan para no romper el despliegue anterior. Las rutas de catálogos astronómicos que aún existan en la API no se muestran ni se invocan desde el simulador unificado actual.
