import subprocess
import os

class Executor:

    def __init__(self):
        print("[INFO] Inicializando Executor (modo local - simulación distribuida)\n")

        # Definición de grupos manual (ya no usamos JSON)
        self.groups = {
            "grupoA": ["nodo1", "nodo2"],
            "grupoB": ["nodo2", "nodo3"]
        }

    # =========================
    # EJECUCIÓN EN UN NODO
    # =========================
    def run_on_node(self, node, script):
        print(f"[INFO] Ejecutando script '{script}' en el nodo '{node}'")

        # Ruta local al script
        script_path = f"../nodes/{node}/cluster/scripts/{script}"

        if not os.path.exists(script_path):
            print(f"[ERROR] No existe el script en {node}: {script_path}")
            print("-" * 60)
            return

        # Ejecutar script
        result = subprocess.run(
            f"bash {script_path}",
            shell=True,
            capture_output=True,
            text=True
        )

        # Mostrar salida
        print(f"[RESULTADO] Nodo '{node}':\n{result.stdout}")

        # Manejo de errores
        if result.stderr:
            print(f"[ERROR] Nodo '{node}':\n{result.stderr}")

        # Estado
        if result.returncode == 0:
            print(f"[INFO] Ejecución exitosa en '{node}'")
        else:
            print(f"[ERROR] Fallo en '{node}' (código {result.returncode})")

        print("-" * 60)

    # =========================
    # EJECUCIÓN EN GRUPO
    # =========================
    def run_on_group(self, group, script):
        print(f"[INFO] Ejecutando '{script}' en el grupo '{group}'\n")

        if group not in self.groups:
            print(f"[ERROR] Grupo '{group}' no existe")
            return

        for node in self.groups[group]:
            self.run_on_node(node, script)

    # =========================
    # DEPLOY
    # =========================
    def deploy(self, app, group):
        print(f"[INFO] Desplegando aplicación '{app}' en el grupo '{group}'\n")

        script = "deploy.sh"
        self.run_on_group(group, script)

    # =========================
    # ACTUALIZACIÓN
    # =========================
    def update_group(self, group):
        print(f"[INFO] Actualizando grupo '{group}'\n")

        self.run_on_group(group, "update.sh")

    # =========================
    # SENSORES (SIMULADO)
    # =========================
    def get_sensor_data(self, node):
        print(f"[INFO] Consultando sensores en '{node}'")

        data = {
            "temp": 25,
            "cpu": 10
        }

        print(f"[INFO] Datos: {data}\n")

        return data