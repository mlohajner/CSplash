# 📟 CSplash — Chafa Splash Show

> *Remember the sound?* That electric screech-and-hiss of a dial-up modem handshaking with a BBS a thousand miles away — and then, right after, that glorious ANSI intro screen scanning onto your CRT, line by line, welcoming you home.

**CSplash brings that moment back. Every time you open a terminal.**

---

## The idea

Terminals today just... open. Blank. Silent. A blinking cursor and nothing else — efficient, sure, but there's no *arrival*. No sense that something is glad to see you.

CSplash fixes that with two simple beliefs:

1. **Nostalgia is a feature.** The BBS era had a ritual: dial, connect, wait a beat, and be greeted by hand-crafted art that told you *this* board had personality. That ritual is worth bringing back.
2. **Your terminal deserves a proper welcome.** Instead of the cold shock of an empty prompt, CSplash greets you with an image from your own collection — gracefully **scanned onto the screen line by line**, exactly like the old days — before handing you off to your shell.

Your collection, your rules. Drop in **ASCII/ANSI art**, **photos**, or even **animations**, and CSplash picks one at random (or by name) and renders it right there in your terminal.

---

## Powered by chafa

CSplash is a thin, opinionated wrapper — all the actual terminal-graphics magic comes from **[chafa](https://hpjansson.org/chafa/)**, the excellent open-source tool that converts images and animations into stunning character/ANSI art for the terminal.

All credit for the rendering engine goes to chafa and its author, Hans Petter Jansson. CSplash just adds the ritual around it: picking, sequencing, scanning, and the show.

👉 chafa homepage: **https://hpjansson.org/chafa/**

Make sure `chafa` (and `identify` from ImageMagick, used for detecting animated images) is installed on your system before using CSplash.

---

## What it looks like

```
$ show

my-favorite-bbs-intro

[ image scans onto your terminal, line by line ]
```

Static images and ASCII/ANSI art scan in gracefully, line by line, like text crawling up an old terminal. Animated images play live for a few seconds instead — chafa handles the frame-by-frame rendering.

---

## Usage

```bash
show                # random splash from your collection
show <keyword>      # random splash whose filename matches <keyword>
show -l, --list     # list everything in your splash folder
show -d, --dir      # print the splash folder path
show -e, --edit     # edit the show script itself
show -v, --version  # print version info
show -h, --help     # show all of the above
```

### Your collection

By default CSplash looks in `~/.csplash`. Drop any images, ASCII/ANSI art files, or animations in there and they're instantly part of the rotation.

Want them somewhere else? Point CSplash at any folder:

```bash
export CSPLASH_DIR=/path/to/your/splash/collection
```

### Background color

CSplash tries to auto-detect whether your terminal is light or dark and picks a sensible background accordingly. Not happy with the guess? Override it:

```bash
export CSPLASH_BG=black   # or white, or any chafa-supported color
```

---

## Make it part of your ritual

Add this to your `.bashrc` / `.zshrc` so every new terminal gets a proper welcome:

```bash
show
```

That's it. Open a terminal, get a splash. Just like connecting to your favorite BBS.

---

## Credits

- **chafa** — the terminal graphics engine that makes this all possible: https://hpjansson.org/chafa/
- **CSplash** — by Mario Lohajner, 2024

*Dial-up tone not included. Nostalgia guaranteed.*
