#!/bin/bash
NODO="nodo3a"
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/update_$(date +%Y%m%d_%H%M%S).log"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         UPDATE — NODO: $NODO              ║"
echo "╚══════════════════════════════════════════╝"
echo "[$(date '+%H:%M:%S')] Iniciando actualización del sistema..."
echo ""

echo "[$(date '+%H:%M:%S')] Actualizando índices de paquetes..."
SOURCES=("main" "security" "updates" "backports")
for src in "${SOURCES[@]}"; do
    echo "[$(date '+%H:%M:%S')]   → Leyendo lista desde: $src"
    sleep 0.1
done

echo ""
PACKAGES=("curl:7.88.1" "git:2.43.0" "python3:3.11.8" "docker-ce:24.0.7" "nginx:1.25.3" "openssh-server:9.6p1")
TOTAL=${#PACKAGES[@]}
UPDATES=$((RANDOM % 4 + 2))
[ $UPDATES -gt $TOTAL ] && UPDATES=$TOTAL

echo "[$(date '+%H:%M:%S')] Paquetes con actualizaciones disponibles: $UPDATES"
echo ""

for i in $(seq 0 $((UPDATES - 1))); do
    PKG="${PACKAGES[$i]%%:*}"
    VER="${PACKAGES[$i]##*:}"
    echo "[$(date '+%H:%M:%S')] Actualizando: $PKG → v$VER"
    sleep 0.2
done

echo ""
KERNEL_UPDATE=$((RANDOM % 2))
if [ "$KERNEL_UPDATE" -eq 1 ]; then
    echo "[$(date '+%H:%M:%S')] ⚠  Actualización de kernel detectada"
    echo "[$(date '+%H:%M:%S')] ⚠  Se requiere reinicio para aplicar cambios"
else
    echo "[$(date '+%H:%M:%S')] ✔ No se requiere reinicio del sistema"
fi

echo ""
echo "[$(date '+%H:%M:%S')] ✔ $UPDATES paquete(s) actualizados correctamente"
echo "[$(date '+%H:%M:%S')] ════ UPDATE COMPLETADO EN $NODO ════"
echo "" | tee -a "$LOG_FILE"