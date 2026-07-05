PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS song_chords;
DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS chord_positions;
DROP TABLE IF EXISTS rhythms;
DROP TABLE IF EXISTS chords;

CREATE TABLE chords (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    difficulty TEXT NOT NULL,
    description TEXT NOT NULL,
    practice_tip TEXT NOT NULL,
    is_featured INTEGER NOT NULL DEFAULT 0,
    sort_order INTEGER NOT NULL DEFAULT 100,
    recommended_next_chord_id INTEGER,
    FOREIGN KEY (recommended_next_chord_id) REFERENCES chords (id)
);

CREATE TABLE chord_positions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    chord_id INTEGER NOT NULL,
    string_number INTEGER NOT NULL,
    fret_number INTEGER,
    finger_number INTEGER,
    string_state TEXT NOT NULL,
    FOREIGN KEY (chord_id) REFERENCES chords (id),
    UNIQUE (chord_id, string_number),
    CHECK (string_number BETWEEN 1 AND 6),
    CHECK (string_state IN ('muted', 'open', 'fretted'))
);

CREATE TABLE rhythms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    difficulty TEXT NOT NULL,
    pattern TEXT NOT NULL,
    description TEXT NOT NULL,
    practice_tip TEXT NOT NULL
);

CREATE TABLE songs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL UNIQUE,
    difficulty TEXT NOT NULL,
    capo TEXT NOT NULL,
    description TEXT NOT NULL,
    rhythm_id INTEGER NOT NULL,
    FOREIGN KEY (rhythm_id) REFERENCES rhythms (id)
);

CREATE TABLE song_chords (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    song_id INTEGER NOT NULL,
    chord_id INTEGER NOT NULL,
    order_index INTEGER NOT NULL,
    FOREIGN KEY (song_id) REFERENCES songs (id),
    FOREIGN KEY (chord_id) REFERENCES chords (id)
);
