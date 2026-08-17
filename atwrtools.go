// Package atwrtools provides local utilities for scanning and removing invisible Unicode characters from text. It is an independent third-party helper and not affiliated with aitextwatermarkremover.com.
package atwrtools

import (
	"fmt"
	"regexp"
	"strings"
)

var invisibleNames = map[rune]string{
	'\u00ad': "SOFT HYPHEN",
	'\u034f': "COMBINING GRAPHEME JOINER",
	'\u061c': "ARABIC LETTER MARK",
	'\u115f': "HANGUL CHOSEONG FILLER",
	'\u1160': "HANGUL JUNGSEONG FILLER",
	'\u17b4': "KHMER VOWEL INHERENT AQ",
	'\u17b5': "KHMER VOWEL INHERENT AA",
	'\u180b': "MONGOLIAN FREE VARIATION SELECTOR ONE",
	'\u180c': "MONGOLIAN FREE VARIATION SELECTOR TWO",
	'\u180d': "MONGOLIAN FREE VARIATION SELECTOR THREE",
	'\u180f': "MONGOLIAN FREE VARIATION SELECTOR FOUR",
	'\u200b': "ZERO WIDTH SPACE",
	'\u200c': "ZERO WIDTH NON-JOINER",
	'\u200d': "ZERO WIDTH JOINER",
	'\u200e': "LEFT-TO-RIGHT MARK",
	'\u200f': "RIGHT-TO-LEFT MARK",
	'\u202a': "LEFT-TO-RIGHT EMBEDDING",
	'\u202b': "RIGHT-TO-LEFT EMBEDDING",
	'\u202c': "POP DIRECTIONAL FORMATTING",
	'\u202d': "LEFT-TO-RIGHT OVERRIDE",
	'\u202e': "RIGHT-TO-LEFT OVERRIDE",
	'\u202f': "NARROW NO-BREAK SPACE",
	'\u205f': "MEDIUM MATHEMATICAL SPACE",
	'\u2060': "WORD JOINER",
	'\u2061': "FUNCTION APPLICATION",
	'\u2062': "INVISIBLE TIMES",
	'\u2063': "INVISIBLE SEPARATOR",
	'\u2064': "INVISIBLE PLUS",
	'\u2066': "LEFT-TO-RIGHT ISOLATE",
	'\u2067': "RIGHT-TO-LEFT ISOLATE",
	'\u2068': "FIRST STRONG ISOLATE",
	'\u2069': "POP DIRECTIONAL ISOLATE",
	'\u206a': "INHIBIT SYMMETRIC SWAPPING",
	'\u206b': "ACTIVATE SYMMETRIC SWAPPING",
	'\u206c': "INHIBIT ARABIC FORM SHAPING",
	'\u206d': "ACTIVATE ARABIC FORM SHAPING",
	'\u206e': "NATIONAL DIGIT SHAPES",
	'\u206f': "NOMINAL DIGIT SHAPES",
	'\ufe00': "VARIATION SELECTOR-1",
	'\ufe01': "VARIATION SELECTOR-2",
	'\ufe02': "VARIATION SELECTOR-3",
	'\ufe03': "VARIATION SELECTOR-4",
	'\ufe0e': "TEXT VARIATION SELECTOR-15",
	'\ufe0f': "EMOJI VARIATION SELECTOR-16",
	'\ufeff': "ZERO WIDTH NO-BREAK SPACE",
}

// Finding is one invisible-character match.
type Finding struct {
	Index     int
	Character rune
	CodePoint string
	Name      string
}

// ScanInvisibleCharacters reports invisible Unicode characters and their byte offsets.
func ScanInvisibleCharacters(text string) []Finding {
	findings := make([]Finding, 0)
	for index, character := range text {
		if name, ok := invisibleNames[character]; ok {
			findings = append(findings, Finding{Index: index, Character: character, CodePoint: fmt.Sprintf("U+%04X", character), Name: name})
		}
	}
	return findings
}

// RemoveInvisibleCharacters deletes invisible characters and keeps visible text.
func RemoveInvisibleCharacters(text string) string {
	var builder strings.Builder
	builder.Grow(len(text))
	for _, character := range text {
		if _, ok := invisibleNames[character]; !ok {
			builder.WriteRune(character)
		}
	}
	return builder.String()
}

var (
	headingOrList = regexp.MustCompile(`(?m)^\s{0,3}(?:#{1,6}|[-*+] |\d+\. |>)\s?`)
	trailingSpace = regexp.MustCompile(`[ \t]+\n`)
	mdUnescape    = strings.NewReplacer(
		`\\`, `\`,
		`\*`, `*`,
		`\_`, `_`,
		`\{`, `{`,
		`\}`, `}`,
		`\[`, `[`,
		`\]`, `]`,
		`\(`, `(`,
		`\)`, `)`,
		`\#`, `#`,
		`\+`, `+`,
		`\.`, `.`,
		`\!`, `!`,
		`\|`, `|`,
		`\>`, `>`,
		`\~`, `~`,
		`\-`, `-`,
	)
)

// StripMarkdownPasteResidue removes common Markdown paste artifacts.
func StripMarkdownPasteResidue(text string) string {
	text = headingOrList.ReplaceAllString(text, "")
	text = mdUnescape.Replace(text)
	text = strings.ReplaceAll(text, "**", "")
	text = strings.ReplaceAll(text, "__", "")
	text = strings.ReplaceAll(text, "~~", "")
	text = strings.ReplaceAll(text, "`", "")
	text = trailingSpace.ReplaceAllString(text, "\n")
	for strings.Contains(text, "\n\n\n") {
		text = strings.ReplaceAll(text, "\n\n\n", "\n\n")
	}
	return text
}
