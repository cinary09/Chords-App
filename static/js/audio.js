(function () {
    "use strict";

    const RECENT_KEY = "guitarChordHub.recentChords";
    const FAVORITE_KEY = "guitarChordHub.favoriteChords";
    const MAX_RECENT = 8;
    const preloadCache = new Map();
    let activeAudio = null;
    let activeChord = null;

    function readStore(key) {
        try {
            return JSON.parse(localStorage.getItem(key)) || [];
        } catch (error) {
            return [];
        }
    }

    function writeStore(key, value) {
        localStorage.setItem(key, JSON.stringify(value));
    }

    function escapeHtml(value) {
        return String(value)
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll('"', "&quot;");
    }

    function normalizeChord(chord) {
        return {
            id: Number(chord.id),
            name: chord.name,
            category: chord.category,
            difficulty: chord.difficulty,
            audioUrl: chord.audioUrl || chord.audio_url
        };
    }

    function chordFromElement(element) {
        return normalizeChord({
            id: element.dataset.chordId,
            name: element.dataset.chordName,
            category: element.dataset.chordCategory,
            difficulty: element.dataset.chordDifficulty,
            audioUrl: element.dataset.audioUrl
        });
    }

    function dispatch(name, detail) {
        document.dispatchEvent(new CustomEvent(name, { detail }));
    }

    function matchingChordElements(chordName) {
        return Array.from(document.querySelectorAll("[data-chord-name], [data-chord-active-name]"))
            .filter((element) => {
                return element.dataset.chordName === chordName ||
                    element.dataset.chordActiveName === chordName;
            });
    }

    function setChordState(chordName, className, enabled) {
        if (!chordName) {
            return;
        }

        matchingChordElements(chordName).forEach((element) => {
            element.classList.toggle(className, enabled);
        });
    }

    function preloadChord(chord) {
        const preparedChord = normalizeChord(chord);

        if (!preparedChord.audioUrl || preloadCache.has(preparedChord.audioUrl)) {
            return;
        }

        const audio = new Audio(preparedChord.audioUrl);
        audio.preload = "auto";
        audio.load();
        preloadCache.set(preparedChord.audioUrl, audio);
    }

    function allChordControls() {
        const elements = Array.from(document.querySelectorAll("[data-audio-url][data-chord-name]"));
        const seen = new Set();

        return elements.map(chordFromElement).filter((chord) => {
            if (seen.has(chord.name)) {
                return false;
            }

            seen.add(chord.name);
            return true;
        });
    }

    function preloadNearby(chordName) {
        const chords = allChordControls();
        const index = chords.findIndex((chord) => chord.name === chordName);
        const start = Math.max(0, index - 2);
        const end = Math.min(chords.length, index + 4);

        chords.slice(start, end).forEach(preloadChord);
    }

    function stopActiveChord() {
        if (activeAudio) {
            activeAudio.pause();
            activeAudio.currentTime = 0;
        }

        if (activeChord) {
            setChordState(activeChord.name, "is-playing", false);
            setChordState(activeChord.name, "is-loading", false);
        }

        activeAudio = null;
        activeChord = null;
    }

    function saveRecentChord(chord) {
        const current = readStore(RECENT_KEY).filter((item) => item.name !== chord.name);
        current.unshift(chord);
        writeStore(RECENT_KEY, current.slice(0, MAX_RECENT));
        renderStoredLists();
    }

    async function playChord(chord) {
        const preparedChord = normalizeChord(chord);

        if (!preparedChord.audioUrl) {
            return;
        }

        stopActiveChord();
        activeChord = preparedChord;
        setChordState(preparedChord.name, "is-loading", true);
        dispatch("chord:loading", { chord: preparedChord });

        const audio = preloadCache.get(preparedChord.audioUrl) || new Audio(preparedChord.audioUrl);
        audio.preload = "auto";
        audio.currentTime = 0;
        activeAudio = audio;

        audio.onended = function () {
            setChordState(preparedChord.name, "is-playing", false);
            setChordState(preparedChord.name, "is-loading", false);
            dispatch("chord:ended", { chord: preparedChord });
        };

        audio.onerror = function () {
            setChordState(preparedChord.name, "is-playing", false);
            setChordState(preparedChord.name, "is-loading", false);
            dispatch("chord:error", { chord: preparedChord });
        };

        try {
            await audio.play();
            preloadCache.set(preparedChord.audioUrl, audio);
            setChordState(preparedChord.name, "is-loading", false);
            setChordState(preparedChord.name, "is-playing", true);
            saveRecentChord(preparedChord);
            preloadNearby(preparedChord.name);
            dispatch("chord:playing", { chord: preparedChord });
        } catch (error) {
            setChordState(preparedChord.name, "is-loading", false);
            dispatch("chord:error", { chord: preparedChord });
        }
    }

    function renderStoredItem(chord, favoriteMode) {
        const favoriteAttrs = favoriteMode ? "" : `
            <button
                class="icon-button favorite-button"
                type="button"
                data-favorite-chord
                data-chord-id="${chord.id}"
                data-chord-name="${escapeHtml(chord.name)}"
                data-chord-category="${escapeHtml(chord.category)}"
                data-chord-difficulty="${escapeHtml(chord.difficulty)}"
                data-audio-url="${escapeHtml(chord.audioUrl)}"
                aria-label="Save ${escapeHtml(chord.name)} as a favorite chord"
            >☆</button>`;

        return `
            <div class="stored-chord">
                <button
                    class="stored-play"
                    type="button"
                    data-chord-play
                    data-chord-id="${chord.id}"
                    data-chord-name="${escapeHtml(chord.name)}"
                    data-chord-category="${escapeHtml(chord.category)}"
                    data-chord-difficulty="${escapeHtml(chord.difficulty)}"
                    data-audio-url="${escapeHtml(chord.audioUrl)}"
                >
                    <span>♪</span>
                    <strong>${escapeHtml(chord.name)}</strong>
                    <small>${escapeHtml(chord.category)}</small>
                </button>
                ${favoriteAttrs}
            </div>
        `;
    }

    function renderList(selector, items, emptyText, favoriteMode) {
        document.querySelectorAll(selector).forEach((container) => {
            if (items.length === 0) {
                container.innerHTML = `<p class="stored-empty">${emptyText}</p>`;
                return;
            }

            container.innerHTML = items.map((item) => renderStoredItem(item, favoriteMode)).join("");
        });
    }

    function updateFavoriteButtons() {
        const favorites = readStore(FAVORITE_KEY);
        const favoriteNames = new Set(favorites.map((item) => item.name));

        document.querySelectorAll("[data-favorite-chord]").forEach((button) => {
            const active = favoriteNames.has(button.dataset.chordName);
            button.classList.toggle("is-favorite", active);
            button.setAttribute("aria-pressed", active ? "true" : "false");

            const star = button.querySelector("span");
            if (star) {
                star.textContent = active ? "★" : "☆";
            } else if (button.textContent.includes("Favorite")) {
                button.textContent = active ? "★ Favorited" : "☆ Favorite";
            }
        });
    }

    function renderStoredLists() {
        renderList("[data-recent-chords]", readStore(RECENT_KEY), "Play a chord to see it here.", false);
        renderList("[data-favorite-chords]", readStore(FAVORITE_KEY), "Tap the star on a chord to save it.", true);
        updateFavoriteButtons();
    }

    function toggleFavorite(chord) {
        const preparedChord = normalizeChord(chord);
        const favorites = readStore(FAVORITE_KEY);
        const exists = favorites.some((item) => item.name === preparedChord.name);
        const nextFavorites = exists
            ? favorites.filter((item) => item.name !== preparedChord.name)
            : [preparedChord, ...favorites];

        writeStore(FAVORITE_KEY, nextFavorites);
        renderStoredLists();
    }

    function shouldIgnoreCardTap(target) {
        return Boolean(target.closest("a, button, input, select, textarea, label"));
    }

    function bindAudioControls() {
        document.addEventListener("click", function (event) {
            const favoriteButton = event.target.closest("[data-favorite-chord]");
            if (favoriteButton) {
                event.preventDefault();
                event.stopPropagation();
                toggleFavorite(chordFromElement(favoriteButton));
                return;
            }

            const playButton = event.target.closest("[data-chord-play], [data-chord-trigger]");
            if (playButton) {
                event.preventDefault();
                event.stopPropagation();
                playChord(chordFromElement(playButton));
                return;
            }

            const chordCard = event.target.closest("[data-chord-card]");
            if (chordCard && !shouldIgnoreCardTap(event.target)) {
                playChord(chordFromElement(chordCard));
            }
        });

        document.addEventListener("keydown", function (event) {
            const trigger = event.target.closest("[data-chord-trigger]");
            if (!trigger || (event.key !== "Enter" && event.key !== " ")) {
                return;
            }

            event.preventDefault();
            playChord(chordFromElement(trigger));
        });

        document.querySelectorAll("[data-audio-url][data-chord-name]").forEach((element) => {
            element.addEventListener("pointerenter", () => preloadChord(chordFromElement(element)));
            element.addEventListener("focus", () => preloadChord(chordFromElement(element)));
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        bindAudioControls();
        renderStoredLists();
        allChordControls().slice(0, 6).forEach(preloadChord);
    });

    window.ChordAudio = {
        playChord,
        preloadChord,
        stop: stopActiveChord,
        normalizeChord
    };
})();
