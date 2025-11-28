#!/bin/bash
# Script para manejar el ciclo de fondos de pantalla usando el comando nativo de Sway.

# --- CORRECCIÓN CRÍTICA: EXPORTAR VARIABLES DE ENTORNO ---
# Esto garantiza que 'swaymsg' se comunique con el compositor al inicio.
# (Necesario para entornos Wayland/Sway que no heredan PATHs y sockets fácilmente)
export SWAYSOCK=$(ls /run/user/$UID/sway-ipc.*.sock)
export DISPLAY=":0"
# ----------------------------------------------------------

# SOLUCIÓN DE SINCRONIZACIÓN: Espera 3 segundos para que el socket IPC esté listo.
sleep 3

# Directorio de tus fondos de pantalla (asegúrate de que las imágenes estén aquí)
WALLPAPER_DIR="$HOME/.config/sway/wallpapers"

# Tiempo de espera en segundos (5 minutos = 300 segundos)
DELAY_TIME="300"

# Bucle infinito para la rotación de fondos
while true; do
    # 1. Obtener la ruta de una imagen aleatoria (JPG o PNG)
    IMAGE=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

    # 2. Verificar que se encontró una imagen y establecer el fondo
    if [ -n "$IMAGE" ]; then
        # Comando nativo de Sway: 'output *' aplica el fondo a todas las salidas.
        swaymsg output '*' bg "$IMAGE" fill
    fi

    # 3. Esperar 5 minutos antes de cambiar la siguiente imagen
    sleep $DELAY_TIME
done