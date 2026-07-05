from pathlib import Path

from flask import Flask, abort, render_template, request, url_for

import db


BASE_DIR = Path(__file__).resolve().parent
STRING_NAMES = {
    6: "E",
    5: "A",
    4: "D",
    3: "G",
    2: "B",
    1: "e",
}


def prepare_position(row):
    """Convert one stored string position into diagram-friendly data."""
    position = dict(row)
    position["display_index"] = 7 - position["string_number"]
    position["string_name"] = STRING_NAMES[position["string_number"]]
    position["left_percent"] = (position["display_index"] - 1) * 20
    position["marker"] = ""

    if position["string_state"] == "muted":
        position["marker"] = "X"
    elif position["string_state"] == "open":
        position["marker"] = "O"
    elif position["fret_number"] is not None:
        position["top_percent"] = (position["fret_number"] - 0.5) * 20

    return position


def audio_filename_for_chord(chord):
    """Return the local audio filename used by the HTML5 audio player."""
    if chord["category"] == "Major":
        return f"{chord['name']}_major.wav"

    return f"{chord['name']}.wav"


def attach_audio(chord):
    chord["audio_filename"] = audio_filename_for_chord(chord)
    chord["audio_url"] = url_for(
        "static",
        filename=f"audio/chords/{chord['audio_filename']}",
    )
    return chord


def get_chord_positions(connection, chord_id):
    rows = connection.execute(
        """
        SELECT string_number, fret_number, finger_number, string_state
        FROM chord_positions
        WHERE chord_id = ?
        ORDER BY string_number DESC
        """,
        (chord_id,),
    ).fetchall()

    return [prepare_position(row) for row in rows]


def attach_positions(connection, chord_rows):
    chords = [dict(row) for row in chord_rows]

    if not chords:
        return chords

    chord_ids = [chord["id"] for chord in chords]
    placeholders = ", ".join("?" for _ in chord_ids)
    position_rows = connection.execute(
        f"""
        SELECT chord_id, string_number, fret_number, finger_number, string_state
        FROM chord_positions
        WHERE chord_id IN ({placeholders})
        ORDER BY chord_id, string_number DESC
        """,
        chord_ids,
    ).fetchall()

    positions_by_chord = {}
    for row in position_rows:
        position = prepare_position(row)
        positions_by_chord.setdefault(row["chord_id"], []).append(position)

    for chord in chords:
        chord["positions"] = positions_by_chord.get(chord["id"], [])
        attach_audio(chord)

    return chords


def get_ear_test_chords(connection):
    rows = connection.execute(
        """
        SELECT id, name, category, difficulty, description
        FROM chords
        ORDER BY
            CASE difficulty
                WHEN 'Beginner' THEN 1
                WHEN 'Easy' THEN 2
                WHEN 'Barre Practice' THEN 3
                ELSE 4
            END,
            CASE category
                WHEN 'Major' THEN 1
                WHEN 'Minor' THEN 2
                WHEN '7th' THEN 3
                ELSE 4
            END,
            sort_order,
            name
        """
    ).fetchall()

    return [attach_audio(dict(row)) for row in rows]


def ordered_progression_sql():
    return """
        SELECT GROUP_CONCAT(ordered_chords.name, ' - ')
        FROM (
            SELECT chords.name
            FROM song_chords
            JOIN chords ON song_chords.chord_id = chords.id
            WHERE song_chords.song_id = songs.id
            ORDER BY song_chords.order_index
        ) AS ordered_chords
    """


def create_app():
    app = Flask(__name__)
    app.config["DATABASE"] = BASE_DIR / "guitar_chord_hub.sqlite"

    db.init_app(app)

    @app.route("/")
    def home():
        connection = db.get_db()
        featured_rows = connection.execute(
            """
            SELECT id, name, category, difficulty, description
            FROM chords
            WHERE is_featured = 1
            ORDER BY sort_order
            LIMIT 6
            """
        ).fetchall()
        featured_chords = attach_positions(connection, featured_rows)

        learning_cards = [
            {
                "title": "Read Chord Diagrams",
                "text": "Learn how strings, frets, dots, open circles, and X marks work.",
                "url": "about_chords",
            },
            {
                "title": "Practice Rhythm",
                "text": "Use simple down and up strum patterns before adding speed.",
                "url": "rhythms",
            },
            {
                "title": "Play Songs",
                "text": "Try original practice songs that focus on chord changes only.",
                "url": "songs",
            },
            {
                "title": "Train Your Ear",
                "text": "Tap a sound, guess the chord, and build a beginner listening streak.",
                "url": "ear_test",
            },
        ]

        rhythms = connection.execute(
            """
            SELECT id, name, pattern, difficulty
            FROM rhythms
            ORDER BY id
            LIMIT 3
            """
        ).fetchall()

        return render_template(
            "home.html",
            featured_chords=featured_chords,
            learning_cards=learning_cards,
            rhythms=rhythms,
        )

    @app.route("/about-chords")
    def about_chords():
        return render_template("about_chords.html")

    @app.route("/chords")
    def chords():
        search_text = request.args.get("q", "").strip()
        selected_category = request.args.get("category", "").strip()
        selected_difficulty = request.args.get("difficulty", "").strip()

        sql = """
            SELECT id, name, category, difficulty, description
            FROM chords
            WHERE 1 = 1
        """
        params = []

        if search_text:
            sql += " AND name LIKE ?"
            params.append(f"%{search_text}%")

        if selected_category:
            sql += " AND category = ?"
            params.append(selected_category)

        if selected_difficulty:
            sql += " AND difficulty = ?"
            params.append(selected_difficulty)

        sql += """
            ORDER BY
                CASE category
                    WHEN 'Major' THEN 1
                    WHEN 'Minor' THEN 2
                    WHEN '7th' THEN 3
                    ELSE 4
                END,
                sort_order,
                name
        """

        connection = db.get_db()
        chord_rows = connection.execute(sql, params).fetchall()
        chord_rows = attach_positions(connection, chord_rows)
        categories = connection.execute(
            """
            SELECT DISTINCT category
            FROM chords
            ORDER BY
                CASE category
                    WHEN 'Major' THEN 1
                    WHEN 'Minor' THEN 2
                    WHEN '7th' THEN 3
                    ELSE 4
                END
            """
        ).fetchall()
        difficulties = connection.execute(
            """
            SELECT DISTINCT difficulty
            FROM chords
            ORDER BY
                CASE difficulty
                    WHEN 'Beginner' THEN 1
                    WHEN 'Easy' THEN 2
                    WHEN 'Barre Practice' THEN 3
                    ELSE 4
                END
            """
        ).fetchall()

        return render_template(
            "chords.html",
            chords=chord_rows,
            categories=categories,
            difficulties=difficulties,
            search_text=search_text,
            selected_category=selected_category,
            selected_difficulty=selected_difficulty,
        )

    @app.route("/chords/<int:chord_id>")
    def chord_detail(chord_id):
        connection = db.get_db()
        chord = connection.execute(
            """
            SELECT id, name, category, difficulty, description, practice_tip,
                   recommended_next_chord_id
            FROM chords
            WHERE id = ?
            """,
            (chord_id,),
        ).fetchone()

        if chord is None:
            abort(404)

        chord = attach_audio(dict(chord))
        positions = get_chord_positions(connection, chord_id)

        recommended_next = None
        if chord["recommended_next_chord_id"] is not None:
            recommended_next = connection.execute(
                """
                SELECT id, name, category, difficulty, description
                FROM chords
                WHERE id = ?
                """,
                (chord["recommended_next_chord_id"],),
            ).fetchone()
            if recommended_next is not None:
                recommended_next = attach_audio(dict(recommended_next))

        songs_using_chord = connection.execute(
            """
            SELECT DISTINCT songs.id, songs.title, songs.difficulty,
                   rhythms.name AS rhythm_name
            FROM songs
            JOIN song_chords ON songs.id = song_chords.song_id
            JOIN rhythms ON songs.rhythm_id = rhythms.id
            WHERE song_chords.chord_id = ?
            ORDER BY songs.title
            """,
            (chord_id,),
        ).fetchall()

        return render_template(
            "chord_detail.html",
            chord=chord,
            positions=positions,
            recommended_next=recommended_next,
            songs_using_chord=songs_using_chord,
        )

    @app.route("/songs")
    def songs():
        song_rows = db.get_db().execute(
            f"""
            SELECT songs.id, songs.title, songs.difficulty, songs.capo,
                   songs.description, rhythms.name AS rhythm_name,
                   rhythms.pattern AS rhythm_pattern,
                   ({ordered_progression_sql()}) AS chord_progression
            FROM songs
            JOIN rhythms ON songs.rhythm_id = rhythms.id
            ORDER BY songs.id
            """
        ).fetchall()

        return render_template("songs.html", songs=song_rows)

    @app.route("/songs/<int:song_id>")
    def song_detail(song_id):
        connection = db.get_db()
        song = connection.execute(
            """
            SELECT songs.id, songs.title, songs.difficulty, songs.capo,
                   songs.description, rhythms.name AS rhythm_name,
                   rhythms.pattern AS rhythm_pattern,
                   rhythms.practice_tip AS rhythm_tip
            FROM songs
            JOIN rhythms ON songs.rhythm_id = rhythms.id
            WHERE songs.id = ?
            """,
            (song_id,),
        ).fetchone()

        if song is None:
            abort(404)

        chord_rows = connection.execute(
            """
            SELECT chords.id, chords.name, chords.category, chords.difficulty,
                   song_chords.order_index
            FROM song_chords
            JOIN chords ON song_chords.chord_id = chords.id
            WHERE song_chords.song_id = ?
            ORDER BY song_chords.order_index
            """,
            (song_id,),
        ).fetchall()

        return render_template(
            "song_detail.html",
            song=song,
            chord_rows=chord_rows,
        )

    @app.route("/rhythms")
    def rhythms():
        rhythm_rows = db.get_db().execute(
            """
            SELECT id, name, difficulty, pattern, description, practice_tip
            FROM rhythms
            ORDER BY id
            """
        ).fetchall()

        return render_template("rhythms.html", rhythms=rhythm_rows)

    @app.route("/ear-test")
    def ear_test():
        chords = get_ear_test_chords(db.get_db())

        return render_template("ear_test.html", chords=chords)

    @app.errorhandler(404)
    def page_not_found(error):
        return render_template(
            "error.html",
            error_code=404,
            error_title="Page not found",
            error_message="The chord, song, or lesson you were looking for could not be found.",
        ), 404

    @app.errorhandler(500)
    def internal_error(error):
        app.logger.error(f"500 Internal Server Error: {error}", exc_info=True)
        return render_template(
            "error.html",
            error_code=500,
            error_title="Something went wrong",
            error_message="Please try again from the home page.",
        ), 500

    return app


app = create_app()
app.config["PROPAGATE_EXCEPTIONS"] = True
app.config["TRAP_EXCEPTION_DURING_REQUEST_HANDLING"] = True

import logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
app.logger.setLevel(logging.DEBUG)



if __name__ == "__main__":
    app.run(debug=True)