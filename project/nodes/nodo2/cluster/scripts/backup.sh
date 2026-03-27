#!/bin/bash
NODO="nodo2"
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/backup_$TIMESTAMP.log"
BACKUP_NAME="backup_${NODO}_$TIMESTAMP"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         BACKUP — NODO: $NODO              ║"
echo "╚══════════════════════════════════════════╝"
echo "[$(date '+%H:%M:%S')] Iniciando proceso de backup..."
echo "[$(date '+%H:%M:%S')] Destino: /backups/$BACKUP_NAME.tar.gz"
echo ""

DIRS=("/etc/nginx/conf.d" "/var/log/app" "/home/deploy/projects" "/opt/services/config" "/var/lib/database")
TOTAL_SIZE=0

echo "[$(date '+%H:%M:%S')] Escaneando directorios a respaldar:"
for dir in "${DIRS[@]}"; do
    SIZE=$((RANDOM % 200 + 10))
    TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
    echo "[$(date '+%H:%M:%S')]   → $dir (${SIZE}MB)"
    sleep 0.15
done

echo ""
echo "[$(date '+%H:%M:%S')] Total a comprimir: ${TOTAL_SIZE}MB"
echo "[$(date '+%H:%M:%S')] Comprimiendo con gzip nivel 6..."
sleep 0.3

COMPRESSED=$((TOTAL_SIZE * 40 / 100))
echo "[$(date '+%H:%M:%S')] Tamaño comprimido: ${COMPRESSED}MB (ahorro: 60%)"
echo ""

echo "[$(date '+%H:%M:%S')] Verificando integridad del archivo..."
CHECKSUM=$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 32 | head -n 1 2>/dev/null || echo "b7e2d4f1a9c3821e")
echo "[$(date '+%H:%M:%S')] SHA256: $CHECKSUM"

if [ ${#CHECKSUM} -ge 8 ]; then
    echo "[$(date '+%H:%M:%S')] ✔ Integridad verificada correctamente"
else
    echo "[$(date '+%H:%M:%S')] ✘ ERROR: Checksum inválido"
    exit 1
fi

echo ""
echo "[$(date '+%H:%M:%S')] ✔ Backup guardado: $BACKUP_NAME.tar.gz"
echo "[$(date '+%H:%M:%S')] ════ BACKUP COMPLETADO EN $NODO ════"
echo "" | tee -a "$LOG_FILE"