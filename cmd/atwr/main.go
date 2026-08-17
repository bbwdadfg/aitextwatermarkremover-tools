package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"strings"

	atwrtools "github.com/bbwdadfg/aitextwatermarkremover-tools"
)

const help = `Usage: atwr <command> [options] [file...]

Commands:
  scan   Detect invisible Unicode characters and print positions
  clean  Remove invisible characters, preserve visible text
  tidy   Strip common Markdown paste artifacts

Options:
  -o, --output <file>  Write result to file instead of stdout
  -h, --help           Show this help message

All processing is local. No network requests are made.
Independent third-party helper inspired by https://aitextwatermarkremover.com/
`

func main() {
	args := os.Args[1:]
	if len(args) == 0 || args[0] == "-h" || args[0] == "--help" {
		fmt.Print(help)
		return
	}
	command := args[0]
	outputPath := ""
	files := make([]string, 0)
	rest := args[1:]
	for i := 0; i < len(rest); i++ {
		if rest[i] == "-o" || rest[i] == "--output" {
			i++
			if i < len(rest) {
				outputPath = rest[i]
			}
			continue
		}
		if rest[i] == "-h" || rest[i] == "--help" {
			fmt.Print(help)
			return
		}
		files = append(files, rest[i])
	}
	input, err := readInput(files)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	var output string
	switch command {
	case "scan":
		raw, _ := json.MarshalIndent(atwrtools.ScanInvisibleCharacters(input), "", "  ")
		output = string(raw) + "\n"
	case "clean":
		output = atwrtools.RemoveInvisibleCharacters(input)
	case "tidy":
		output = atwrtools.StripMarkdownPasteResidue(input)
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n", command)
		os.Exit(2)
	}
	if outputPath != "" {
		if err := os.WriteFile(outputPath, []byte(output), 0o644); err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		return
	}
	fmt.Print(output)
}

func readInput(files []string) (string, error) {
	if len(files) == 0 {
		data, err := io.ReadAll(os.Stdin)
		return string(data), err
	}
	parts := make([]string, 0, len(files))
	for _, file := range files {
		data, err := os.ReadFile(file)
		if err != nil {
			return "", err
		}
		parts = append(parts, string(data))
	}
	return strings.Join(parts, "\n"), nil
}
