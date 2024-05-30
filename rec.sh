#!/usr/bin/env bash

if [ -t 1 ]; then
	COLOR_CYAN='\033[0;36m'
	COLOR_RED='\033[0;31m'
	COLOR_YELLOW='\033[1;33m'
	COLOR_NC='\033[0m'
fi

if [ ! "$RECSH_RECORDER" ]; then
	if [ "$(command -v wf-recorder)" ]; then
		RECSH_RECORDER="wf-recorder"
	elif [ "$(command -v wl-screenrec)" ]; then
		RECSH_RECORDER="wl-screenrec"
	else
		echo -e "${COLOR_RED}ERRO:${COLOR_NC} No recorder specified or installed."
		exit 1
	fi
fi

BINARY_NAME=$(basename "$0")

POSITIONAL_ARGS=()

COMPRESS=true
DEFAULT_OUTPUT_FILE="./rec.gif"
OUPUT_FILE=""
OVERWRITE_FILE=true
TEMP_FILE="/tmp/rec-sh-temp.mp4"

VERBOSE=false

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			echo -e "Usage: $BINARY_NAME [OPTIONS...] [FILE]"
			echo -e "A simple bash script to record your screen";
			echo -e ""
			echo -e "Use Ctrl+C to stop recording"
			echo -e ""
			echo -e "With no FILE is provided, the output file will be ${COLOR_CYAN}./rec.gif${COLOR_NC}"
			echo -e ""
			echo -e "Options:"
			echo -e ""
			echo -e "  ${COLOR_CYAN}-r${COLOR_NC}|${COLOR_CYAN}--region${COLOR_NC} [REGION] [REGION]"
			echo -e "  Area that will be passed to ${COLOR_CYAN}$RECSH_RECORDER -r [REGION] [REGION]${COLOR_NC}, if none is passed, the script"
			echo -e "  will try to use ${COLOR_CYAN}slurp${COLOR_NC} if it is installed."
			echo -e ""
			echo -e "  ${COLOR_CYAN}-c${COLOR_NC}|${COLOR_CYAN}--compress${COLOR_NC} <true|false|1|0> DEFAULT=true"
			echo -e "  Use ${COLOR_CYAN}FFmpeg${COLOR_NC} to compress the output file."
			echo -e ""
			echo -e "  ${COLOR_CYAN}-y${COLOR_NC} DEFAULT=true"
			echo -e "  Overwrite output file it exists."
			echo -e ""
			echo -e "  ${COLOR_CYAN}-v${COLOR_NC}|${COLOR_CYAN}--verbose${COLOR_NC}"
			echo -e "  Increase the logging verbosity level."
			echo -e ""
			echo -e "  ${COLOR_CYAN}-h${COLOR_NC}|${COLOR_CYAN}--help${COLOR_NC}"
			echo -e "  Show this help screen."
			echo -e ""
			echo -e '2024 (c) Gustavo "Guz" L. de Mello <contact.guz013@gmail.com>'
			echo -e 'Licensed under WTFPL license. PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.'
			exit 0
			;;
		-r|--region)
			if [ "$2" ] && [ "$3" ]; then
				REGION="$2 $3"
				shift
				shift
			elif [ "$2" ]; then
				REGION="$2"
				shift
			elif [ "$(command -v slurp)" ]; then
				REGION="$(slurp -d)"
			fi
			shift
			;;
		-c|--compress)
			if [ "$2" ]; then
				COMPRESS="$2"
				shift
			else
				COMPRESS=true
			fi
			shift
			;;
		-y)
			if [ "$2" ]; then
				OVERWRITE_FILE="$2"
				shift
			else
				OVERWRITE_FILE=true
			fi
			shift
			;;
		-v|--verbose)
			if [[ "$2" ]]; then
				VERBOSE="$2"
				shift
			else
				VERBOSE=true
			fi
			shift
			;;
		-*|--*)
			echo -e "${COLOR_RED}ERRO:${COLOR_NC} Unknown option ${COLOR_CYAN}$1${COLOR_NC}"
			exit 1
			;;
		*)
			POSITIONAL_ARGS+=("$1")
			shift
			;;
	esac
done

set -- "${POSITIONAL_ARGS[@]}"

if [ "$1" ]; then
	OUPUT_FILE="$1"
else
	OUPUT_FILE="$DEFAULT_OUTPUT_FILE"
	echo -e "${COLOR_CYAN}INFO:${COLOR_NC} No output file provided, writing to ${COLOR_CYAN}$OUPUT_FILE${COLOR_NC}"
fi

if [ "$REGION" ]; then
	echo -e "${COLOR_CYAN}INFO:${COLOR_NC} Recording on region ${COLOR_CYAN}$REGION${COLOR_NC}"
	"$RECSH_RECORDER" -g "$REGION" -f "$TEMP_FILE"
else
	"$RECSH_RECORDER" -f "$TEMP_FILE"
fi

if [ -f "$OUPUT_FILE" ] && [ ! "$OVERWRITE_FILE" ]; then
	echo -e "${COLOR_RED}ERRO:${COLOR_NC} File ${COLOR_CYAN}$OVERWRITE_FILE${COLOR_NC} already exists!"
	exit 1
fi

if [ "$COMPRESS" ]; then
	echo -e "${COLOR_CYAN}INFO:${COLOR_NC} Compressing file to ${COLOR_CYAN}$OUPUT_FILE${COLOR_NC}"
	ffmpeg \
	  -y \
	  -i "$TEMP_FILE" \
	  -vf 'fps=15,scale=720:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse' \
	  -loop 0 "$OUPUT_FILE"
else
	echo -e "${COLOR_CYAN}INFO:${COLOR_NC} Copying file to ${COLOR_CYAN}$OUPUT_FILE${COLOR_NC}"
	cp "$TEMP_FILE" "$OUPUT_FILE"
fi

rm "$TEMP_FILE"
