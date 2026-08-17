export interface Finding {
  index: number;
  character: string;
  codePoint: string;
  name: string;
}

const INVISIBLE_NAMES: Map<number, string> = new Map([
  [0x00ad, "SOFT HYPHEN"],
  [0x034f, "COMBINING GRAPHEME JOINER"],
  [0x061c, "ARABIC LETTER MARK"],
  [0x115f, "HANGUL CHOSEONG FILLER"],
  [0x1160, "HANGUL JUNGSEONG FILLER"],
  [0x17b4, "KHMER VOWEL INHERENT AQ"],
  [0x17b5, "KHMER VOWEL INHERENT AA"],
  [0x180b, "MONGOLIAN FREE VARIATION SELECTOR ONE"],
  [0x180c, "MONGOLIAN FREE VARIATION SELECTOR TWO"],
  [0x180d, "MONGOLIAN FREE VARIATION SELECTOR THREE"],
  [0x180f, "MONGOLIAN FREE VARIATION SELECTOR FOUR"],
  [0x200b, "ZERO WIDTH SPACE"],
  [0x200c, "ZERO WIDTH NON-JOINER"],
  [0x200d, "ZERO WIDTH JOINER"],
  [0x200e, "LEFT-TO-RIGHT MARK"],
  [0x200f, "RIGHT-TO-LEFT MARK"],
  [0x202a, "LEFT-TO-RIGHT EMBEDDING"],
  [0x202b, "RIGHT-TO-LEFT EMBEDDING"],
  [0x202c, "POP DIRECTIONAL FORMATTING"],
  [0x202d, "LEFT-TO-RIGHT OVERRIDE"],
  [0x202e, "RIGHT-TO-LEFT OVERRIDE"],
  [0x202f, "NARROW NO-BREAK SPACE"],
  [0x205f, "MEDIUM MATHEMATICAL SPACE"],
  [0x2060, "WORD JOINER"],
  [0x2061, "FUNCTION APPLICATION"],
  [0x2062, "INVISIBLE TIMES"],
  [0x2063, "INVISIBLE SEPARATOR"],
  [0x2064, "INVISIBLE PLUS"],
  [0x2066, "LEFT-TO-RIGHT ISOLATE"],
  [0x2067, "RIGHT-TO-LEFT ISOLATE"],
  [0x2068, "FIRST STRONG ISOLATE"],
  [0x2069, "POP DIRECTIONAL ISOLATE"],
  [0x206a, "INHIBIT SYMMETRIC SWAPPING"],
  [0x206b, "ACTIVATE SYMMETRIC SWAPPING"],
  [0x206c, "INHIBIT ARABIC FORM SHAPING"],
  [0x206d, "ACTIVATE ARABIC FORM SHAPING"],
  [0x206e, "NATIONAL DIGIT SHAPES"],
  [0x206f, "NOMINAL DIGIT SHAPES"],
  [0xfe00, "VARIATION SELECTOR-1"],
  [0xfe01, "VARIATION SELECTOR-2"],
  [0xfe02, "VARIATION SELECTOR-3"],
  [0xfe03, "VARIATION SELECTOR-4"],
  [0xfe0e, "TEXT VARIATION SELECTOR-15"],
  [0xfe0f, "EMOJI VARIATION SELECTOR-16"],
  [0xfeff, "ZERO WIDTH NO-BREAK SPACE"]
]);

function codePointLabel(codePoint: number): string {
  return `U+${codePoint.toString(16).toUpperCase().padStart(4, "0")}`;
}

export function scanInvisibleCharacters(text: string): Finding[] {
  const findings: Finding[] = [];
  let index = 0;
  for (const character of text) {
    const codePoint = character.codePointAt(0);
    if (codePoint === undefined) continue;
    const name = INVISIBLE_NAMES.get(codePoint);
    if (name) {
      findings.push({ index, character, codePoint: codePointLabel(codePoint), name });
    }
    index += character.length;
  }
  return findings;
}

export function removeInvisibleCharacters(text: string): string {
  return Array.from(text).filter((character) => {
    const codePoint = character.codePointAt(0);
    return codePoint === undefined || !INVISIBLE_NAMES.has(codePoint);
  }).join("");
}

export function stripMarkdownPasteResidue(text: string): string {
  return text
    .replace(/^\s{0,3}(?:#{1,6}|[-*+] |\d+\. |>)\s?/gm, "")
    .replace(/\\([\\`*_{}\[\]()#+.!|>~-])/g, "$1")
    .replace(/(\*\*|__|~~|`)/g, "")
    .replace(/[ \t]+\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n");
}

export { INVISIBLE_NAMES };
