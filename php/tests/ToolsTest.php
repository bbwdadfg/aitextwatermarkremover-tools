<?php
declare(strict_types=1);
require dirname(__DIR__) . '/src/Tools.php';
use Atwr\Tools;
function assert_same($expected, $actual, string $label): void {
    if ($expected !== $actual) {
        fwrite(STDERR, $label . ' expected ' . var_export($expected, true) . ' got ' . var_export($actual, true) . PHP_EOL);
        exit(1);
    }
}
$findings = Tools::scanInvisibleCharacters("A\u{200B}\u{202F}B");
assert_same(2, count($findings), 'count');
assert_same('U+200B', $findings[0]['codePoint'], 'first');
assert_same(1, $findings[0]['index'], 'index');
assert_same('A B', Tools::removeInvisibleCharacters("A\u{200B} B\u{FEFF}"), 'remove');
assert_same("Heading\nItem\n[link]", Tools::stripMarkdownPasteResidue("## Heading\n- **Item**\n\\[link\\]"), 'tidy');
echo "php tests ok\n";
