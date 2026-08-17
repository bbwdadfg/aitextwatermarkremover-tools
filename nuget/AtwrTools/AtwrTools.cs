using System.Text.RegularExpressions;

namespace AtwrTools;

/// <summary>Local utilities for scanning and removing invisible Unicode characters.</summary>
public static class Tools
{
    private static readonly Dictionary<int, string> Names = new()
    {
        [0x00AD] = "SOFT HYPHEN",
        [0x034F] = "COMBINING GRAPHEME JOINER",
        [0x061C] = "ARABIC LETTER MARK",
        [0x115F] = "HANGUL CHOSEONG FILLER",
        [0x1160] = "HANGUL JUNGSEONG FILLER",
        [0x17B4] = "KHMER VOWEL INHERENT AQ",
        [0x17B5] = "KHMER VOWEL INHERENT AA",
        [0x180B] = "MONGOLIAN FREE VARIATION SELECTOR ONE",
        [0x180C] = "MONGOLIAN FREE VARIATION SELECTOR TWO",
        [0x180D] = "MONGOLIAN FREE VARIATION SELECTOR THREE",
        [0x180F] = "MONGOLIAN FREE VARIATION SELECTOR FOUR",
        [0x200B] = "ZERO WIDTH SPACE",
        [0x200C] = "ZERO WIDTH NON-JOINER",
        [0x200D] = "ZERO WIDTH JOINER",
        [0x200E] = "LEFT-TO-RIGHT MARK",
        [0x200F] = "RIGHT-TO-LEFT MARK",
        [0x202A] = "LEFT-TO-RIGHT EMBEDDING",
        [0x202B] = "RIGHT-TO-LEFT EMBEDDING",
        [0x202C] = "POP DIRECTIONAL FORMATTING",
        [0x202D] = "LEFT-TO-RIGHT OVERRIDE",
        [0x202E] = "RIGHT-TO-LEFT OVERRIDE",
        [0x202F] = "NARROW NO-BREAK SPACE",
        [0x205F] = "MEDIUM MATHEMATICAL SPACE",
        [0x2060] = "WORD JOINER",
        [0x2061] = "FUNCTION APPLICATION",
        [0x2062] = "INVISIBLE TIMES",
        [0x2063] = "INVISIBLE SEPARATOR",
        [0x2064] = "INVISIBLE PLUS",
        [0x2066] = "LEFT-TO-RIGHT ISOLATE",
        [0x2067] = "RIGHT-TO-LEFT ISOLATE",
        [0x2068] = "FIRST STRONG ISOLATE",
        [0x2069] = "POP DIRECTIONAL ISOLATE",
        [0x206A] = "INHIBIT SYMMETRIC SWAPPING",
        [0x206B] = "ACTIVATE SYMMETRIC SWAPPING",
        [0x206C] = "INHIBIT ARABIC FORM SHAPING",
        [0x206D] = "ACTIVATE ARABIC FORM SHAPING",
        [0x206E] = "NATIONAL DIGIT SHAPES",
        [0x206F] = "NOMINAL DIGIT SHAPES",
        [0xFE00] = "VARIATION SELECTOR-1",
        [0xFE01] = "VARIATION SELECTOR-2",
        [0xFE02] = "VARIATION SELECTOR-3",
        [0xFE03] = "VARIATION SELECTOR-4",
        [0xFE0E] = "TEXT VARIATION SELECTOR-15",
        [0xFE0F] = "EMOJI VARIATION SELECTOR-16",
        [0xFEFF] = "ZERO WIDTH NO-BREAK SPACE",
    };

    public sealed record Finding(int Index, string Character, string CodePoint, string Name);

    public static IReadOnlyList<Finding> ScanInvisibleCharacters(string text)
    {
        var findings = new List<Finding>();
        for (var index = 0; index < text.Length;)
        {
            var codePoint = char.ConvertToUtf32(text, index);
            if (Names.TryGetValue(codePoint, out var name))
            {
                findings.Add(new Finding(index, char.ConvertFromUtf32(codePoint), $"U+{codePoint:X4}", name));
            }
            index += char.IsSurrogatePair(text, index) ? 2 : 1;
        }
        return findings;
    }

    public static string RemoveInvisibleCharacters(string text)
    {
        var builder = new System.Text.StringBuilder(text.Length);
        for (var index = 0; index < text.Length;)
        {
            var codePoint = char.ConvertToUtf32(text, index);
            if (!Names.ContainsKey(codePoint))
            {
                builder.Append(char.ConvertFromUtf32(codePoint));
            }
            index += char.IsSurrogatePair(text, index) ? 2 : 1;
        }
        return builder.ToString();
    }

    public static string StripMarkdownPasteResidue(string text)
    {
        text = Regex.Replace(text, @"^\s{0,3}(?:#{1,6}|[-*+] |\d+\. |>)\s?", "", RegexOptions.Multiline);
        text = Regex.Replace(text, @"\\([\\`*_{}\[\]()#+.!|>~-])", "$1");
        text = Regex.Replace(text, @"(\*\*|__|~~|`)", "");
        text = Regex.Replace(text, @"[ \t]+\n", "\n");
        return Regex.Replace(text, @"\n{3,}", "\n\n");
    }
}
