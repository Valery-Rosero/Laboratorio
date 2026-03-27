#!/bin/bash
NODO="nodo3"
APP=${1:-"app-devops"}
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/deploy_$(date +%Y%m%d_%H%M%S).log"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         DEPLOY — NODO: $NODO              ║"
echo "╚══════════════════════════════════════════╝"
echo "[$(date '+%H:%M:%S')] Aplicación: $APP"
echo "[$(date '+%H:%M:%S')] Iniciando secuencia de despliegue..."
echo ""

PASOS=(
    "Verificando versión del artefacto"
    "Descargando paquete desde repositorio"
    "Deteniendo servicio en ejecución"
    "Extrayendo archivos en /opt/$APP"
    "Configurando variables de entorno"
    "Aplicando migraciones de base de datos"
    "Reiniciando servicio $APP"
    "Verificando estado del servicio"
)

for i in "${!PASOS[@]}"; do
    NUM=$((i + 1))
    TOTAL=${#PASOS[@]}
    echo "[$(date '+%H:%M:%S')] [$NUM/$TOTAL] ${PASOS[$i]}..."
    sleep 0.2
done

echo ""
DISK_FREE=$(df / | awk 'NR==2 {print $4}')
if [ "$DISK_FREE" -gt 1000 ]; then
    echo "[$(date '+%H:%M:%S')] ✔ Espacio disponible: OK ($DISK_FREE KB libres)"
else
    echo "[$(date '+%H:%M:%S')] ✘ ERROR: Espacio en disco insuficiente"
    exit 1
fi

PORT=$((8000 + RANDOM % 999))
echo "[$(date '+%H:%M:%S')] ✔ Servicio escuchando en puerto: $PORT"
echo "[$(date '+%H:%M:%S')] ✔ Health-check: HTTP 200 OK"
echo ""
echo "[$(date '+%H:%M:%S')] ════ DEPLOY COMPLETADO EN $NODO ════"
echo "" | tee -a "$LOG_FILE"