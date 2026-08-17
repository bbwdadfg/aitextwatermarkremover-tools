import { assertEquals } from "jsr:@std/assert@1";
import { removeInvisibleCharacters, scanInvisibleCharacters, stripMarkdownPasteResidue } from "./mod.ts";

Deno.test("scan", () => {
  const findings = scanInvisibleCharacters("A\u200b\u202fB");
  assertEquals(findings.map((item) => item.codePoint), ["U+200B", "U+202F"]);
  assertEquals(findings[0].index, 1);
});

Deno.test("remove", () => {
  assertEquals(removeInvisibleCharacters("A\u200b B\ufeff"), "A B");
});

Deno.test("tidy", () => {
  assertEquals(stripMarkdownPasteResidue("## Heading\n- **Item**\n\\[link\\]"), "Heading\nItem\n[link]");
});
