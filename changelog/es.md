## 5.0.2

**Correcciones**
- Resuelto un problema crítico en el modo aleatorio donde la pista actual podía mostrar una duración de 0, impidiendo que la reproducción avanzara automáticamente a la siguiente pista.

**Características**
- Añadido soporte de arrastrar y soltar en escritorio para archivos de respaldo y carpetas, facilitando restaurar tu biblioteca o añadir carpetas locales directamente desde tu administrador de archivos.

## 5.0.1

**Correcciones**

- Corregido un problema donde renombrar listas de reproducción no funcionaba.
- Corregido un problema que impedía agregar pistas a listas de reproducción en Android.
- Corregidos errores que ocurrían al iniciar la aplicación sin conexión a internet.
- Restaurada la inicialización adecuada de YouTube Music después de reconectar a internet — anteriormente, la aplicación requería reiniciar con una conexión activa para recuperar el acceso.

**Mejoras**

- Agregados iconos de control de ventana (minimizar, maximizar, cerrar) para Windows y Linux, ahora se muestran correctamente al pasar el mouse sobre los botones.
- Mejorado el monitoreo de conexión para una transición más confiable entre modos en línea y fuera de línea.
- Mejorada la extracción de audio: la aplicación ahora recupera la más alta calidad de audio disponible de YouTube.

## 5.0.0

**Nuevas Funcionalidades**

- Interfaz refinada y más consistente, con mejoras generales en la organización visual y la navegación.
- UI/UX mejorada en escritorio: mejor comportamiento con ventanas, mouse y uso general de PC.
- Se agregó el Temporizador de Sueño.
- Biblioteca Local: ahora puedes agregar carpetas de tu dispositivo a tu biblioteca.
Nota: La biblioteca local y la biblioteca Musily se administran por separado para garantizar la integridad de los datos.
- Cola persistente: tu cola de reproducción se conserva incluso después de reiniciar la aplicación.
- Modo offline: la aplicación ahora detecta automáticamente cuando no hay conexión a internet y cambia al modo offline.
- Administrador de Actualizaciones: ahora puedes actualizar la aplicación o descargar otras versiones directamente desde la aplicación.

**Mejoras**
**Respaldo**

- El respaldo y la restauración ahora funcionan completamente en segundo plano sin congelar la aplicación — incluso con un gran número de descargas activas.
- Los respaldos multiplataforma ahora son más estables y confiables.
**Descargas**

- Sistema de descarga optimizado con múltiples conexiones simultáneas, control dinámico de velocidad y reconexiones más confiables.
- Velocidades de descarga significativamente más rápidas — hasta 50× más rápidas dependiendo de la conexión.
- Múltiples descargas simultáneas sin congelar la aplicación.

**Interfaz**

- El color de acento de la aplicación ahora cambia automáticamente según la pista que se está reproduciendo actualmente
(Este comportamiento se puede cambiar en la configuración.)
- Mensajes de retroalimentación revisados para mayor claridad.
**Recomendaciones**

- Algoritmo de recomendación mejorado, proporcionando sugerencias más relevantes.
- Sugerencias de música mostradas en la pantalla de inicio basadas en tu perfil de escucha.
**Listas de Reproducción y Biblioteca**

- Las listas de reproducción ahora muestran el tiempo total de reproducción.
- Las pistas más antiguas sin duración almacenada ahora tienen su duración actualizada automáticamente cuando se reproducen.

**Reproductor – Correcciones de Estabilidad**

- Se resolvieron varios problemas críticos:
- Corregidos problemas de concurrencia que causaban que la aplicación se congelara al cambiar rápidamente entre pistas.
- El modo repetir-una ahora funciona correctamente.
- Corregido un problema que impedía que la reproducción se reanudara después de largos períodos de inactividad.
- El reproductor ahora se mueve correctamente a la siguiente pista al final de la reproducción en dispositivos donde anteriormente se detenía inesperadamente.
- Corregido un error que impedía a los usuarios reordenar la cola.
- Al reproducir una pista de un álbum o lista de reproducción ya en reproducción, en modo aleatorio, a veces se seleccionaba una pista aleatoria incorrecta — ahora corregido.
- El modo aleatorio podía desestabilizar la aplicación — esto se ha resuelto completamente.

**Letras**

- Las pistas sin letras sincronizadas ahora muestran un tiempo alineado con el temporizador de reproducción.
- Para algunas pistas sin marcas de tiempo, se genera la sincronización automática de letras.

**Correcciones Generales**

- Windows: el botón de descarga ahora cambia correctamente a "Completado" cuando termina la descarga.
- Varias mejoras de estabilidad y rendimiento en toda la aplicación.

**Interfaz y Localización**

- Se agregó soporte para 13 nuevos idiomas: Francés, Alemán, Italiano, Japonés, Chino, Coreano, Hindi, Indonesio, Turco, Árabe, Polaco y Tailandés.

## 4.0.4

**Correcciones**

- Corregido un problema donde los usuarios no podían cargar transmisiones de música.
- Resuelto un problema que impedía que Musily se abriera en Linux.

## 4.0.3

**Correcciones**

- Corregido un problema donde los usuarios no podían cargar transmisiones de música.

## 4.0.2

**Correcciones**

- Corregido un problema donde el título de la ventana no se actualizaba cuando cambiaba la canción.
- Resueltos problemas regionales agregando `CurlService`

**Características**

- Nuevo: Se desplaza automáticamente al inicio de la cola cuando cambia la canción.

## 4.0.1

**Correcciones**

- Resuelto un problema donde la Cola Inteligente no se podía desactivar cuando estaba vacía.
- Corregido un problema donde la Cola Inteligente no funcionaba cuando solo hay un elemento presente en la cola.

**Mejoras**

- Sistema de reproducción de audio completamente reescrito para mejor rendimiento y estabilidad.

**Escritorio**

- Mejorada la resolución del icono de Windows.
- Agregado un tamaño mínimo de ventana para mejorar la gestión de ventanas.

## 4.0.0

**Características**

- Introducido soporte para letras sincronizadas, permitiendo que las letras se sincronicen con la reproducción.
- Implementada detección de color de acento: acento del sistema en escritorio y acento del fondo de pantalla en Android.
- Agregado soporte para escritorio, permitiendo descargas y uso en Linux y Windows.
- Implementada API nativa de pantalla de inicio de Android 12+ para una experiencia de inicio de aplicación más rápida y fluida.
- Mejorada la gestión de cola con ordenación intuitiva de canciones: las siguientes canciones aparecen primero seguidas de pistas anteriores.
- Agregadas animaciones suaves de transición de pistas en la sección de reproducción actual.
- Agregado *actualizador en la aplicación*, permitiendo a los usuarios actualizar la aplicación directamente sin salir de ella (solo Android y Escritorio).

**Correcciones**

- Corregido un problema donde la aplicación se cerraba después de importar una lista de reproducción de YouTube.
- Resuelto un problema donde la aplicación se congelaba después de restaurar una copia de seguridad de la biblioteca.

## 3.1.1

**Mejoras**

- Cola Mágica: Corregida y completamente rediseñada para una experiencia más fluida e inteligente.

## 3.1.0

**Características**

- Agregada la capacidad de importar listas de reproducción de YouTube a tu biblioteca.

**Mejoras**

- Mejorado el respaldo de la biblioteca.
- Otras mejoras en la interfaz.

**Correcciones**

- Corregidas inconsistencias en la biblioteca.
- Resuelto un problema donde los álbumes no se agregaban a listas de reproducción o a la cola desde el menú.

## 3.0.0

**Características**

- Respaldo de Biblioteca: Introducida funcionalidad para operaciones de respaldo perfectas.
- Guardar Música en Descargas: Agregada la capacidad de guardar música directamente en la carpeta de descargas.

**Mejoras**

- Interfaz Mejorada: Mejorada la interfaz de usuario para una experiencia más intuitiva y visualmente atractiva.
- Descargas Más Rápidas: Optimizadas las velocidades de descarga para transferencias de archivos más rápidas y eficientes.

**Correcciones**

- Problemas de la Barra de Navegación: Resueltos errores que afectaban a teléfonos con barras de navegación en lugar de navegación basada en gestos.

## 2.1.2

**Correcciones Rápidas**

- Corregido un problema donde la música se cargaba infinitamente (de nuevo).

## 2.1.1

**Correcciones Rápidas**

- Corregido un problema donde la música se cargaba infinitamente.
- Corregido un error donde el mini reproductor superponía el último elemento de la biblioteca.

**Mejoras Menores**

- El mensaje de biblioteca vacía ahora se muestra correctamente.

## 2.1.0

**Correcciones**

- Resuelto un problema donde ciertos términos de búsqueda resultaban en resultados de búsqueda vacíos.
- Resuelto un problema donde algunos artistas no se podían encontrar.
- Corregido un problema donde algunos álbumes no se encontraban.
- Resuelto un error donde las listas de reproducción descargadas se eliminaban cuando se presionaba el botón de descarga.

**Localización**

- Agregado soporte para el idioma ucraniano.

**Mejoras**

- Mejorada la funcionalidad Cola Mágica para descubrir mejor pistas relacionadas.

**Características**

- Introducida una nueva pantalla de configuración para gestionar preferencias de idioma y cambiar entre temas oscuro y claro.

**Mejoras Menores**

- Varias mejoras y refinamientos menores.

## 2.0.0

**Características**

- Administrador de Descargas: Introducido un nuevo administrador de descargas para mejor control y seguimiento de archivos.
- Filtros de Biblioteca: Aplica filtros a tu biblioteca para una organización más fácil.
- Búsqueda en Listas de Reproducción y Álbumes: Agregada la capacidad de buscar dentro de listas de reproducción y álbumes para una navegación más precisa.

**Localización**

- Soporte de Idioma Mejorado: Agregadas nuevas entradas de traducción para localización mejorada.
- Agregado Soporte para Español: Se ha agregado soporte completo para el idioma español.

**Mejoras**

- Optimización del Modo Sin Conexión: Mejorado el rendimiento en modo sin conexión, proporcionando una experiencia más fluida y eficiente.
- Carga Más Rápida de la Biblioteca: La biblioteca ahora se carga más rápido, reduciendo los tiempos de espera al navegar por tu música y contenido.
- Estabilidad Aumentada del Reproductor: Mejorada la estabilidad del reproductor.

**Cambio Incompatible**

- Incompatibilidad del Administrador de Descargas: El nuevo administrador de descargas no es compatible con la versión anterior. Como resultado, toda la música descargada necesitará ser descargada nuevamente.

## 1.2.0

- **Característica**: Opción para desactivar sincronización de letras
- **Característica**: Cola Mágica - Descubre nueva música con recomendaciones automáticas agregadas a tu lista de reproducción actual.
- **Localización:** Agregado soporte para el idioma ruso
- **Rendimiento:** Optimizaciones en la sección Biblioteca

## 1.1.0

### Nuevas Características

- **Nueva Característica:** Letras
- **Soporte Multi-idioma:** Inglés y Portugués

### Correcciones

- **Corregido:** Carga infinita al agregar la primera canción favorita

### Mejoras

- **Mejoras de Rendimiento:** Optimizaciones en Listas
- **Nuevas Animaciones de Carga**
- **Mejoras en Favoritos**
- **Mejoras en el Reproductor**

## 1.0.1

- Corregido: Pantalla de inicio gris
- Corregido: Obtener directorio del archivo de audio
- Corregido: Colores de la barra de navegación en modo claro
- Corregido: Fallos cuando el usuario intenta reproducir una canción

## 1.0.0

- Versión inicial.

