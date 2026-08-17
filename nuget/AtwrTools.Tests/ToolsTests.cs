using Xunit;

namespace AtwrTools.Tests;

public class ToolsTests
{
    [Fact]
    public void ScanReportsCodepointsAndPositions()
    {
        var findings = Tools.ScanInvisibleCharacters("A\u200b\u202fB");
        Assert.Equal(new[] { "U+200B", "U+202F" }, findings.Select(item => item.CodePoint));
        Assert.Equal(1, findings[0].Index);
    }

    [Fact]
    public void RemovePreservesVisibleText()
    {
        Assert.Equal("A B", Tools.RemoveInvisibleCharacters("A\u200b B\ufeff"));
    }

    [Fact]
    public void TidyMarkdownResidue()
    {
        Assert.Equal("Heading\nItem\n[link]", Tools.StripMarkdownPasteResidue("## Heading\n- **Item**\n\\[link\\]"));
    }
}
