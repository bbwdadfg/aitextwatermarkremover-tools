import "package:aitextwatermarkremover_tools/aitextwatermarkremover_tools.dart";
import "package:test/test.dart";

void main() {
  test("scan reports codepoints and positions", () {
    final findings = scanInvisibleCharacters("A\u200b\u202fB");
    expect(findings.map((item) => item.codePoint).toList(), ["U+200B", "U+202F"]);
    expect(findings.first.index, 1);
  });

  test("remove preserves visible text", () {
    expect(removeInvisibleCharacters("A\u200b B\ufeff"), "A B");
  });

  test("tidy markdown paste residue", () {
    expect(
      stripMarkdownPasteResidue("## Heading\n- **Item**\n\\[link\\]"),
      "Heading\nItem\n[link]",
    );
  });
}
