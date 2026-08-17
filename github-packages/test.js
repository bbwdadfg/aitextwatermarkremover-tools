import test from "node:test";
import assert from "node:assert/strict";
import { removeInvisibleCharacters, scanInvisibleCharacters, stripMarkdownPasteResidue } from "./index.js";

test("scans common invisible characters with UTF-16 positions", () => {
  const findings = scanInvisibleCharacters("A\u200b😀\u202fB");
  assert.deepEqual(findings.map(({ codePoint, index }) => ({ codePoint, index })), [
    { codePoint: "U+200B", index: 1 },
    { codePoint: "U+202F", index: 4 }
  ]);
});

test("removes invisible characters without changing visible text", () => {
  assert.equal(removeInvisibleCharacters("A\u200b B\ufeff"), "A B");
});

test("tidies common Markdown paste residue", () => {
  assert.equal(stripMarkdownPasteResidue("## Heading\n- **Item**\n\\[link\\]"), "Heading\nItem\n[link]");
});
