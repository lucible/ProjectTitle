#!/bin/bash

# Check for required gettext tools
echo "Checking for required gettext tools..."

TOOLS_MISSING=0
if ! command -v xgettext &> /dev/null; then
    echo "Error: xgettext not found in PATH"
    TOOLS_MISSING=1
fi
if ! command -v msgmerge &> /dev/null; then
    echo "Error: msgmerge not found in PATH"
    TOOLS_MISSING=1
fi
if ! command -v msgfmt &> /dev/null; then
    echo "Error: msgfmt not found in PATH"
    TOOLS_MISSING=1
fi
if [ "$TOOLS_MISSING" -eq 1 ]; then
    echo ""
    echo "Please install gettext tools first"
    echo "- Linux: sudo apt-get install gettext (Debian/Ubuntu) or sudo yum install gettext (RHEL/CentOS)"
    echo "- macOS: brew install gettext"
    exit 1
fi
echo "All required tools are available."
echo ""

# Compile PO files to MO files
echo "Starting MO files compilation..."
COMPILE_COUNT=0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for dir in "$SCRIPT_DIR/l10n"/*; do
    if [ -d "$dir" ] && [ -f "$dir/koreader.po" ]; then
        MO_FILE="$dir/koreader.mo"
        LANG_NAME=$(basename "$dir")
        echo " Compiling: $LANG_NAME/koreader.po -> $LANG_NAME/koreader.mo"
        if msgfmt -o "$MO_FILE" "$dir/koreader.po"; then
            ((COMPILE_COUNT++))
        else
            echo "Error: Failed to compile $LANG_NAME/koreader.po!" >&2
        fi
    fi
done
echo "Compilation completed, successfully generated $COMPILE_COUNT MO files"

# Make folder
mkdir -p projecttitle.koplugin

# Copy everything into the right folder name
cp *.lua projecttitle.koplugin/
cp -r fonts projecttitle.koplugin/
cp -r icons projecttitle.koplugin/
cp -r resources projecttitle.koplugin/
cp -r l10n projecttitle.koplugin/

# Cleanup unwanted
rm -f projecttitle.koplugin/resources/collage.jpg
rm -f projecttitle.koplugin/resources/licenses.txt
# rm -f projecttitle.koplugin/**/*.po -- needed for some devices???

# Zip the folder
zip -r projecttitle.zip projecttitle.koplugin

# Delete the folder
rm -rf projecttitle.koplugin

echo ""
echo "Done! Created projecttitle.zip"