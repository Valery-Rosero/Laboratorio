#!/bin/bash
NODO=$(hostname)
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/update_$(date +%Y%m%d_%H%M%S).log"

echo "============================================"
echo "  UPDATE - NODO: $NODO"
echo "============================================"
echo "[$(date '+%H:%M:%S')] Iniciando actualización del sistema..."

# Simular apt-get update
PACKAGES=("curl" "git" "python3" "docker" "nginx" "openssh-server")
echo "[$(date '+%H:%M:%S')] Actualizando lista de paquetes..."
sleep 0.3

UPDATES_FOUND=$((RANDOM % 5 + 1))
echo "[$(date '+%H:%M:%S')] Se encontraron $UPDATES_FOUND actualizaciones disponibles"

for pkg in "${PACKAGES[@]:0:$UPDATES_FOUND}"; do
    echo "[$(date '+%H:%M:%S')] Actualizando paquete: $pkg..."
    sleep 0.2
done

# Verificar si requiere reinicio
REBOOT_REQUIRED=$((RANDOM % 2))
if [ "$REBOOT_REQUIRED" -eq 1 ]; then
    echo "[$(date '+%H:%M:%S')] ⚠ Se recomienda reiniciar el nodo"
else
    echo "[$(date '+%H:%M:%S')] ✔ No se requiere reinicio"
fi

echo "[$(date '+%H:%M:%S')] ✔ Actualización completada en $NODO"
echo "============================================" | tee -a "$LOG_FILE"