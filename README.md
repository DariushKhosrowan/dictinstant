<div align="center">

# dictinstant

### Instant multi-source dictionary definitions — examples &amp; pictures

**Many definitions of a word from different dictionaries, at once. You choose the meaning that clicks.**

`sudo apt install dictinstant`

[Try the live demo](https://amirhosseineslami.github.io/dictinstant/) · [Website](https://amirhosseineslami.github.io/dictinstant/) · [Install](#install) · [GitHub Releases](https://github.com/amirhosseineslami/dictinstant/releases)

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform: Linux](https://img.shields.io/badge/platform-Linux-success.svg)
![Zero dependencies](https://img.shields.io/badge/dependencies-zero-brightgreen.svg)
![Data: free & open](https://img.shields.io/badge/sources-free%2Bopen-orange.svg)

</div>

---

## Why dictinstant?

A single flat definition rarely teaches a word well. Different dictionaries phrase the same word differently — and the phrasing that clicks is **personal**.

**dictinstant shows you several independent definitions side by side**, with example sentences and pictures, so you pick the meaning that makes it stick. It is built around how you actually learn.

## Features

- 📚 **Many definitions, many dictionaries** — independent definitions from the [Free Dictionary API](https://dictionaryapi.dev/) and [Wiktionary](https://en.wiktionary.org/), each source named.
- 🖼️ **Pictures that fix meaning** — automatic relevant images from [Wikimedia Commons](https://commons.wikimedia.org/) for every word.
- 🔊 **Pronunciation + examples** — audio where available, real example sentences, part-of-speech.
- 💾 **You choose what sticks** — tap *Choose this* on any definition; it is saved to your personal *My chosen meanings* list (persisted on your device).
- 🧼 **Clean & fast** — a single zero-dependency HTML file. No build step, no runtime beyond a browser (or Python for the local server).
- 🕊️ **Free & open source** — MIT license, and every data source is free and open.

## Install

### Option 1 — APT (Debian / Ubuntu) — recommended

```bash
curl -fsSL https://raw.githubusercontent.com/amirhosseineslami/dictinstant/main/scripts/apt-setup.sh | sudo bash
sudo apt update
sudo apt install -y dictinstant
dictinstant
```

`dictinstant` serves the app at `http://127.0.0.1:8123/` and opens your browser.

### Option 2 — direct .deb

```bash
curl -fsSL https://github.com/amirhosseineslami/dictinstant/releases/latest/download/dictinstant.deb -o /tmp/dictinstant.deb
sudo dpkg -i /tmp/dictinstant.deb
dictinstant
```

### Option 3 — any browser, no install

Open `site/app/index.html` directly, or use the [live demo](https://amirhosseineslami.github.io/dictinstant/).

## Usage

1. Type a word and press **Look up**.
2. Compare the definitions from each source (Free Dictionary, Wiktionary).
3. Browse the pictures.
4. Tap **Choose this** on the definition that clicks — it is added to *My chosen meanings*.
5. Review your saved meanings any time (they persist on your device).

## How it works

```
            ┌──────────────────────────────┐
 browser ──▶│  dictinstant (static SPA)     │
            │  single HTML file, no build   │
            └──────────────┬───────────────┘
                           │  fetch (browser)
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
   Free Dictionary      Wiktionary        Wikimedia Commons
   (definitions,       (definitions,     (pictures)
    audio, examples)     etymology)
```

The app calls the public APIs directly from the browser. Installed via APT, a tiny local server (python3) serves the same file on `localhost`.

## Project layout

```
dictinstant/
├── site/                  # the website & deployed app
│   ├── index.html          #   SEO landing page (this is the site root)
│   ├── app/index.html      #   the dictionary app itself
│   ├── og-cover.png        #   social share image
│   ├── robots.txt
│   ├── sitemap.xml
│   └── repo/               #   APT repository (Release, InRelease, Packages…)
├── packaging/
│   ├── debian/control      #   Debian package metadata
│   └── scripts/dictinstant #   the `dictinstant` launcher
├── scripts/
│   ├── apt-setup.sh        #   adds the APT repo (the one-liner)
│   └── dictinstant.list     #   APT source entry
└── README.md
```

## Development

```bash
# Serve the site locally
cd site && python3 -m http.server 8000
# open http://127.0.0.1:8000/
```

The app has no external build tools. To rebuild the Debian package:

```bash
# assemble layout and build
dpkg-deb --root-owner-group --build /tmp/di-root /tmp/dictinstant.deb
```

## License

[MIT](LICENSE) © Dariush Khosrowan. The app itself is free and open source; definitions and images are © their respective open sources (Free Dictionary API, Wiktionary, Wikimedia Commons).
