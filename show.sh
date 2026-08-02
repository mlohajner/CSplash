#!/usr/bin/env bash
set -u

folder="${CSPLASH_DIR:-$HOME/.csplash}"
self="${BASH_SOURCE[0]##*/}"

detect_bg() {
#	Allow explicit override via env var
	if [ -n "${CSPLASH_BG:-}" ]; then
		printf '%s' "$CSPLASH_BG"
		return
	fi
#	COLORFGBG is set by many terminals as "fg;bg" (e.g. "15;0" = light text on dark bg)
	if [ -n "${COLORFGBG:-}" ]; then
		local bg="${COLORFGBG##*;}"
		if [ "$bg" -le 6 ] 2>/dev/null; then
			printf 'black'
			return
		else
			printf 'white'
			return
		fi
	fi
#	Fallback default
	printf 'white'
}

slow_scan() {
	while IFS=$'\n' read -r line
	do
		echo "$line"
		sleep 0.01
	done
	printf "\e[0m\e[?25h"
}

header() {
	printf " \\ CSS \\  Chafa Splash Show V3.0\n"
	printf "          😃 by Mario Lohajner 2024\n"
	printf "\n"
}

check_deps() {
	local missing=()
	for cmd in chafa identify shuf find; do
		command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
	done
	if [ "${#missing[@]}" -gt 0 ]; then
		echo "Error: missing required command(s): ${missing[*]}" >&2
		exit 1
	fi
}

pick_random() {
	# $1 = optional name filter (may be empty)
	# -L: follow symlinks, so a symlinked .csplash directory (e.g. root's
	# .csplash -> /home/user/.csplash) is traversed instead of being
	# treated as an opaque link with no contents.
	local filter="$1" result
	if [ -n "$filter" ]; then
		result=$(find -L "$folder" -type f -iname "*${filter}*" 2>/dev/null | shuf -n 1)
	else
		result=$(find -L "$folder" -type f 2>/dev/null | shuf -n 1)
	fi
	printf '%s' "$result"
}

#	-v/-h don't require the splash folder to exist, so handle them first.
case "${1:-}" in
	-v|--version)
		header
		exit 0
		;;
	-h|--help)
		header
		echo "	-v (--version)	show version information"
		echo "	-l (--list)	splash files catalogue"
		echo "	-d (--dir)	splash directory"
		echo "	-e (--edit)	edit and customize show script"
		echo "	-h (--help)	show help (this) information"
		echo ""
		echo "Environment variables:"
		echo "	CSPLASH_DIR	override splash folder (default: \$HOME/.csplash)"
		echo "	CSPLASH_BG	override background color (default: auto-detected)"
		exit 0
		;;
esac

if [ ! -d "$folder" ]; then
	echo "Error: splash folder not found: $folder" >&2
	exit 1
fi

check_deps

bg="$(detect_bg)"

filename=""
filter=""

if [ -z "${1:-}" ]; then
	filename=$(pick_random "")
else
	case "$1" in
		-l|--list)
			ls "${2:-}" -- "$folder"
			exit 0
			;;
		-d|--dir)
			echo "$folder"
			exit 0
			;;
		-e|--edit)
			nano -lc "$folder/$self"
			exit 0
			;;
		*)
			filter="$1"
			filename=$(pick_random "$filter")
			clear
			;;
	esac
fi

# Skip generated/internal files (show script itself, .comments*),
# re-rolling within the same filter set. Cap attempts to avoid infinite loop.
attempts=0
while [ -n "$filename" ] && { [ "$(basename "$filename")" == "$self" ] || [[ "$(basename "$filename")" == .comments* ]]; }; do
	filename=$(pick_random "$filter")
	attempts=$((attempts + 1))
	if [ "$attempts" -ge 20 ]; then
		filename=""
		break
	fi
done

if [ -z "$filename" ]; then
	echo "No matching splash image found${filter:+ for filter '$filter'}." >&2
	exit 1
fi

if [ -f "$filename" ]; then
	file=${filename##*/}
	base=${file%%.*}
	echo "$base"
	if [ "$(identify "$filename" 2>/dev/null | wc -l)" -gt 1 ]; then
		timeout 5 chafa "$filename" -w 9 --margin-bottom 5 --bg "$bg"
	else
		chafa "$filename" -w 9 --margin-bottom 5 --bg "$bg" | slow_scan
	fi
fi
