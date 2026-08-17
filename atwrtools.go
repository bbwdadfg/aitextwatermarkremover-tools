// Package atwrtools provides local utilities for scanning and removing invisible Unicode characters from text. It is an independent third-party helper and not affiliated with aitextwatermarkremover.com.
package atwrtools

import "fmt"

var invisibleNames = map[rune]string{
	'\u00ad': "SOFT HYPHEN", '\u034f': "COMBINING GRAPHEME JOINER", '\u061c': "ARABIC LETTER MARK",
	'\u200b': "ZERO WIDTH SPACE", '\u200c': "ZERO WIDTH NON-JOINER", '\u200d': "ZERO WIDTH JOINER",
	'\u200e': "LEFT-TO-RIGHT MARK", '\u200f': "RIGHT-TO-LEFT MARK", '\u202a': "LEFT-TO-RIGHT EMBEDDING",
	'\u202b': "RIGHT-TO-LEFT EMBEDDING", '\u202c': "POP DIRECTIONAL FORMATTING", '\u202d': "LEFT-TO-RIGHT OVERRIDE",
	'\u202e': "RIGHT-TO-LEFT OVERRIDE", '\u202f': "NARROW NO-BREAK SPACE", '\u205f': "MEDIUM MATHEMATICAL SPACE",
	'\u2060': "WORD JOINER", '\u2061': "FUNCTION APPLICATION", '\u2062': "INVISIBLE TIMES",
	'\u2063': "INVISIBLE SEPARATOR", '\u2064': "INVISIBLE PLUS", '\u2066': "LEFT-TO-RIGHT ISOLATE",
	'\u2067': "RIGHT-TO-LEFT ISOLATE", '\u2068': "FIRST STRONG ISOLATE", '\u2069': "POP DIRECTIONAL ISOLATE",
	'\ufeff': "ZERO WIDTH NO-BREAK SPACE",
}

type Finding struct {
	Index     int
	Character rune
	CodePoint string
	Name      string
}

func ScanInvisibleCharacters(text string) []Finding {
	findings := make([]Finding, 0)
	for index, character := range text {
		if name, ok := invisibleNames[character]; ok {
			findings = append(findings, Finding{Index: index, Character: character, CodePoint: fmt.Sprintf("U+%04X", character), Name: name})
		}
	}
	return findings
}

func RemoveInvisibleCharacters(text string) string {
	result := make([]rune, 0, len([]rune(text)))
	for _, character := range text {
		if _, ok := invisibleNames[character]; !ok {
			result = append(result, character)
		}
	}
	return string(result)
}
