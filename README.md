# aitextwatermarkremover-tools

Local command-line utilities for scanning and removing invisible Unicode characters from text files.

Inspired by [aitextwatermarkremover.com](https://aitextwatermarkremover.com/), this is an **independent third-party helper** and is not an official SDK or affiliated with that website.

## Features

- **Scan** – Detect invisible Unicode characters (zero-width spaces, joiners, soft hyphens, etc.) and report their positions.
- **Clean** – Remove detected invisible characters while preserving all visible text.
- **Markdown tidy** – Strip common Markdown paste artifacts such as escaped brackets, redundant backslashes, and stray line breaks.

## Non-features

This tool does **not**:

- Make network requests. Everything runs locally.
- Rewrite or paraphrase text.
- Guarantee bypass of any AI detection system.

## Install

```bash
# Node
npm install -g aitextwatermarkremover-tools

# Python
pip install aitextwatermarkremover-tools

# Go
go install github.com/bbwdadfg/aitextwatermarkremover-tools/cmd/atwr@v0.1.0
```

Language libraries for PHP, Rust, Ruby, Dart, Java, .NET, Swift, Lua, Perl, and Haskell live in this same repository and expose the same three functions.

## Usage

```bash
atwr scan file.txt
atwr clean file.txt -o cleaned.txt
atwr tidy file.md
```

Pass `--help` for full option listing.

## License

MIT
