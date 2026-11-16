# Integración con el modelo 3D del equipo

**Estado:** preparado, sin activar. CygnusX ya emite y escucha los mensajes descritos aquí.
Para conectar el modelo solo hace falta su URL y que el modelo use estos mismos mensajes.

## Idea

CygnusX muestra **una zona pequeña del cielo** a lo largo del tiempo. El modelo del compañero (un globo 3D
estilo "OSIRIS") muestra **el contexto completo**. Los dos se mantienen sincronizados:

- Si el usuario busca una zona, cambia de banda o de año en CygnusX → el modelo se mueve a esa zona.
- Si el usuario hace clic en un punto del modelo → CygnusX abre esa zona del cielo.
- Si el usuario mueve el cursor en uno → el otro puede mostrar dónde está.

## Cómo activarlo

1. El modelo debe poder abrirse en una URL propia, por ejemplo `https://modelo.cygnus.earth/`.
2. En `viewer/.env.local` agregar:

   ```
   VITE_MODEL_URL=https://modelo.cygnus.earth/
   ```

3. Volver a correr `npm run dev` (o `npm run build`). Aparece un selector **Imagen | Modelo 3D** encima de la imagen.
   Sin esa variable, el selector no aparece y CygnusX funciona igual que siempre.

El modelo se carga dentro de un `<iframe>` con la posición inicial en la URL:
`https://modelo.cygnus.earth/?ra=269.45208&dec=4.69339&fov=10`

## Mensajes (`window.postMessage`)

Código: `src/integrations/skyBus.ts`.

### CygnusX → modelo (eventos)

Todos llevan `source: 'cygnusx'`.

```js
// Cambió lo que se ve: zona, campo de visión, banda o año
{ source: 'cygnusx', type: 'view', ra: 269.45208, dec: 4.69339, fov: 10,
  channel: 'b57',                        // all | 1…6 | b1…b102 | rgb
  frame: { year: 2026, mission: 'spherex', mid: '2026-05-02' } }   // null en modo Sumar

// El cursor se movió (máx. 1 vez por cuadro de pantalla)
{ source: 'cygnusx', type: 'cursor', ra: 269.4601, dec: 4.7068 }

// El usuario seleccionó un punto (clic o Enter)
{ source: 'cygnusx', type: 'select', ra: 269.4601, dec: 4.7068 }
```

`ra` y `dec` están siempre en **grados** (J2000). `fov` en **minutos de arco**.

### Modelo → CygnusX (comandos)

Todos llevan `source: 'cygnusx-model'`. CygnusX valida los valores y descarta lo que no reconoce.

```js
// Ir a una zona del cielo (abre esa zona en el visor)
window.parent.postMessage({ source: 'cygnusx-model', type: 'goto', ra: 133.795, dec: -7.245, fov: 20, name: 'WISE 0855' }, '*');

// Mover el cursor de CygnusX / seleccionar un punto
window.parent.postMessage({ source: 'cygnusx-model', type: 'cursor', ra: 133.79, dec: -7.24 }, '*');
window.parent.postMessage({ source: 'cygnusx-model', type: 'select', ra: 133.79, dec: -7.24 }, '*');
```

Ejemplo mínimo dentro del modelo:

```js
window.addEventListener('message', (e) => {
  const m = e.data;
  if (!m || m.source !== 'cygnusx') return;
  if (m.type === 'view') moverCamaraA(m.ra, m.dec, m.fov);
  if (m.type === 'cursor') mostrarMarcador(m.ra, m.dec);
});
```

## También al revés

Si el modelo es la página principal y **CygnusX va dentro de un iframe**, funciona igual: CygnusX envía sus
eventos a `window.parent` y escucha los comandos del padre.
`<iframe src="https://visor.cygnus.earth/?ra=269.45&dec=4.69&fov=10"></iframe>`

## Pendiente cuando llegue el modelo

- Acordar la URL y el dominio. Por seguridad, en producción conviene cambiar el `'*'` de `postMessage`
  por el dominio exacto del modelo.
- Confirmar que el modelo usa RA/Dec en grados J2000 (no horas).
- Decidir si el modelo debe recibir también la banda (`channel`) para colorear sus capas.
