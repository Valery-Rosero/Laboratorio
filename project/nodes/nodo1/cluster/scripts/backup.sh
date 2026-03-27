#!/bin/bash
NODO="nodo1"
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/backup_$TIMESTAMP.log"
BACKUP_NAME="backup_${NODO}_$TIMESTAMP"

echo "============================================"
echo "  BACKUP - NODO: $NODO"
echo "============================================"
echo "[$(date '+%H:%M:%S')] Iniciando proceso de backup..."

# Directorios a respaldar (simulado)
DIRS=("/etc/config" "/var/data" "/home/user/projects" "/opt/services")

for dir in "${DIRS[@]}"; do
    echo "[$(date '+%H:%M:%S')] Respaldando $dir..."
    sleep 0.2
done

# Simular compresión
echo "[$(date '+%H:%M:%S')] Comprimiendo archivos -> $BACKUP_NAME.tar.gz"
sleep 0.3

# Simular verificación
BACKUP_SIZE=$((RANDOM % 500 + 100))
echo "[$(date '+%H:%M:%S')] Verificando integridad del backup..."
sleep 0.2

if [ "$BACKUP_SIZE" -gt 50 ]; then
    echo "[$(date '+%H:%M:%S')] ✔ Backup verificado: ${BACKUP_SIZE}MB"
else
    echo "[$(date '+%H:%M:%S')] ✘ ERROR: Backup corrupto"
    exit 1
fi

echo "[$(date '+%H:%M:%S')] ✔ Backup completado: $BACKUP_NAME.tar.gz"
echo "============================================" | tee -a "$LOG_FILE"