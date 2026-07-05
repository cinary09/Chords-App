(function () {
    "use strict";

    const tutorialText = "This is an Am chord. Listen carefully to its darker emotional sound.";
    let chords = [];
    let currentChord = null;
    let currentOptions = [];
    let score = 0;
    let streak = 0;
    let questionNumber = 0;
    let tutorialActive = true;
    let answered = false;

    function shuffle(items) {
        return items
            .map((item) => ({ item, sort: Math.random() }))
            .sort((a, b) => a.sort - b.sort)
            .map((entry) => entry.item);
    }

    function normalize(chord) {
        return {
            id: chord.id,
            name: chord.name,
            category: chord.category,
            difficulty: chord.difficulty,
            audioUrl: chord.audio_url || chord.audioUrl
        };
    }

    function questionPool() {
        if (tutorialActive || questionNumber <= 4) {
            return chords.filter((chord) => chord.difficulty === "Beginner");
        }

        if (questionNumber <= 8) {
            return chords.filter((chord) => {
                return chord.difficulty === "Beginner" || chord.difficulty === "Easy";
            });
        }

        return chords;
    }

    function buildOptions(correctChord) {
        const pool = questionPool().filter((chord) => chord.name !== correctChord.name);
        const distractors = shuffle(pool).slice(0, 3);
        return shuffle([correctChord, ...distractors]);
    }

    function randomChord() {
        const pool = questionPool();
        return shuffle(pool)[0] || chords[0];
    }

    function renderScore(root) {
        root.querySelector("[data-score]").textContent = score;
        root.querySelector("[data-streak]").textContent = streak;
    }

    function renderOptions(root) {
        const answerGrid = root.querySelector("[data-answer-grid]");
        answerGrid.innerHTML = currentOptions.map((chord) => {
            return `
                <button
                    class="answer-option"
                    type="button"
                    data-answer-name="${chord.name}"
                >
                    <strong>${chord.name}</strong>
                    <span>${chord.category}</span>
                </button>
            `;
        }).join("");
    }

    function playCurrentChord() {
        if (!currentChord || !window.ChordAudio) {
            return;
        }

        window.ChordAudio.playChord(currentChord);
    }

    function startQuestion(root) {
        answered = false;
        root.classList.remove("is-correct", "is-wrong");

        if (tutorialActive) {
            currentChord = chords.find((chord) => chord.name === "Am") || chords[0];
            root.querySelector("[data-question-label]").textContent = "Tutorial round";
            root.querySelector("[data-ear-title]").textContent = "Listen for Am";
            root.querySelector("[data-feedback]").textContent = tutorialText;
        } else {
            currentChord = randomChord();
            root.querySelector("[data-question-label]").textContent = `Question ${questionNumber}`;
            root.querySelector("[data-ear-title]").textContent = "Which chord is this?";
            root.querySelector("[data-feedback]").textContent = "Play the sound, then choose the chord you hear.";
        }

        currentOptions = buildOptions(currentChord);
        renderOptions(root);
        root.querySelector("[data-next-question]").disabled = true;
        root.querySelector("[data-play-question]").innerHTML = tutorialActive
            ? '<span class="button-sound-icon" aria-hidden="true">♪</span>Play Am Sound'
            : '<span class="button-sound-icon" aria-hidden="true">♪</span>Play Random Sound';
    }

    function answerQuestion(root, selectedName) {
        if (answered) {
            return;
        }

        answered = true;
        const correct = selectedName === currentChord.name;

        if (!tutorialActive) {
            if (correct) {
                score += 1;
                streak += 1;
            } else {
                streak = 0;
            }
        }

        root.classList.toggle("is-correct", correct);
        root.classList.toggle("is-wrong", !correct);
        renderScore(root);

        root.querySelectorAll(".answer-option").forEach((button) => {
            const isCorrectButton = button.dataset.answerName === currentChord.name;
            const isSelectedButton = button.dataset.answerName === selectedName;
            button.disabled = true;
            button.classList.toggle("correct-answer", isCorrectButton);
            button.classList.toggle("wrong-answer", isSelectedButton && !correct);
        });

        root.querySelector("[data-feedback]").textContent = correct
            ? `${currentChord.name} is right. Nice listening.`
            : `That was ${currentChord.name}. Replay it and notice the chord color.`;
        root.querySelector("[data-next-question]").disabled = false;
    }

    function nextQuestion(root) {
        if (tutorialActive) {
            tutorialActive = false;
            questionNumber = 1;
        } else {
            questionNumber += 1;
        }

        startQuestion(root);
    }

    function bindEarTest(root) {
        root.querySelector("[data-play-question]").addEventListener("click", playCurrentChord);
        root.querySelector("[data-replay-question]").addEventListener("click", playCurrentChord);
        root.querySelector("[data-next-question]").addEventListener("click", () => nextQuestion(root));

        root.querySelector("[data-answer-grid]").addEventListener("click", function (event) {
            const option = event.target.closest("[data-answer-name]");
            if (option) {
                answerQuestion(root, option.dataset.answerName);
            }
        });

        document.addEventListener("chord:playing", function (event) {
            if (currentChord && event.detail.chord.name === currentChord.name) {
                root.classList.add("is-playing-sound");
            }
        });

        document.addEventListener("chord:ended", function () {
            root.classList.remove("is-playing-sound");
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        const root = document.querySelector("[data-ear-test]");
        const dataScript = document.getElementById("ear-test-data");

        if (!root || !dataScript) {
            return;
        }

        chords = JSON.parse(dataScript.textContent).map(normalize);
        bindEarTest(root);
        renderScore(root);
        startQuestion(root);
    });
})();
