# ⚽ Sportec

**Sportec** es un emocionante juego de fútbol arcade desarrollado en **Godot Engine**. Con un estilo visual retro de pixel art y una jugabilidad rápida, Sportec te permite disputar torneos completos desde tu dispositivo móvil.

![Godot Engine](https://img.shields.io/badge/Godot-4.x-blue?logo=godotengine&logoColor=white)
![Platform](https://img.shields.io/badge/Plataforma-Android-green?logo=android&logoColor=white)

## 📋 Características

* **Modos de Juego:**
    * Modo Torneo (Cuartos, Semis y Final).
* **Equipos:** Selección de varios equipos con estadísticas personalizadas.
* **Jugabilidad:** Pases, disparos, barridas y sistema de faltas.
* **Controles Táctiles:** Joystick virtual y botones de acción integrados.

## 🎮 Controles

El juego está diseñado para ser jugado en pantallas táctiles (móvil).

* **Joystick Virtual (Izquierda):** Mover al jugador seleccionado.
* **Botones de Acción (Derecha):**
    * 🗡️ **Tackle (Barrida):** Para quitar el balón cuando defiendes.
    * 👟 **Pass (Pase):** Pasar el balón a un compañero cercano.
    * ⚽ **Shoot (Disparo):** Disparar al arco (mantener para más potencia).

> **Nota:** En los menús, utiliza el toque simple para seleccionar opciones, equipos y navegar por la interfaz.

## 🚀 Instrucciones de Instalación (Desarrollo)

Si deseas clonar y editar este proyecto en Godot:

1.  Asegúrate de tener instalado **Godot Engine 4.x**.
2.  Clona este repositorio:
    ```bash
    git clone [https://github.com/ftmadrid/sportec.git](https://github.com/ftmadrid/sportec.git)
    ```
3.  Abre Godot, selecciona "Importar" y busca el archivo `project.godot` en la carpeta `sportec`.
4.  ¡Listo! Ya puedes ejecutar el juego en el editor.

## 📱 Pasos para Compilar en Móvil (Android)

Para exportar el APK y jugarlo en tu celular, sigue estos pasos:

1.  **Configuración de Godot:**
    * Ve a `Editor` -> `Manage Export Templates` y descarga las plantillas para tu versión de Godot.
    * Asegúrate de tener configurado el **Android SDK** y **Java JDK** en `Editor` -> `Editor Settings` -> `Export` -> `Android`.

2.  **Configuración de Exportación:**
    * Ve a `Project` -> `Export`.
    * Si no existe, añade un preset de **Android**.
    * En la pestaña "Options", asegúrate de que las texturas estén configuradas (usualmente `ETC2` para dispositivos modernos).
    * Verifica que los permisos de `Internet` o `Almacenamiento` estén marcados si son necesarios (para este juego básico, los permisos por defecto suelen bastar).

3.  **Generar APK:**
    * Conecta tu celular por USB (con depuración USB activa) y haz clic en el icono de Android arriba a la derecha en el editor para "One-click Deploy".
    * O haz clic en **"Export Project"** en el menú de exportación, desmarca "Export With Debug" (para versión final) y guarda el archivo `.apk`.

## 📂 Créditos y Licencias

### Desarrollo
* **Creador:** ftMadrid - *Lógica del juego, diseño de niveles e implementación.*

### Assets y Recursos de Terceros
Proporcionados por: nicolasbize
Este proyecto utiliza recursos de terceros bajo sus respectivas licencias:

* **Motor:** [Godot Engine](https://godotengine.org/) (Licencia MIT).
* **Fuentes:**
    * *Daydream*: Incluida en `assets/fonts/`. Ver licencia en `Daydream 1.0 Personal License.txt`.
    * *Pixeled*: Fuente estilo retro utilizada en la UI.
* **Plugin:**
    * **Virtual Joystick:** Utilizado para el control táctil (ubicado en `addons/virtual_joystick`). Créditos a su respectivo autor (MarcoFazioRandom).
* **Audio y Música:**
    * Efectos de sonido (rebote, disparo, silbato) y música de fondo (`gameplay.mp3`, `menu.mp3`).

---
