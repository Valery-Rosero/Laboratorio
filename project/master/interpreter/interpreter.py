from parser.DevOpsDSLVisitor import DevOpsDSLVisitor

class Interpreter(DevOpsDSLVisitor):

    def __init__(self, executor):
        self.executor = executor

    def visitProgram(self, ctx):
        print("[INTERPRETER] Iniciando recorrido del arbol DSL...\n")
        for stmt in ctx.statement():
            self.visit(stmt)
        print("\n[INTERPRETER] Recorrido finalizado.")

    def visitStatement(self, ctx):
        return self.visitChildren(ctx)

    def visitNodeCommand(self, ctx):
        node = ctx.ID().getText()
        script = ctx.STRING().getText().strip('"')
        print(f"[DSL -> NODE] {node}.run(\"{script}\")")
        self.executor.run_on_node(node, script)

    def visitGroupCommand(self, ctx):
        group = ctx.ID().getText()
        print(f"[DSL -> GROUP] {group}.update()")
        self.executor.update_group(group)

    def visitDeployCommand(self, ctx):
        app   = ctx.ID(0).getText()
        group = ctx.ID(1).getText()
        print(f"[DSL -> DEPLOY] deploy {app} to {group}")
        self.executor.deploy(app, group)

    def visitRule(self, ctx):
        print("[DSL -> RULE] Evaluando regla condicional...")
        if self._evaluate_condition(ctx.condition()):
            print("[DSL -> RULE] Condicion VERDADERA -> ejecutando accion\n")
            self.visit(ctx.action())
        else:
            print("[DSL -> RULE] Condicion FALSA -> accion omitida\n")

    def _evaluate_condition(self, ctx):
        node     = ctx.ID(0).getText()
        metric   = ctx.ID(1).getText()
        operator = ctx.comparator().getText()
        value    = int(ctx.NUMBER().getText())
        print(f"[DSL -> RULE] Condicion: {node}.{metric} {operator} {value}")
        data    = self.executor.get_sensor_data(node)
        current = data.get(metric, 0)
        print(f"[DSL -> RULE] Valor actual de '{metric}' en '{node}': {current}")
        ops = {
            ">":  lambda a, b: a > b,
            "<":  lambda a, b: a < b,
            "==": lambda a, b: a == b,
            ">=": lambda a, b: a >= b,
            "<=": lambda a, b: a <= b,
        }
        result = ops.get(operator, lambda a, b: False)(current, value)
        print(f"[DSL -> RULE] Resultado: {current} {operator} {value} = {result}")
        return result

    def visitAction(self, ctx):
        if ctx.STRING() is None:
            action = ctx.ID().getText()
            print(f"[DSL -> ACTION] Ejecutando funcion: {action}()")
            self.executor.trigger_alert(action)
        else:
            node   = ctx.ID().getText()
            script = ctx.STRING().getText().strip('"')
            print(f"[DSL -> ACTION] {node}.run(\"{script}\")")
            self.executor.run_on_node(node, script)

    def visitParallelBlock(self, ctx):
        import threading
        print("[DSL -> PARALLEL] Iniciando ejecucion en paralelo...")
        print(f"[DSL -> PARALLEL] Comandos: {len(ctx.statement())}\n")
        threads = []
        for stmt in ctx.statement():
            t = threading.Thread(target=self.visit, args=(stmt,))
            t.start()
            threads.append(t)
        for t in threads:
            t.join()
        print("\n[DSL -> PARALLEL] Todos los hilos finalizaron.")
