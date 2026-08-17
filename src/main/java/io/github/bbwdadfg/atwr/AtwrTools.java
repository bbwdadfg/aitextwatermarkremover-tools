package io.github.bbwdadfg.atwr;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Local utilities for scanning and removing invisible Unicode characters.
 * Independent third-party helper inspired by https://aitextwatermarkremover.com/
 */
public final class AtwrTools {
    private static final Map<Integer, String> NAMES;

    static {
        Map<Integer, String> names = new LinkedHashMap<Integer, String>();
        names.put(0x00AD, "SOFT HYPHEN");
        names.put(0x034F, "COMBINING GRAPHEME JOINER");
        names.put(0x061C, "ARABIC LETTER MARK");
        names.put(0x115F, "HANGUL CHOSEONG FILLER");
        names.put(0x1160, "HANGUL JUNGSEONG FILLER");
        names.put(0x17B4, "KHMER VOWEL INHERENT AQ");
        names.put(0x17B5, "KHMER VOWEL INHERENT AA");
        names.put(0x180B, "MONGOLIAN FREE VARIATION SELECTOR ONE");
        names.put(0x180C, "MONGOLIAN FREE VARIATION SELECTOR TWO");
        names.put(0x180D, "MONGOLIAN FREE VARIATION SELECTOR THREE");
        names.put(0x180F, "MONGOLIAN FREE VARIATION SELECTOR FOUR");
        names.put(0x200B, "ZERO WIDTH SPACE");
        names.put(0x200C, "ZERO WIDTH NON-JOINER");
        names.put(0x200D, "ZERO WIDTH JOINER");
        names.put(0x200E, "LEFT-TO-RIGHT MARK");
        names.put(0x200F, "RIGHT-TO-LEFT MARK");
        names.put(0x202A, "LEFT-TO-RIGHT EMBEDDING");
        names.put(0x202B, "RIGHT-TO-LEFT EMBEDDING");
        names.put(0x202C, "POP DIRECTIONAL FORMATTING");
        names.put(0x202D, "LEFT-TO-RIGHT OVERRIDE");
        names.put(0x202E, "RIGHT-TO-LEFT OVERRIDE");
        names.put(0x202F, "NARROW NO-BREAK SPACE");
        names.put(0x205F, "MEDIUM MATHEMATICAL SPACE");
        names.put(0x2060, "WORD JOINER");
        names.put(0x2061, "FUNCTION APPLICATION");
        names.put(0x2062, "INVISIBLE TIMES");
        names.put(0x2063, "INVISIBLE SEPARATOR");
        names.put(0x2064, "INVISIBLE PLUS");
        names.put(0x2066, "LEFT-TO-RIGHT ISOLATE");
        names.put(0x2067, "RIGHT-TO-LEFT ISOLATE");
        names.put(0x2068, "FIRST STRONG ISOLATE");
        names.put(0x2069, "POP DIRECTIONAL ISOLATE");
        names.put(0x206A, "INHIBIT SYMMETRIC SWAPPING");
        names.put(0x206B, "ACTIVATE SYMMETRIC SWAPPING");
        names.put(0x206C, "INHIBIT ARABIC FORM SHAPING");
        names.put(0x206D, "ACTIVATE ARABIC FORM SHAPING");
        names.put(0x206E, "NATIONAL DIGIT SHAPES");
        names.put(0x206F, "NOMINAL DIGIT SHAPES");
        names.put(0xFE00, "VARIATION SELECTOR-1");
        names.put(0xFE01, "VARIATION SELECTOR-2");
        names.put(0xFE02, "VARIATION SELECTOR-3");
        names.put(0xFE03, "VARIATION SELECTOR-4");
        names.put(0xFE0E, "TEXT VARIATION SELECTOR-15");
        names.put(0xFE0F, "EMOJI VARIATION SELECTOR-16");
        names.put(0xFEFF, "ZERO WIDTH NO-BREAK SPACE");
        NAMES = Collections.unmodifiableMap(names);
    }

    private static final Pattern HEADING = Pattern.compile("(?m)^\\s{0,3}(?:#{1,6}|[-*+] |\\d+\\. |>)\\s?");
    private static final Pattern ESCAPED = Pattern.compile("\\\\([\\\\`*_{}\\[\\]()#+.!|>~-])");
    private static final Pattern WRAP = Pattern.compile("(\\*\\*|__|~~|`)");
    private static final Pattern TRAIL = Pattern.compile("[ \\t]+\\n");
    private static final Pattern BLANKS = Pattern.compile("\\n{3,}");

    private AtwrTools() {
    }

    /**
     * @param text input text
     * @return findings for invisible characters
     */
    public static List<Finding> scanInvisibleCharacters(String text) {
        List<Finding> findings = new ArrayList<Finding>();
        int index = 0;
        final int length = text.length();
        while (index < length) {
            int codePoint = text.codePointAt(index);
            String name = NAMES.get(codePoint);
            if (name != null) {
                findings.add(new Finding(index, new String(Character.toChars(codePoint)), String.format("U+%04X", codePoint), name));
            }
            index += Character.charCount(codePoint);
        }
        return findings;
    }

    /**
     * @param text input text
     * @return text with invisible characters removed
     */
    public static String removeInvisibleCharacters(String text) {
        StringBuilder builder = new StringBuilder(text.length());
        int index = 0;
        final int length = text.length();
        while (index < length) {
            int codePoint = text.codePointAt(index);
            if (!NAMES.containsKey(codePoint)) {
                builder.appendCodePoint(codePoint);
            }
            index += Character.charCount(codePoint);
        }
        return builder.toString();
    }

    /**
     * @param text Markdown-ish pasted text
     * @return text with common paste residue removed
     */
    public static String stripMarkdownPasteResidue(String text) {
        String cleaned = HEADING.matcher(text).replaceAll("");
        cleaned = ESCAPED.matcher(cleaned).replaceAll("$1");
        cleaned = WRAP.matcher(cleaned).replaceAll("");
        cleaned = TRAIL.matcher(cleaned).replaceAll("\n");
        return BLANKS.matcher(cleaned).replaceAll("\n\n");
    }

    /** One invisible-character match. */
    public static final class Finding {
        public final int index;
        public final String character;
        public final String codePoint;
        public final String name;

        /**
         * @param index UTF-16 index
         * @param character matched character
         * @param codePoint formatted code point
         * @param name Unicode name
         */
        public Finding(int index, String character, String codePoint, String name) {
            this.index = index;
            this.character = character;
            this.codePoint = codePoint;
            this.name = name;
        }
    }
}
