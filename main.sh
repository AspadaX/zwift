#! /bin/sh

# ==========================================
# Checking system requirements
# ==========================================

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script requires macOS to run."
    exit 1
fi

if ! command -v zed >/dev/null 2>&1; then
    echo "Zed is not installed. Would you like to install it with Homebrew? (y/n)"
    read INSTALL_ZED_CHOICE
    if [ "$INSTALL_ZED_CHOICE" = "y" ]; then
        brew install --cask zed
    else
        echo "Zed is required for this script."
        exit 1
    fi
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is not installed. Please install it from https://brew.sh"
    exit 1
fi

if ! command -v xcode-build-server >/dev/null 2>&1; then
    echo "xcode-build-server is not installed. Would you like to install it with Homebrew? (y/n)"
    read INSTALL_CHOICE
    if [ "$INSTALL_CHOICE" = "y" ]; then
        brew install xcode-build-server
    else
        echo "xcode-build-server is required for this script."
        exit 1
    fi
fi

# ==========================================
# Setting up the build config in the project root
# ==========================================

echo "Please enter project path:"
read PROJECT_PATH

# Check if the provided path is a directory and contains an .xcodeproj
if [ ! -d "$PROJECT_PATH" ]; then
    echo "Error: '$PROJECT_PATH' is not a directory."
    exit 1
fi

XCODEPROJ_PATH=$(find "$PROJECT_PATH" -maxdepth 1 -name "*.xcodeproj" | head -n 1)
if [ -z "$XCODEPROJ_PATH" ]; then
    echo "Error: No .xcodeproj found in '$PROJECT_PATH'."
    exit 1
fi

PROJECT_NAME=$(basename "$XCODEPROJ_PATH" .xcodeproj)

cd "$PROJECT_PATH"

# Check if buildServer.json exists in the project root
if [ -f "buildServer.json" ]; then
    echo "buildServer.json already exists in the project root. Skipping creation."
else
    xcode-build-server config -project "$PROJECT_NAME.xcodeproj"
fi

# ==========================================
# Setting up Zed
# ==========================================

# Check if Zed config directory exists
if [ ! -d "$HOME/.config/zed" ]; then
    mkdir -p "$HOME/.config/zed"
fi

# Create settings.json if it doesn't exist
if [ ! -f "$HOME/.config/zed/settings.json" ]; then
    echo "{}" > "$HOME/.config/zed/settings.json"
fi

# Check if languages or Swift config already exists
if grep -q '"languages"' "$HOME/.config/zed/settings.json" || grep -q '"Swift"' "$HOME/.config/zed/settings.json"; then
    echo "Existing Swift/language settings found in Zed config. Would you like to overwrite them? (y/n)"
    read OVERWRITE_CHOICE
    if [ "$OVERWRITE_CHOICE" != "y" ]; then
        echo "Skipping Zed configuration update"
        exit 0
    fi
fi

# Merge new Swift config into existing settings.json without overwriting unrelated settings
TMP_FILE=$(mktemp)
jq '(.languages // {}) as $langs | .languages = ($langs + {
    "Swift": {
        "enable_language_server": true,
        "language_servers": ["sourcekit-lsp"],
        "formatter": "language_server",
        "format_on_save": "on"
    }
})' "$HOME/.config/zed/settings.json" > "$TMP_FILE"

# Replace original with merged config
mv "$TMP_FILE" "$HOME/.config/zed/settings.json"

echo "Zed configuration updated successfully"

# ==========================================P
# Prompt the user to open the project with Zed
# ==========================================

echo "Would you like to open the project with Zed now? (y/n)"
read OPEN_PROJECT_CHOICE
if [ "$OPEN_PROJECT_CHOICE" = "y" ]; then
    zed "$PROJECT_PATH"
fi
