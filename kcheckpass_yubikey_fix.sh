#!/bin/sh

# Add permissions to kcheckpass to read yubkikey challenge response data.

# Setup: Activated Yubikey-PAM-Module using Challenge Response with the inital challenge data stored only readable by root.
# While this works without issues in a commandline, when KDE checks a password (e.g. lock screen), it will not be able
# to read the file and you will not be able to login (workaround: second tty (ctrl+f2), `loginctl unlock-sessions`).
# To fix this, we are giving the KDE binary that checks the password the permissions to read challenge file.

# Needs to be run after every update. Path specific to KDE on arch.

sudo chmod u+s /usr/lib/kcheckpass
