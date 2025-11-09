# 🎸 PsarcPipeline
PsarcPipeline is a PowerShell-based automation tool designed to streamline the process of editing Rocksmith Guitarcade games. It handles everything from unpacking `.psarc` files to repacking and deploying them—so you can focus on modding, not manual file wrangling.

# 🚀 Features
- Tools: Automatically downloads and installs required utilities:
    - 7zip
    - RocksmithToolbox
- Clear: Cleans up the `Output` and `Source` directories to ensure a fresh build environment.
- Expand:
    - Unpacks .psarc files from the `Input` folder into `Source/Stage1` using RocksmithToolbox
    - Extracts .xblock files from `Source/Stage1` into `Source/Stage2`
- Compress:
    - Repackages `Source/Stage2` into a new `.xblock` file using 7-Zip
    - Rebuilds the `.psarc` file from ᚦ and places it in the `Output` folder
- Deploy:
    - Renames the existing `.psarc` file in the Rocksmith directory with a timestamp and `.bak` extension
    - Copies the new `.psarc` file from `Output` into the Rocksmith game directory
- Start Rocksmith: Launches the Rocksmith game directly from the script

# 📂 Directory Structure
```powershell
PsarcPipeline/
├── .vscode/            # VS Code tasks and workspace settings
├── Input/              # Place original .psarc files here
├── Output/             # Final .psarc builds are saved here
├── Scripts/            # Additional helper scripts and utilities
├── Source/
│   ├── Stage1/         # Unpacked .psarc contents
│   └── Stage2/         # Unpacked .xblock contents
├── Tools/              # Utilities (7-Zip, RocksmithToolbox)
```

# ⚙️ Requirements
- Windows OS
- PowerShell 5.0+
- Internet connection (for downloading tools)
- Installed Rocksmith game

# 📦 Installation
Clone this repository:
```bash
git clone https://github.com/yourusername/PsarcPipeline.git
cd PsarcPipeline
```

# 🎯 Use Cases
- Modify Guitarcade mini-games
- Patch or replace assets in `.psarc` files
- Automate testing of game changes
- Backup and restore original game files

# 🧠 Notes
- Always back up your original `.psarc` files before deploying changes.
- This tool is intended for educational and personal use only. Respect copyright laws and game licensing agreements.