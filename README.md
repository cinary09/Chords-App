# 🎸 Chords App

A modern web application for learning, exploring, and practicing guitar chords. Browse chord diagrams, listen to chord audio, improve your ear training skills, and expand your music theory knowledge through an intuitive interface.

Built with **Python**, **Flask**, **SQLite**, HTML, CSS, and JavaScript.

---

## ✨ Features

- 🎸 Browse common guitar chords
- 🔊 Play high-quality chord audio
- 🧠 Ear training exercises
- 📖 Detailed chord information pages
- 🔍 Search and explore chords
- 💾 SQLite database for chord storage
- 📱 Responsive and clean interface
- ⚡ Fast and lightweight Flask backend

---

## 📂 Project Structure

```
Chords App/
├── static/
│   ├── audio/
│   │   └── chords/
│   ├── js/
│   └── style.css
├── templates/
│   ├── base.html
│   ├── chords.html
│   ├── chord_detail.html
│   ├── ear_test.html
│   ├── about_chords.html
│   └── ...
├── app.py
├── run.py
├── db.py
├── schema.sql
├── seed.sql
├── requirements.txt
└── guitar_chord_hub.sqlite
```

---

## 🛠 Requirements

- Python **3.10+**
- Flask
- Werkzeug
- SQLite

Install all dependencies:

```bash
pip install -r requirements.txt
```

---

## ▶️ Running the Application

Start the development server:

```bash
python run.py
```

or

```bash
python app.py
```

Then open your browser and visit:

```
http://127.0.0.1:5000
```

---

## 🗄 Database

The application uses an SQLite database.

Database files:

```
guitar_chord_hub.sqlite
```

To recreate the database:

```bash
sqlite3 guitar_chord_hub.sqlite < schema.sql
sqlite3 guitar_chord_hub.sqlite < seed.sql
```

---

## 🎵 Included Features

- Guitar chord library
- Chord detail pages
- Audio playback
- Ear training mini-game
- Music theory information
- Database-driven content

---

## 📦 Technologies

- Python
- Flask
- Werkzeug
- SQLite
- HTML5
- CSS3
- JavaScript

---

## 📜 License

This project is licensed under the MIT License.

See the **LICENSE** file for additional information.

---

## 🤝 Contributing

Contributions are welcome!

If you'd like to improve the project:

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Open a Pull Request.

---

## 📸 Screenshots

Place screenshots inside:

```
static/screenshots/
```

Example:

```
static/screenshots/home.png
static/screenshots/chords.png
static/screenshots/ear-training.png
```

---

## 👨‍💻 Author

Created by **cinary09**

GitHub: https://github.com/cinary09

---

## ⭐ Support

If you found this project useful, consider giving it a ⭐ on GitHub. Your support helps encourage future improvements and new features.
