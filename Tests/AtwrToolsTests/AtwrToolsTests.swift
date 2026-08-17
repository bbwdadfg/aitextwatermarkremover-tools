import XCTest
@testable import AtwrTools

final class AtwrToolsTests: XCTestCase {
    func testScan() {
        let findings = AtwrTools.scanInvisibleCharacters("A\u{200B}\u{202F}B")
        XCTAssertEqual(findings.map(\.codePoint), ["U+200B", "U+202F"])
        XCTAssertEqual(findings.first?.index, 1)
    }

    func testRemove() {
        XCTAssertEqual(AtwrTools.removeInvisibleCharacters("A\u{200B} B\u{FEFF}"), "A B")
    }

    func testTidy() {
        XCTAssertEqual(
            AtwrTools.stripMarkdownPasteResidue("## Heading\n- **Item**\n\\[link\\]"),
            "Heading\nItem\n[link]"
        )
    }
}
