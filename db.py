import sqlite3
from pathlib import Path

from flask import current_app, g


BASE_DIR = Path(__file__).resolve().parent


def get_db():
    """Open one database connection per request."""
    if "db" not in g:
        g.db = sqlite3.connect(current_app.config["DATABASE"])
        g.db.row_factory = sqlite3.Row

    return g.db


def close_db(error=None):
    """Close the database connection at the end of a request."""
    db = g.pop("db", None)

    if db is not None:
        db.close()


def run_sql_file(db, filename):
    """Run a SQL script from the project folder."""
    sql_path = BASE_DIR / filename

    with sql_path.open("r", encoding="utf-8") as sql_file:
        db.executescript(sql_file.read())


def init_db():
    """Create a fresh database and load beginner-friendly seed data."""
    db = get_db()
    run_sql_file(db, "schema.sql")
    run_sql_file(db, "seed.sql")
    db.commit()


def init_app(app):
    """Register database helpers with the Flask app."""
    app.teardown_appcontext(close_db)

    @app.cli.command("init-db")
    def init_db_command():
        init_db()
        print("Initialized the Guitar Chord Hub database.")
