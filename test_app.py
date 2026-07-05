#!/usr/bin/env python3
"""
Diagnostic script to test the Flask app and identify issues.
"""
import sys
import traceback

print("=" * 60)
print("FLASK APP DIAGNOSTIC TEST")
print("=" * 60)

# Step 1: Check imports
print("\n[1] Testing imports...")
try:
    from pathlib import Path
    print("  ✓ pathlib.Path")
    
    from flask import Flask, abort, render_template, request, url_for
    print("  ✓ Flask")
    
    import db
    print("  ✓ db module")
    
    print("\n✓ All imports successful!")
except ImportError as e:
    print(f"  ✗ Import Error: {e}")
    traceback.print_exc()
    sys.exit(1)

# Step 2: Check database file
print("\n[2] Checking database file...")
BASE_DIR = Path(__file__).resolve().parent
db_path = BASE_DIR / "guitar_chord_hub.sqlite"
if db_path.exists():
    print(f"  ✓ Database file exists: {db_path}")
    print(f"    Size: {db_path.stat().st_size} bytes")
else:
    print(f"  ✗ Database file NOT FOUND: {db_path}")
    print("    NOTE: You may need to initialize the database")

# Step 3: Create app
print("\n[3] Creating Flask app...")
try:
    import app as app_module
    flask_app = app_module.app
    print("  ✓ Flask app created successfully")
    print(f"    Debug mode: {flask_app.debug}")
    print(f"    Database config: {flask_app.config.get('DATABASE')}")
except Exception as e:
    print(f"  ✗ Error creating app: {e}")
    traceback.print_exc()
    sys.exit(1)

# Step 4: Test app context
print("\n[4] Testing app context and database...")
try:
    with flask_app.app_context():
        connection = db.get_db()
        
        # Test if database is initialized
        cursor = connection.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()
        
        if not tables:
            print("  ⚠ Warning: Database exists but no tables found")
            print("    The database may not be initialized. Run: flask init-db")
        else:
            print(f"  ✓ Database has {len(tables)} tables:")
            for table in tables:
                print(f"      - {table[0]}")
        
        # Try fetching some chords
        try:
            chords = connection.execute("SELECT COUNT(*) FROM chords").fetchone()
            print(f"  ✓ Chords table accessible: {chords[0]} chords in database")
        except Exception as e:
            print(f"  ✗ Error accessing chords: {e}")
            
except Exception as e:
    print(f"  ✗ Error in app context: {e}")
    traceback.print_exc()

# Step 5: Test routes
print("\n[5] Testing routes...")
try:
    with flask_app.test_client() as client:
        routes_to_test = ["/", "/about-chords", "/chords", "/rhythms", "/songs", "/ear-test"]
        
        for route in routes_to_test:
            try:
                response = client.get(route)
                status = response.status_code
                if status == 200:
                    print(f"  ✓ {route:20} -> {status}")
                else:
                    print(f"  ✗ {route:20} -> {status}")
                    if status == 500:
                        print(f"    Response: {response.get_data(as_text=True)[:200]}")
            except Exception as e:
                print(f"  ✗ {route:20} -> ERROR: {e}")
                
except Exception as e:
    print(f"  ✗ Error testing routes: {e}")
    traceback.print_exc()

print("\n" + "=" * 60)
print("DIAGNOSTIC TEST COMPLETE")
print("=" * 60)
