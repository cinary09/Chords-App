INSERT INTO chords (name, category, difficulty, description, practice_tip, is_featured, sort_order)
VALUES
('A', 'Major', 'Beginner', 'A major is a bright open chord that appears in many first songs.', 'Start your strum from the A string and let the high E string ring clearly.', 1, 10),
('B', 'Major', 'Barre Practice', 'B major is a movable barre chord shape that builds left-hand strength.', 'Keep the low E string muted and press the index finger evenly across fret 2.', 0, 20),
('C', 'Major', 'Beginner', 'C major has a warm, stable sound and is one of the most useful open chords.', 'Mute the low E string and keep the open G and high E strings ringing.', 1, 30),
('D', 'Major', 'Beginner', 'D major is a clear open chord played on the four highest strings.', 'Begin your strum on the open D string and avoid the two lowest strings.', 1, 40),
('E', 'Major', 'Beginner', 'E major is a full open chord that uses all six strings.', 'Relax the wrist and check that both open E strings sound clean.', 0, 50),
('F', 'Major', 'Barre Practice', 'F major is a classic first barre challenge for beginner guitarists.', 'Try the smaller four-string F first, then build up to the full barre shape.', 0, 60),
('G', 'Major', 'Beginner', 'G major sounds big and open because it uses all six strings.', 'Keep the fingers tall so the open D, G, and B strings can ring.', 1, 70),

('Am', 'Minor', 'Beginner', 'A minor sounds gentle and moody while using a comfortable open shape.', 'Compare Am with C major to hear how one finger changes the mood.', 1, 110),
('Bm', 'Minor', 'Barre Practice', 'B minor is a useful movable minor shape with a focused sound.', 'Mute the low E string and practice pressing each note one at a time.', 0, 120),
('Cm', 'Minor', 'Barre Practice', 'C minor is a higher barre shape with a dramatic minor color.', 'Keep the thumb behind the neck and use slow pressure before strumming.', 0, 130),
('Dm', 'Minor', 'Beginner', 'D minor is a small open chord with a sad, expressive sound.', 'Start from the D string and keep the first finger curved on the high E string.', 0, 140),
('Em', 'Minor', 'Beginner', 'E minor is one of the easiest guitar chords and uses all six strings.', 'Use light pressure with two fingers and let every open string ring.', 1, 150),
('Fm', 'Minor', 'Barre Practice', 'F minor uses a full barre and is a good strength-building chord.', 'Practice the index finger barre by itself before adding the other fingers.', 0, 160),
('Gm', 'Minor', 'Barre Practice', 'G minor is a movable minor barre shape with a strong, dark sound.', 'Keep the barre close to fret 3 and listen for clean notes on the thin strings.', 0, 170),

('A7', '7th', 'Beginner', 'A7 is an open dominant seventh chord with a bluesy, relaxed sound.', 'Let the open G string ring between the two fretted notes.', 1, 210),
('C7', '7th', 'Easy', 'C7 adds a bluesy pull to the familiar C major shape.', 'Build it from C major, then add the pinky on the G string.', 0, 220),
('D7', '7th', 'Beginner', 'D7 is a small open chord often used before resolving to G.', 'Place the first finger on the B string first, then add the two second-fret notes.', 0, 230),
('E7', '7th', 'Beginner', 'E7 is an easy open chord with a strong blues and rock flavor.', 'Strum all six strings and let the open D string create the seventh sound.', 0, 240),
('G7', '7th', 'Beginner', 'G7 is a bright open chord that naturally wants to move back to C.', 'Use a relaxed hand shape and listen for the high E string on fret 1.', 0, 250);

UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'D') WHERE name = 'A';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'E') WHERE name = 'B';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'G') WHERE name = 'C';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'G') WHERE name = 'D';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'A') WHERE name = 'E';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'C') WHERE name = 'F';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'Em') WHERE name = 'G';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'C') WHERE name = 'Am';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'G') WHERE name = 'Bm';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'Gm') WHERE name = 'Cm';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'Am') WHERE name = 'Dm';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'G') WHERE name = 'Em';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'F') WHERE name = 'Fm';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'Cm') WHERE name = 'Gm';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'D7') WHERE name = 'A7';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'F') WHERE name = 'C7';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'G') WHERE name = 'D7';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'A') WHERE name = 'E7';
UPDATE chords SET recommended_next_chord_id = (SELECT id FROM chords WHERE name = 'C') WHERE name = 'G7';

INSERT INTO chord_positions (chord_id, string_number, fret_number, finger_number, string_state)
VALUES
((SELECT id FROM chords WHERE name = 'A'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'A'), 5, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'A'), 4, 2, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'A'), 3, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'A'), 2, 2, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'A'), 1, NULL, NULL, 'open'),

((SELECT id FROM chords WHERE name = 'B'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'B'), 5, 2, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'B'), 4, 4, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'B'), 3, 4, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'B'), 2, 4, 4, 'fretted'),
((SELECT id FROM chords WHERE name = 'B'), 1, 2, 1, 'fretted'),

((SELECT id FROM chords WHERE name = 'C'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'C'), 5, 3, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'C'), 4, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'C'), 3, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'C'), 2, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'C'), 1, NULL, NULL, 'open'),

((SELECT id FROM chords WHERE name = 'D'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'D'), 5, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'D'), 4, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'D'), 3, 2, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'D'), 2, 3, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'D'), 1, 2, 2, 'fretted'),

((SELECT id FROM chords WHERE name = 'E'), 6, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'E'), 5, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'E'), 4, 2, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'E'), 3, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'E'), 2, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'E'), 1, NULL, NULL, 'open'),

((SELECT id FROM chords WHERE name = 'F'), 6, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'F'), 5, 3, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'F'), 4, 3, 4, 'fretted'),
((SELECT id FROM chords WHERE name = 'F'), 3, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'F'), 2, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'F'), 1, 1, 1, 'fretted'),

((SELECT id FROM chords WHERE name = 'G'), 6, 3, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'G'), 5, 2, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'G'), 4, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'G'), 3, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'G'), 2, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'G'), 1, 3, 3, 'fretted'),

((SELECT id FROM chords WHERE name = 'Am'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'Am'), 5, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'Am'), 4, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'Am'), 3, 2, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'Am'), 2, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Am'), 1, NULL, NULL, 'open'),

((SELECT id FROM chords WHERE name = 'Bm'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'Bm'), 5, 2, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Bm'), 4, 4, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'Bm'), 3, 4, 4, 'fretted'),
((SELECT id FROM chords WHERE name = 'Bm'), 2, 3, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'Bm'), 1, 2, 1, 'fretted'),

((SELECT id FROM chords WHERE name = 'Cm'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'Cm'), 5, 3, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Cm'), 4, 5, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'Cm'), 3, 5, 4, 'fretted'),
((SELECT id FROM chords WHERE name = 'Cm'), 2, 4, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'Cm'), 1, 3, 1, 'fretted'),

((SELECT id FROM chords WHERE name = 'Dm'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'Dm'), 5, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'Dm'), 4, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'Dm'), 3, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'Dm'), 2, 3, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'Dm'), 1, 1, 1, 'fretted'),

((SELECT id FROM chords WHERE name = 'Em'), 6, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'Em'), 5, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'Em'), 4, 2, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'Em'), 3, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'Em'), 2, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'Em'), 1, NULL, NULL, 'open'),

((SELECT id FROM chords WHERE name = 'Fm'), 6, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Fm'), 5, 3, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'Fm'), 4, 3, 4, 'fretted'),
((SELECT id FROM chords WHERE name = 'Fm'), 3, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Fm'), 2, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Fm'), 1, 1, 1, 'fretted'),

((SELECT id FROM chords WHERE name = 'Gm'), 6, 3, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Gm'), 5, 5, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'Gm'), 4, 5, 4, 'fretted'),
((SELECT id FROM chords WHERE name = 'Gm'), 3, 3, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Gm'), 2, 3, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'Gm'), 1, 3, 1, 'fretted'),

((SELECT id FROM chords WHERE name = 'A7'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'A7'), 5, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'A7'), 4, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'A7'), 3, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'A7'), 2, 2, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'A7'), 1, NULL, NULL, 'open'),

((SELECT id FROM chords WHERE name = 'C7'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'C7'), 5, 3, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'C7'), 4, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'C7'), 3, 3, 4, 'fretted'),
((SELECT id FROM chords WHERE name = 'C7'), 2, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'C7'), 1, NULL, NULL, 'open'),

((SELECT id FROM chords WHERE name = 'D7'), 6, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'D7'), 5, NULL, NULL, 'muted'),
((SELECT id FROM chords WHERE name = 'D7'), 4, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'D7'), 3, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'D7'), 2, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'D7'), 1, 2, 3, 'fretted'),

((SELECT id FROM chords WHERE name = 'E7'), 6, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'E7'), 5, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'E7'), 4, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'E7'), 3, 1, 1, 'fretted'),
((SELECT id FROM chords WHERE name = 'E7'), 2, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'E7'), 1, NULL, NULL, 'open'),

((SELECT id FROM chords WHERE name = 'G7'), 6, 3, 3, 'fretted'),
((SELECT id FROM chords WHERE name = 'G7'), 5, 2, 2, 'fretted'),
((SELECT id FROM chords WHERE name = 'G7'), 4, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'G7'), 3, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'G7'), 2, NULL, NULL, 'open'),
((SELECT id FROM chords WHERE name = 'G7'), 1, 1, 1, 'fretted');

INSERT INTO rhythms (name, difficulty, pattern, description, practice_tip)
VALUES
('Beginner Pop Pattern', 'Beginner', '↓ ↓ ↑ ↑ ↓ ↑', 'A friendly six-strum pattern used in many simple pop-style progressions.', 'Count 1 2 and and 4 and. Keep the hand moving even on the spaces.'),
('Basic Rock Pattern', 'Beginner', '↓ ↓ ↓ ↑ ↓ ↑', 'A steady pattern with strong down strums and a small lift from up strums.', 'Accent the first down strum of each chord to make the groove feel grounded.'),
('Slow Ballad Pattern', 'Beginner', '↓   ↓ ↑   ↓ ↑', 'A spacious pattern for slower songs and clean chord changes.', 'Let the chord ring between strums and change shapes before the next downbeat.');

INSERT INTO songs (title, difficulty, capo, description, rhythm_id)
VALUES
('Sunrise Strum', 'Beginner', 'No capo', 'A warm first progression for practicing C, G, Am, and F.', (SELECT id FROM rhythms WHERE name = 'Beginner Pop Pattern')),
('Campfire Loop', 'Beginner', 'No capo', 'A relaxed four-chord loop with open, ringing shapes.', (SELECT id FROM rhythms WHERE name = 'Beginner Pop Pattern')),
('Blue Sky Jam', 'Beginner', 'No capo', 'A bright major progression for steady down-up practice.', (SELECT id FROM rhythms WHERE name = 'Basic Rock Pattern')),
('Quiet Porch', 'Easy', 'No capo', 'A softer minor-to-major progression for slow changes.', (SELECT id FROM rhythms WHERE name = 'Slow Ballad Pattern')),
('River Walk', 'Easy', 'No capo', 'A practice song that introduces Bm inside a familiar progression.', (SELECT id FROM rhythms WHERE name = 'Beginner Pop Pattern')),
('Coffee House Waltz', 'Easy', 'No capo', 'A gentle loop for clean C, Am, F, and G changes.', (SELECT id FROM rhythms WHERE name = 'Slow Ballad Pattern')),
('Open Highway', 'Beginner', 'No capo', 'A simple rock-style loop using strong open major chords.', (SELECT id FROM rhythms WHERE name = 'Basic Rock Pattern')),
('Moonlit Steps', 'Beginner', 'No capo', 'A calm progression for practicing Em, C, G, and D.', (SELECT id FROM rhythms WHERE name = 'Slow Ballad Pattern')),
('Saturday Shuffle', 'Easy', 'No capo', 'A bluesy seventh-chord practice loop without any lyrics.', (SELECT id FROM rhythms WHERE name = 'Basic Rock Pattern')),
('Porch Swing', 'Easy', 'No capo', 'A mellow seventh-chord progression that resolves back to C.', (SELECT id FROM rhythms WHERE name = 'Slow Ballad Pattern'));

INSERT INTO song_chords (song_id, chord_id, order_index)
VALUES
((SELECT id FROM songs WHERE title = 'Sunrise Strum'), (SELECT id FROM chords WHERE name = 'C'), 1),
((SELECT id FROM songs WHERE title = 'Sunrise Strum'), (SELECT id FROM chords WHERE name = 'G'), 2),
((SELECT id FROM songs WHERE title = 'Sunrise Strum'), (SELECT id FROM chords WHERE name = 'Am'), 3),
((SELECT id FROM songs WHERE title = 'Sunrise Strum'), (SELECT id FROM chords WHERE name = 'F'), 4),

((SELECT id FROM songs WHERE title = 'Campfire Loop'), (SELECT id FROM chords WHERE name = 'G'), 1),
((SELECT id FROM songs WHERE title = 'Campfire Loop'), (SELECT id FROM chords WHERE name = 'D'), 2),
((SELECT id FROM songs WHERE title = 'Campfire Loop'), (SELECT id FROM chords WHERE name = 'Em'), 3),
((SELECT id FROM songs WHERE title = 'Campfire Loop'), (SELECT id FROM chords WHERE name = 'C'), 4),

((SELECT id FROM songs WHERE title = 'Blue Sky Jam'), (SELECT id FROM chords WHERE name = 'A'), 1),
((SELECT id FROM songs WHERE title = 'Blue Sky Jam'), (SELECT id FROM chords WHERE name = 'E'), 2),
((SELECT id FROM songs WHERE title = 'Blue Sky Jam'), (SELECT id FROM chords WHERE name = 'D'), 3),
((SELECT id FROM songs WHERE title = 'Blue Sky Jam'), (SELECT id FROM chords WHERE name = 'A'), 4),

((SELECT id FROM songs WHERE title = 'Quiet Porch'), (SELECT id FROM chords WHERE name = 'Am'), 1),
((SELECT id FROM songs WHERE title = 'Quiet Porch'), (SELECT id FROM chords WHERE name = 'C'), 2),
((SELECT id FROM songs WHERE title = 'Quiet Porch'), (SELECT id FROM chords WHERE name = 'G'), 3),
((SELECT id FROM songs WHERE title = 'Quiet Porch'), (SELECT id FROM chords WHERE name = 'Em'), 4),

((SELECT id FROM songs WHERE title = 'River Walk'), (SELECT id FROM chords WHERE name = 'D'), 1),
((SELECT id FROM songs WHERE title = 'River Walk'), (SELECT id FROM chords WHERE name = 'A'), 2),
((SELECT id FROM songs WHERE title = 'River Walk'), (SELECT id FROM chords WHERE name = 'Bm'), 3),
((SELECT id FROM songs WHERE title = 'River Walk'), (SELECT id FROM chords WHERE name = 'G'), 4),

((SELECT id FROM songs WHERE title = 'Coffee House Waltz'), (SELECT id FROM chords WHERE name = 'C'), 1),
((SELECT id FROM songs WHERE title = 'Coffee House Waltz'), (SELECT id FROM chords WHERE name = 'Am'), 2),
((SELECT id FROM songs WHERE title = 'Coffee House Waltz'), (SELECT id FROM chords WHERE name = 'F'), 3),
((SELECT id FROM songs WHERE title = 'Coffee House Waltz'), (SELECT id FROM chords WHERE name = 'G'), 4),

((SELECT id FROM songs WHERE title = 'Open Highway'), (SELECT id FROM chords WHERE name = 'E'), 1),
((SELECT id FROM songs WHERE title = 'Open Highway'), (SELECT id FROM chords WHERE name = 'A'), 2),
((SELECT id FROM songs WHERE title = 'Open Highway'), (SELECT id FROM chords WHERE name = 'D'), 3),
((SELECT id FROM songs WHERE title = 'Open Highway'), (SELECT id FROM chords WHERE name = 'E'), 4),

((SELECT id FROM songs WHERE title = 'Moonlit Steps'), (SELECT id FROM chords WHERE name = 'Em'), 1),
((SELECT id FROM songs WHERE title = 'Moonlit Steps'), (SELECT id FROM chords WHERE name = 'C'), 2),
((SELECT id FROM songs WHERE title = 'Moonlit Steps'), (SELECT id FROM chords WHERE name = 'G'), 3),
((SELECT id FROM songs WHERE title = 'Moonlit Steps'), (SELECT id FROM chords WHERE name = 'D'), 4),

((SELECT id FROM songs WHERE title = 'Saturday Shuffle'), (SELECT id FROM chords WHERE name = 'A7'), 1),
((SELECT id FROM songs WHERE title = 'Saturday Shuffle'), (SELECT id FROM chords WHERE name = 'D7'), 2),
((SELECT id FROM songs WHERE title = 'Saturday Shuffle'), (SELECT id FROM chords WHERE name = 'E7'), 3),
((SELECT id FROM songs WHERE title = 'Saturday Shuffle'), (SELECT id FROM chords WHERE name = 'A7'), 4),

((SELECT id FROM songs WHERE title = 'Porch Swing'), (SELECT id FROM chords WHERE name = 'C7'), 1),
((SELECT id FROM songs WHERE title = 'Porch Swing'), (SELECT id FROM chords WHERE name = 'F'), 2),
((SELECT id FROM songs WHERE title = 'Porch Swing'), (SELECT id FROM chords WHERE name = 'G7'), 3),
((SELECT id FROM songs WHERE title = 'Porch Swing'), (SELECT id FROM chords WHERE name = 'C'), 4);
