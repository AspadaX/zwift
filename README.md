# zwift

A simple shell script to set up Swift development for Zed IDE lovers on macOS.

## Purpose

This script helps you quickly configure your macOS environment for Swift development in the Zed IDE. It checks for required tools, sets up build configurations, and updates your Zed settings for Swift support.

## Usage

1. **Clone this repository or download the script.**

2. **Open your terminal and run:**
   ```sh
   ./main.sh
   ```

3. **Follow the prompts:**
   - The script will check for required dependencies (`zed`, `brew`, `xcode-build-server`) and help you install them if missing.
   - Enter the path to your Swift/Xcode project when asked.
   - The script will configure your Zed IDE for Swift development.
   - Optionally, you can open your project in Zed directly from the script.

## Requirements

- macOS
- [Zed IDE](https://zed.dev/)
- [Homebrew](https://brew.sh/)
- [xcode-build-server](https://github.com/ChimeHQ/xcode-build-server)
- [jq](https://stedolan.github.io/jq/) (for JSON manipulation, install via `brew install jq` if not present)

## Notes

- The script will prompt before overwriting any existing Swift/language settings in your Zed configuration.
- Make sure you have an Xcode project (`.xcodeproj`) in your project directory.

> **Acknowledgments:**  
> Special thanks to [creativewithin](https://creativewithin.medium.com/how-i-got-zed-editor-working-with-swift-projects-60ea78d4165e) for inspiration and guidance from their article on getting Zed Editor working with Swift projects.

---

Enjoy Swift development in Zed!