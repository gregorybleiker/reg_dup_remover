# PATH environment cleaner for windows

This script removes paths that are duplicated inside the System PATH and also removes duplicates that exist in the System and the User path at the same time. Use with _caution_, it will rewrite your paths.

The script does:

- strips off all backslashes in the path
- removes duplicate entries in user and system path
- removes entries where the path does not exist
- remove entries in user path if they exist in system path
