package io.github.bbwdadfg.atwr;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.Test;

class AtwrToolsTest {
    @Test
    void scanReportsCodepointsAndPositions() {
        List<AtwrTools.Finding> findings = AtwrTools.scanInvisibleCharacters("A\u200b\u202fB");
        assertEquals(2, findings.size());
        assertEquals("U+200B", findings.get(0).codePoint);
        assertEquals(1, findings.get(0).index);
        assertEquals("U+202F", findings.get(1).codePoint);
    }

    @Test
    void removePreservesVisibleText() {
        assertEquals("A B", AtwrTools.removeInvisibleCharacters("A\u200b B\ufeff"));
    }

    @Test
    void tidyMarkdownResidue() {
        assertEquals("Heading\nItem\n[link]", AtwrTools.stripMarkdownPasteResidue("## Heading\n- **Item**\n\\[link\\]"));
    }
}
