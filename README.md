# Jistary
A Windows Search Replacement - Inspired by Listary

## I got sick of the windows search feature being slow and returning inconsistent results, so I wrote a replacement.

## Setup Instructions:
1. Unzip the EXE and TXT files to anywhere you want.
2. Run the EXE, and pin it to your taskbar.
3. right-click your new taskbar icon, click Jistary, click properties, and set a shortcut key.  I prefer CTRL+ALT+Z.  (if anybody knows how to make Jistary run from the windows key, please submit your code!)
4. customize your commands.txt file.

## COMMANDS.TXT
Jistary reads this file each time it starts.

The 1st column is the “key” the user will type to activate the command in the 3rd column.  The key can be 1 or more characters.  There can be duplicates.

The 2nd column is what gets displayed to the user when they type the key.

The 3rd column is the website or command to be executed.  {query} will get replaced with whatever the user types after they key.

The 4th column is optional.  It’s for passing command line parameters to programs, such as ping.

FNS stands for File Name Search, it’s a special built-in command that makes Jistary search file names in a folder.  Jistary will also search ALL FNS even when the user doesn’t type a “key”.

FCS stands for File Contents Search, it’s another built-in command that makes Jistary search file contents, but unlike FNS, it doesn’t get used when the user doesn’t type a “key”

# SCREENSHOTS
![Screenshot1](/Screenshots/start.png)
![Screenshot1](/Screenshots/a.png)
![Screenshot1](/Screenshots/d.png)
![Screenshot1](/Screenshots/e.png)
![Screenshot1](/Screenshots/p.png)
![Screenshot1](/Screenshots/fns.png)
