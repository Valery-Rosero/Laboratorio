import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from antlr4 import *
from antlr4.error.ErrorListener import ConsoleErrorListener
from parser.DevOpsDSLLexer import DevOpsDSLLexer
from parser.DevOpsDSLParser import DevOpsDSLParser
from interpreter.interpreter import Interpreter
from executor.executor import Executor


def show_tokens(file_path):
    input_stream = FileStream(file_path, encoding='utf-8')
    lexer = DevOpsDSLLexer(input_stream)
    stream = CommonTokenStream(lexer)
    stream.fill()

    token_names = DevOpsDSLLexer.symbolicNames

    print("=" * 65)
    print("                  [ FASE 1 — TOKENS GENERADOS ]")
    print("=" * 65)
    print(f"  {'#':<5} {'TIPO':<22} {'TEXTO':<25} {'LINEA'}")
    print("-" * 65)

    for i, token in enumerate(stream.tokens):
        if token.type == Token.EOF:
            tipo = "EOF"
        elif 0 < token.type < len(token_names) and token_names[token.type]:
            tipo = token_names[token.type]
        else:
            tipo = f"TOKEN_{token.type}"

        texto = repr(token.text)
        if len(texto) > 24:
            texto = texto[:21] + "..."

        print(f"  {i:<5} {tipo:<22} {texto:<25} {token.line}")

    print("=" * 65)
    print()


def show_tree(tree, parser):
    print("=" * 65)
    print("              [ FASE 2 - ARBOL SINTACTICO ]")
    print("=" * 65)

    tree_str = tree.toStringTree(recog=parser)

    indent = 0
    formatted = ""
    for char in tree_str:
        if char == '(':
            formatted += '\n' + '  ' * indent + '('
            indent += 1
        elif char == ')':
            indent -= 1
            formatted += ')'
        else:
            formatted += char

    print(formatted)
    print()
    print("=" * 65)
    print()


def main():
    print()
    print("=" * 65)
    print("       DSL DevOps - Interprete de Arquitectura Distribuida")
    print("=" * 65)
    print()

    file = "script.dsl"
    if len(sys.argv) > 1:
        file = sys.argv[1]

    if not os.path.exists(file):
        print(f"[ERROR] Archivo no encontrado: {file}")
        return

    print(f"[INFO] Archivo DSL cargado: {file}")
    print()

    # FASE 1 - TOKENS
    show_tokens(file)

    # FASE 2 - ARBOL
    input_stream = FileStream(file, encoding='utf-8')
    lexer = DevOpsDSLLexer(input_stream)
    tokens = CommonTokenStream(lexer)
    parser = DevOpsDSLParser(tokens)

    parser.removeErrorListeners()
    parser.addErrorListener(ConsoleErrorListener())

    tree = parser.program()
    show_tree(tree, parser)

    print("[INFO] Arbol sintactico construido correctamente.")
    print()

    # FASE 3 - EJECUCION
    print("=" * 65)
    print("       [ FASE 3 - INTERPRETACION Y EJECUCION DSL ]")
    print("=" * 65)
    print()

    executor = Executor()
    interpreter = Interpreter(executor)
    interpreter.visit(tree)


if __name__ == "__main__":
    main()
