import unittest

from atwrtools import remove_invisible_characters, scan_invisible_characters, strip_markdown_paste_residue


class AtwrToolsTest(unittest.TestCase):
    def test_scan_reports_codepoints_and_positions(self):
        findings = scan_invisible_characters("A\u200b\u202fB")
        self.assertEqual(
            [(item["codePoint"], item["index"]) for item in findings],
            [("U+200B", 1), ("U+202F", 2)],
        )

    def test_remove_preserves_visible_text(self):
        self.assertEqual(remove_invisible_characters("A\u200b B\ufeff"), "A B")

    def test_strip_markdown_residue(self):
        self.assertEqual(
            strip_markdown_paste_residue("## Heading\n- **Item**\n\\[link\\]"),
            "Heading\nItem\n[link]",
        )
