# Operación Docker de ORBITAL

## Ejecución local

Desde la carpeta del proyecto:

```bash
docker compose up -d --build
```

Abre **http://localhost:3010**. En el primer build, el contenedor Node instala Three.js desde npm y lo copia a `/web/vendor`; la interfaz usa esos archivos locales para que el renderizador 3D no dependa del CDN de un tercero.

## Estado y registros

```bash
docker compose ps
curl http://localhost:3010/api/v1/status
curl http://localhost:3010/health
curl http://localhost:3010/api/v1/connectivity
docker compose logs --tail 150 node
docker compose logs --tail 150 python
docker compose logs --tail 150 mysql
```

La API de consulta puede estar disponible aunque MySQL no lo esté; MySQL es el almacenamiento opcional de resultados. Para guardar datos, activa la casilla en el panel del explorador.

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

## Fuentes y tiempos de espera

- Gaia consulta MAST Gaia DR3 por TAP síncrono para conos pequeños (radio inicial 0.03°, máximo inicial 100 filas); se elimina el ordenamiento costoso.
- AllWISE consulta el endpoint SCS de IRSA con timeout de conexión/lectura y máximo inicial de 100 filas.
- SPHEREx consulta por separado SIA2 DR1 wide y QR3 wide (deep se omite en consultas rápidas) y devuelve metadatos y URL de cutout.
- Las respuestas se guardan temporalmente en caché en el proceso Python; las solicitudes simultáneas idénticas comparten una sola consulta upstream. Una nueva coordenada o filtro genera otra consulta.

Los límites evitan peticiones desmesuradas. El DNS y HTTPS hacia MAST/IRSA se prueban desde el contenedor Python con el botón **Diagnosticar conexión** o en `http://localhost:3010/api/v1/connectivity`. Si la prueba falla, revisa el DNS y la salida a internet de Docker Desktop; que `docker compose ps` marque los servicios como healthy solo confirma la salud local de los contenedores. También puedes verificar DNS con `docker compose exec python python -c "import socket; print(socket.getaddrinfo('mast.stsci.edu',443)); print(socket.getaddrinfo('irsa.ipac.caltech.edu',443))"`. En redes con proxy obligatorio, define `HTTP_PROXY` y `HTTPS_PROXY` en `.env` y reconstruye el servicio Python.
