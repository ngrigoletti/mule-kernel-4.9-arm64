# Mule Kernel 4.9 on macOS ARM64

This repository contains a small setup script that prepares Mule Kernel 4.9.0 to run on Apple Silicon (ARM64) macOS by installing the appropriate Tanuki Java Service Wrapper binaries and patching Mule’s startup script.

## What the script does
- Downloads Mule Kernel runtime `4.9.0` from MuleSoft’s releases.
- Downloads Tanuki Wrapper `3.5.51` for `macosx arm 64`.
- Installs the Wrapper binary, native library, and JAR into Mule’s `lib/boot/tanuki` structure with the filenames Mule expects.
- Cleans up downloaded archives and temporary directories.
- Patches `bin/mule` to recognize `arm64` and set `DIST_ARCH=arm` and `DIST_BITS=64` (uses GNU `sed` a.k.a. `gsed`).

## Requirements
- macOS on Apple Silicon (ARM64).
- `curl` and `tar` available in your shell.
- GNU sed (`gsed`). If you use Homebrew: `brew install gnu-sed`.
- Network access to download from MuleSoft and Tanuki.

## Usage
```bash
# Make the script executable (once)
chmod +x setup-mule-arm64.sh

# Run it from an empty or working directory
./setup-mule-arm64.sh
```
After it completes, you’ll have a ready-to-run Mule installation at:
```
./mule-standalone-4.9.0
```
You can start Mule with:
```bash
./mule-standalone-4.9.0/bin/mule start
```

### Note on gsed (non‑standard on macOS)
macOS ships BSD `sed`, which differs from GNU `sed`. This script explicitly calls `gsed` because it relies on GNU behavior. Install via Homebrew:
```bash
brew install gnu-sed
```
Homebrew provides the binary as `gsed`. Optional: add GNU sed to your PATH so `sed` resolves to GNU sed in your shell:
```bash
echo 'export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```
This is optional—the script runs fine as long as `gsed` exists on your PATH.

## Customization
The versions and platform triplet are defined at the top of the script. Edit these variables if you need a different Mule or Tanuki version or platform:
```sh
MULE_VERSION=4.9.0
TANUKI_VERSION=3.5.51
TANUKI_SO=macosx
TANUKI_CPU=arm
TANUKI_BIT=64
```
Note: `wrapper.jar` is deliberately copied as `wrapper-3.2.3.jar` to match the filename Mule expects in its classpath.

## Output layout
Key files placed/updated under `mule-standalone-<version>/`:
- `lib/boot/tanuki/libwrapper-macosx-arm-64.*` – native library.
- `lib/boot/tanuki/wrapper-3.2.3.jar` – Wrapper JAR.
- `lib/boot/tanuki/exec/wrapper-macosx-arm-64` – Wrapper binary.
- `bin/mule` – patched to handle `arm64`.

## Troubleshooting
- gsed not found: install via Homebrew `brew install gnu-sed` and re-run.
- Permission denied: ensure the script is executable: `chmod +x setup-mule-arm64.sh`.
- Network/download errors: re-run the script; it downloads to the current directory.
- Verify binary architecture:
  ```bash
  file mule-standalone-4.9.0/lib/boot/tanuki/exec/wrapper-macosx-arm-64
  ```

## Notes
- The script writes and extracts files into the current working directory.
- It removes downloaded `.tar.gz` archives and the extracted Wrapper folder after installation to keep things tidy.
