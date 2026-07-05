#!/usr/bin/env python3
"""
Quick syntax check for app.py
"""
import py_compile
import sys

try:
    py_compile.compile('app.py', doraise=True)
    print("✓ app.py syntax is valid")
except py_compile.PyCompileError as e:
    print(f"✗ Syntax error in app.py:")
    print(e)
    sys.exit(1)

try:
    py_compile.compile('db.py', doraise=True)
    print("✓ db.py syntax is valid")
except py_compile.PyCompileError as e:
    print(f"✗ Syntax error in db.py:")
    print(e)
    sys.exit(1)

print("\n✓ All Python files compile successfully")
