# colorshow
![colorshow_example](https://github.com/rsquires1988/colorshow/assets/63078967/e19b2edd-cb47-4820-98c2-43c77fcd9b73)

Shows colors currently set in terminals that support ANSI escape codes. In GNOME terminal for example, edit these by going to Edit > Preferences > Colors tab for the currently selected profile for testing out custom color choices and their combinations.  The diagonal line of grey backgrounds in the example output above replaces the line in each column that would normally be occupied by the row in which the foreground and background colors match, and is for testing against the terminal's standard background and transparency.

Command: ./colorshow.sh

Supports terminal widths of 80 and above for palette output, and 144 and above for escape character output.

Change colors in the preferences to see them change in the previously run command's output.

Standard output shows palette colors by number (+1).

Use flag '-e' for escape character output.
