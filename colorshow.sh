#!/bin/bash

# Function to center text within a column
center() {
    local text="$1"
    local width="$2"

    len=${#text}
    padding=$(( (width - len) / 2 ))

    printf "%${padding}s%s%${padding}s" "" "$text" ""
    if (( len % 2 )); then
        echo -n " "
    fi
}

# Parse command-line options
palette_flag=0
while getopts ":ph" opt; do
    case $opt in
        p)
            palette_flag=1
            ;;
        h)
            echo "Usage: colorshow [-p]"
            echo
            echo "Options:"
            echo "-p        Show palette colors instead of escape sequences"
            echo "-h        Display this help and exit"
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Check terminal width
term_width=$(tput cols)
min_width=80
max_width=127
if (( term_width < min_width )); then
    echo "Window size too small, please increase width of terminal window."
    exit 1
fi
width=$(( term_width / 16 )) 

# Foreground and background color combinations
for txt_clr in {30..37} {90..97}; do
    for bckg_clr in {40..47} {100..107} ; do
        if [[ $((txt_clr-30)) -ne $((bckg_clr-40)) ]] && [[ $((txt_clr-90)) -ne $((bckg_clr-100)) ]]; then
            # Display the colors combination
            if [[ $palette_flag -eq 1 ]]; then
                if (( term_width < max_width )); then
                    color_code="Clr$((txt_clr - 29))"
                    bckg_code="Clr$((bckg_clr - 39))"
                else
                    color_code="Color $((txt_clr - 29))"
                    bckg_code="Color $((bckg_clr - 39))"
                fi
                # adjust for bright colors
                [[ $txt_clr -ge 90 ]] && color_code=${color_code/Clr/Color} && color_code=${color_code//$((txt_clr - 29))/$((txt_clr - 81))}
                [[ $bckg_clr -ge 100 ]] && bckg_code=${bckg_code/Clr/Color} && bckg_code=${bckg_code//$((bckg_clr - 39))/$((bckg_clr - 91))}
                echo -en "\e[${txt_clr};${bckg_clr}m$(center "$color_code" $width)\e[0m"
            else
                color_code="^[${txt_clr};${bckg_clr}m"
                echo -en "\e[${txt_clr};${bckg_clr}m$(center "$color_code" $width)\e[0m"
            fi
        else
            # Display the color against the default background
            if [[ $palette_flag -eq 1 ]]; then
                if (( term_width < max_width )); then
                    color_code="Clr$((txt_clr - 29))"
                else
                    color_code="Color $((txt_clr - 29))"
                fi
                # adjust for bright colors
                [[ $txt_clr -ge 90 ]] && color_code=${color_code/Clr/Color} && color_code=${color_code//$((txt_clr - 29))/$((txt_clr - 81))}
                echo -en "\e[${txt_clr}m$(center "$color_code" $width)\e[0m"
            else
                color_code="^[${txt_clr}m"
                echo -en "\e[${txt_clr}m$(center "$color_code" $width)\e[0m"
            fi
        fi
    done
    echo
done

# Reset
echo -e "\e[0m"
