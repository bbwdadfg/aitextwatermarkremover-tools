"""Local utilities for invisible Unicode and Markdown paste residue."""

INVISIBLE_NAMES = {
    0x00AD: "SOFT HYPHEN", 0x034F: "COMBINING GRAPHEME JOINER", 0x061C: "ARABIC LETTER MARK",
    0x115F: "HANGUL CHOSEONG FILLER", 0x1160: "HANGUL JUNGSEONG FILLER",
    0x17B4: "KHMER VOWEL INHERENT AQ", 0x17B5: "KHMER VOWEL INHERENT AA",
    **{point: f"MONGOLIAN FREE VARIATION SELECTOR {point - 0x180A}" for point in (0x180B, 0x180C, 0x180D, 0x180F)},
    0x200B: "ZERO WIDTH SPACE", 0x200C: "ZERO WIDTH NON-JOINER", 0x200D: "ZERO WIDTH JOINER",
    0x200E: "LEFT-TO-RIGHT MARK", 0x200F: "RIGHT-TO-LEFT MARK",
    **{point: name for point, name in {
        0x202A: "LEFT-TO-RIGHT EMBEDDING", 0x202B: "RIGHT-TO-LEFT EMBEDDING",
        0x202C: "POP DIRECTIONAL FORMATTING", 0x202D: "LEFT-TO-RIGHT OVERRIDE",
        0x202E: "RIGHT-TO-LEFT OVERRIDE", 0x202F: "NARROW NO-BREAK SPACE",
        0x205F: "MEDIUM MATHEMATICAL SPACE", 0x2060: "WORD JOINER", 0x2061: "FUNCTION APPLICATION",
        0x2062: "INVISIBLE TIMES", 0x2063: "INVISIBLE SEPARATOR", 0x2064: "INVISIBLE PLUS",
        0x2066: "LEFT-TO-RIGHT ISOLATE", 0x2067: "RIGHT-TO-LEFT ISOLATE",
        0x2068: "FIRST STRONG ISOLATE", 0x2069: "POP DIRECTIONAL ISOLATE",
        0x206A: "INHIBIT SYMMETRIC SWAPPING", 0x206B: "ACTIVATE SYMMETRIC SWAPPING",
        0x206C: "INHIBIT ARABIC FORM SHAPING", 0x206D: "ACTIVATE ARABIC FORM SHAPING",
        0x206E: "NATIONAL DIGIT SHAPES", 0x206F: "NOMINAL DIGIT SHAPES",
        0xFE00: "VARIATION SELECTOR-1", 0xFE01: "VARIATION SELECTOR-2", 0xFE02: "VARIATION SELECTOR-3",
        0xFE03: "VARIATION SELECTOR-4", 0xFE0E: "TEXT VARIATION SELECTOR-15",
        0xFE0F: "EMOJI VARIATION SELECTOR-16", 0xFEFF: "ZERO WIDTH NO-BREAK SPACE",
    }.items()},
}


def _label(codepoint: int) -> str:
    return f"U+{codepoint:04X}"


def scan_invisible_characters(text: str) -> list[dict[str, object]]:
    return [
        {"index": index, "character": character, "codePoint": _label(ord(character)), "name": INVISIBLE_NAMES[ord(character)]}
        for index, character in enumerate(text)
        if ord(character) in INVISIBLE_NAMES
    ]


def remove_invisible_characters(text: str) -> str:
    return "".join(character for character in text if ord(character) not in INVISIBLE_NAMES)


def strip_markdown_paste_residue(text: str) -> str:
    import re
    text = re.sub(r"^\s{0,3}(?:#{1,6}|[-*+] |\d+\. |> )\s?", "", text, flags=re.MULTILINE)
    text = re.sub(r"\\([\\`*_{}\[\]()#+.!|>~-])", r"\1", text)
    text = re.sub(r"(\*\*|__|~~|`)", "", text)
    text = re.sub(r"[ \t]+\n", "\n", text)
    return re.sub(r"\n{3,}", "\n\n", text)
