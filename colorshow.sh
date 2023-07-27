#!/bin/bash

# Width of each column
width=14

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
while getopts ":p" opt; do
    case $opt in
        p)
            palette_flag=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Foreground and background color combinations
for txt_clr in {30..37} {90..97}; do
    for bckg_clr in {40..47} {100..107} ; do
        if [[ $((txt_clr-30)) -ne $((bckg_clr-40)) ]] && [[ $((txt_clr-90)) -ne $((bckg_clr-100)) ]]; then
            # Display the colors combination
            if [[ $palette_flag -eq 1 ]]; then
                color_code="Color $((txt_clr - 29))"
                bckg_code="Color $((bckg_clr - 23))"
#		bckg_code=$color_code
                # adjust for bright colors
                [[ $txt_clr -ge 90 ]] && color_code="Color $((txt_clr - 81))"
                [[ $bckg_clr -ge 100 ]] && bckg_code="Color $((bckg_clr - 75))"
                echo -en "\e[${txt_clr};${bckg_clr}m$(center "$color_code" $width)\e[0m"
            else
                color_code="^[${txt_clr};${bckg_clr}m"
                echo -en "\e[${txt_clr};${bckg_clr}m$(center "$color_code" $width)\e[0m"
            fi
        else
            # Display the color against the default background
            if [[ $palette_flag -eq 1 ]]; then
                color_code="Color $((txt_clr - 29))"
                # adjust for bright colors
                [[ $txt_clr -ge 90 ]] && color_code="Color $((txt_clr - 81))"
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

