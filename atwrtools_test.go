package atwrtools

import "testing"

func TestScanInvisibleCharacters(t *testing.T) {
	findings := ScanInvisibleCharacters("A\u200b\u202fB")
	if len(findings) != 2 || findings[0].CodePoint != "U+200B" || findings[0].Index != 1 || findings[1].CodePoint != "U+202F" {
		t.Fatalf("unexpected findings: %#v", findings)
	}
}

func TestRemoveInvisibleCharacters(t *testing.T) {
	if got := RemoveInvisibleCharacters("A\u200b B\ufeff"); got != "A B" {
		t.Fatalf("got %q", got)
	}
}

func TestStripMarkdownPasteResidue(t *testing.T) {
	got := StripMarkdownPasteResidue("## Heading\n- **Item**\n\\[link\\]")
	if got != "Heading\nItem\n[link]" {
		t.Fatalf("got %q", got)
	}
}
