# colorshow
![colorshow_example](https://github.com/rsquires1988/colorshow/assets/63078967/e19b2edd-cb47-4820-98c2-43c77fcd9b73)

Shows colors currently set in GNOME terminal's Edit > Preferences > Colors tab for the currently selected profile for testing out custom color choices and their combinations.  The diagonal line of grey backgrounds replaces the line in each column that would normally be occupied by the row in which the foreground and background colors match, and is for testing against the terminal's standard background and transparency.

Command: ./colorshow.sh

For now, I recommend widening or full-screening the terminal so that all of the columns line up.  Eventually, columns will scale with the size of the terminal window.

From there, just change colors in the preferences to see them change in the previously run command's output.

Standard output shows palette colors (+1).

Use flag '-e' for escape character output.
