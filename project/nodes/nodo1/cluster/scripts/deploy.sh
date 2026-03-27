#!/bin/bash
NODO="nodo1"
APP=${1:-"app-default"}
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/deploy_$(date +%Y%m%d_%H%M%S).log"

echo "============================================"
echo "  DEPLOY - NODO: $NODO"
echo "============================================"
echo "[$(date '+%H:%M:%S')] Iniciando despliegue de '$APP'..."

# Simulación de pasos de deploy
STEPS=("Verificando dependencias" "Descargando artefactos" "Deteniendo servicio anterior" "Copiando archivos al destino" "Configurando variables de entorno" "Iniciando nuevo servicio")

for i in "${!STEPS[@]}"; do
    echo "[$(date '+%H:%M:%S')] Paso $((i+1))/${#STEPS[@]}: ${STEPS[$i]}..."
    sleep 0.3
done

# Verificar espacio en disco (simulado)
DISK_FREE=$(df / | awk 'NR==2 {print $4}')
if [ "$DISK_FREE" -gt 1000 ]; then
    echo "[$(date '+%H:%M:%S')] ✔ Espacio en disco suficiente ($DISK_FREE KB libres)"
else
    echo "[$(date '+%H:%M:%S')] ✘ ERROR: Espacio insuficiente"
    exit 1
fi

echo "[$(date '+%H:%M:%S')] ✔ Deploy completado exitosamente en $NODO"
echo "============================================" | tee -a "$LOG_FILE"