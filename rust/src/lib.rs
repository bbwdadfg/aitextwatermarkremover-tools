//! Local utilities for scanning and removing invisible Unicode characters.
//! Independent third-party helper inspired by https://aitextwatermarkremover.com/

use regex::Regex;
use std::collections::HashMap;
use std::sync::OnceLock;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Finding {
    pub index: usize,
    pub character: char,
    pub code_point: String,
    pub name: String,
}

fn names() -> &'static HashMap<char, &'static str> {
    static NAMES: OnceLock<HashMap<char, &'static str>> = OnceLock::new();
    NAMES.get_or_init(|| {
        HashMap::from([
            ('\u{00AD}', "SOFT HYPHEN"),
            ('\u{034F}', "COMBINING GRAPHEME JOINER"),
            ('\u{061C}', "ARABIC LETTER MARK"),
            ('\u{115F}', "HANGUL CHOSEONG FILLER"),
            ('\u{1160}', "HANGUL JUNGSEONG FILLER"),
            ('\u{17B4}', "KHMER VOWEL INHERENT AQ"),
            ('\u{17B5}', "KHMER VOWEL INHERENT AA"),
            ('\u{180B}', "MONGOLIAN FREE VARIATION SELECTOR ONE"),
            ('\u{180C}', "MONGOLIAN FREE VARIATION SELECTOR TWO"),
            ('\u{180D}', "MONGOLIAN FREE VARIATION SELECTOR THREE"),
            ('\u{180F}', "MONGOLIAN FREE VARIATION SELECTOR FOUR"),
            ('\u{200B}', "ZERO WIDTH SPACE"),
            ('\u{200C}', "ZERO WIDTH NON-JOINER"),
            ('\u{200D}', "ZERO WIDTH JOINER"),
            ('\u{200E}', "LEFT-TO-RIGHT MARK"),
            ('\u{200F}', "RIGHT-TO-LEFT MARK"),
            ('\u{202A}', "LEFT-TO-RIGHT EMBEDDING"),
            ('\u{202B}', "RIGHT-TO-LEFT EMBEDDING"),
            ('\u{202C}', "POP DIRECTIONAL FORMATTING"),
            ('\u{202D}', "LEFT-TO-RIGHT OVERRIDE"),
            ('\u{202E}', "RIGHT-TO-LEFT OVERRIDE"),
            ('\u{202F}', "NARROW NO-BREAK SPACE"),
            ('\u{205F}', "MEDIUM MATHEMATICAL SPACE"),
            ('\u{2060}', "WORD JOINER"),
            ('\u{2061}', "FUNCTION APPLICATION"),
            ('\u{2062}', "INVISIBLE TIMES"),
            ('\u{2063}', "INVISIBLE SEPARATOR"),
            ('\u{2064}', "INVISIBLE PLUS"),
            ('\u{2066}', "LEFT-TO-RIGHT ISOLATE"),
            ('\u{2067}', "RIGHT-TO-LEFT ISOLATE"),
            ('\u{2068}', "FIRST STRONG ISOLATE"),
            ('\u{2069}', "POP DIRECTIONAL ISOLATE"),
            ('\u{206A}', "INHIBIT SYMMETRIC SWAPPING"),
            ('\u{206B}', "ACTIVATE SYMMETRIC SWAPPING"),
            ('\u{206C}', "INHIBIT ARABIC FORM SHAPING"),
            ('\u{206D}', "ACTIVATE ARABIC FORM SHAPING"),
            ('\u{206E}', "NATIONAL DIGIT SHAPES"),
            ('\u{206F}', "NOMINAL DIGIT SHAPES"),
            ('\u{FE00}', "VARIATION SELECTOR-1"),
            ('\u{FE01}', "VARIATION SELECTOR-2"),
            ('\u{FE02}', "VARIATION SELECTOR-3"),
            ('\u{FE03}', "VARIATION SELECTOR-4"),
            ('\u{FE0E}', "TEXT VARIATION SELECTOR-15"),
            ('\u{FE0F}', "EMOJI VARIATION SELECTOR-16"),
            ('\u{FEFF}', "ZERO WIDTH NO-BREAK SPACE"),
        ])
    })
}

pub fn scan_invisible_characters(text: &str) -> Vec<Finding> {
    let mut findings = Vec::new();
    for (index, character) in text.char_indices() {
        if let Some(name) = names().get(&character) {
            findings.push(Finding {
                index,
                character,
                code_point: format!("U+{:04X}", character as u32),
                name: (*name).to_string(),
            });
        }
    }
    findings
}

pub fn remove_invisible_characters(text: &str) -> String {
    text.chars()
        .filter(|character| !names().contains_key(character))
        .collect()
}

pub fn strip_markdown_paste_residue(text: &str) -> String {
    static HEADING: OnceLock<Regex> = OnceLock::new();
    static ESCAPED: OnceLock<Regex> = OnceLock::new();
    static WRAP: OnceLock<Regex> = OnceLock::new();
    static TRAIL: OnceLock<Regex> = OnceLock::new();
    let text = HEADING
        .get_or_init(|| Regex::new(r"(?m)^\s{0,3}(?:#{1,6}|[-*+] |\d+\. |>)\s?").unwrap())
        .replace_all(text, "");
    let text = ESCAPED
        .get_or_init(|| Regex::new(r"\\([\\`*_{}\[\]()#+.!|>~-])").unwrap())
        .replace_all(&text, "$1");
    let text = WRAP
        .get_or_init(|| Regex::new(r"(\*\*|__|~~|`)").unwrap())
        .replace_all(&text, "");
    let text = TRAIL
        .get_or_init(|| Regex::new(r"[ \t]+\n").unwrap())
        .replace_all(&text, "\n");
    let mut out = text.into_owned();
    while out.contains("\n\n\n") {
        out = out.replace("\n\n\n", "\n\n");
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn scan_reports_codepoints_and_positions() {
        let findings = scan_invisible_characters("A\u{200B}\u{202F}B");
        assert_eq!(findings[0].code_point, "U+200B");
        assert_eq!(findings[0].index, 1);
        assert_eq!(findings[1].code_point, "U+202F");
    }

    #[test]
    fn remove_preserves_visible_text() {
        assert_eq!(remove_invisible_characters("A\u{200B} B\u{FEFF}"), "A B");
    }

    #[test]
    fn tidy_markdown() {
        assert_eq!(
            strip_markdown_paste_residue("## Heading\n- **Item**\n\\[link\\]"),
            "Heading\nItem\n[link]"
        );
    }
}
