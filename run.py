#!/usr/bin/env python3
"""
Flask development server launcher with proper error logging.
Run this to start the server with full debug output.
"""
import sys
import os

# Add current directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Enable Flask development server
os.environ['FLASK_ENV'] = 'development'
os.environ['FLASK_APP'] = 'app.py'

try:
    from app import app
    
    print("=" * 60)
    print("FLASK DEVELOPMENT SERVER")
    print("=" * 60)
    print(f"Debug mode: {app.debug}")
    print(f"Database: {app.config.get('DATABASE')}")
    print("\nStarting server...")
    print("Press Ctrl+C to stop\n")
    
    # Run with debug enabled
    app.run(debug=True, use_reloader=False, host='127.0.0.1', port=5000)
    
except Exception as e:
    print(f"\nERROR starting app: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
