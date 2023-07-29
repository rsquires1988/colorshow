#!/bin/bash

# Ryan Squires - 2023
# colorshow.sh - A program for testing out custom GNOME terminal color choices

# Function to center text within a column
center() {
    local text="$1"
    local width="$2"

    local escape_seq_len=0
    if [[ $escape_flag -eq 1 ]]; then
        # Calculate length of escape sequence characters
        escape_seq_len=2 # Length of '\e[' and 'm'
        if [[ $text == *";"* ]]; then
            escape_seq_len=$((escape_seq_len+1)) # Length of ';' in color_code
            if [[ $text == *";1"* ]] || [[ $text == *";10"* ]]; then
                escape_seq_len=$((escape_seq_len+2)) # Length of additional digits in color_code
            fi
        fi
    fi

    local len=${#text}
    len=$((len - escape_seq_len)) # Subtract the length of non-printable characters

    local padding=$(( (width - len) / 2 ))

    printf "%${padding}s%s%${padding}s" "" "$text" ""
    if (( len % 2 != width % 2 )); then
        echo -n " "
    fi
}

# Parse command-line options
escape_flag=0
while getopts ":eh" opt; do
    case $opt in
        e)
            escape_flag=1
            ;;
        h)
            echo "Usage: $0 [-e] [-h]"
            echo "Display terminal colors."
            echo "Options:"
            echo "-e    Display escape sequences instead of palette colors."
            echo "-h    Display this help message."
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

term_width=$(tput cols)
if (( escape_flag == 1 )); then
    if (( term_width < 144 )); then
	echo "Window size too small, please increase width of terminal window."
	exit 1
    fi

    width=$(( term_width / 16 ))
else
    if (( term_width < 80 )); then
        echo "Window size too small, please increase width of terminal window."
        exit 1
    fi

    if (( term_width < 96 )); then
        # Terminal width less than 96, use 5-char format
        format="Clr"
        width=5
    elif (( term_width < 112 )); then
        # Terminal width less than 112, use 6-char format
        format="Clr "
        width=6
    elif (( term_width < 128 )); then
        # Terminal width less than 128, use 7-char format
        format="Color"
        width=7
    elif (( term_width < 144 )); then
        # Terminal width less than 144, use 8-char format
        format="Color "
        width=8
    else
        format="Color "
        width=$(( term_width / 16 ))
    fi
fi

# Foreground and background color combinations
for txt_clr in {30..37} {90..97}; do
    for bckg_clr in {40..47} {100..107} ; do
        if [[ $((txt_clr-30)) -ne $((bckg_clr-40)) ]] && [[ $((txt_clr-90)) -ne $((bckg_clr-100)) ]]; then
            # Display the color combination
            if [[ $escape_flag -eq 1 ]]; then
                color_code=$(printf "%-9s" "^[${txt_clr};${bckg_clr}m")
		# "^[${txt_clr};${bckg_clr}m"
                # echo -en "\e[${txt_clr};${bckg_clr}m$(center "$color_code" $width)\e[0m"
            	echo -en "\e[${txt_clr};${bckg_clr}m$color_code\e[0m"
            else
                color_num=$((txt_clr - 29))
                bckg_num=$((bckg_clr - 23))
                # Adjust for bright colors
                [[ $txt_clr -ge 90 ]] && color_num="$((txt_clr - 81))"
                [[ $bckg_clr -ge 100 ]] && bckg_num="$((bckg_clr - 75))"

                # If color_num or bckg_num is less than 10, add a space after it
                [[ $color_num -lt 10 ]] && color_num="${color_num} "
                [[ $bckg_num -lt 10 ]] && bckg_num="${bckg_num} "

                color_code="${format}${color_num}"
                bckg_code="${format}${bckg_num}"

                echo -en "\e[${txt_clr};${bckg_clr}m$(center "$color_code" $width)\e[0m"
            fi
        else
            # Display the color against the default background
            if [[ $escape_flag -eq 1 ]]; then
                color_code=$(printf "%-8s" "^[${txt_clr}m")
		# color_code="^[${txt_clr}m"
                if (( term_width >= 128 )); then
                    color_code="${color_code} " # Add an extra space for backgroundless outputs
                fi
                echo -en "\e[${txt_clr}m$color_code\e[0m"
		#echo -en "\e[${txt_clr}m$(center "$color_code" $width)\e[0m"
	    else
		color_num=$((txt_clr - 29))
                # adjust for bright colors
                [[ $txt_clr -ge 90 ]] && color_num="$((txt_clr - 81))"

		# If color_num is less than 10, add a space after it
		[[ $color_num -lt 10 ]] && color_num="${color_num} "

                color_code="${format}${color_num}"

		echo -en "\e[${txt_clr}m$(center "$color_code" $width)\e[0m"
            fi
        fi
    done
    echo
done

# Reset
echo -e "\e[0m"

# Potential fix for bad centering on wide terminals for "Color X" output
# Replace current centering mechanism with:
#
# # Foreground color is less than 10, add a space after it
# [[ $color_num -lt 10 ]] && color_num=$(printf "%-2s" "$color_num")
#
# color_code="${format}${color_num}"
#
# # Background color is less than 10, add a space after it
# [[ $bckg_num -lt 10 ]] && bckg_num=$(printf "%-2s" "$bckg_num")
#
# bckg_code="${format}${bckg_num}"

# Potential fix for -e centering:
# The \e[0m reset could be adding invisible characters which cause the strings to exceed the intended width in -e output
# echo -en "\e[${txt_clr};${bckg_clr}m$color_code"
# echo -e "\e[0m"
