import AtwrTools
import qualified Data.Text as T
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)

main :: IO ()
main = do
  let findings = scanInvisibleCharacters (T.pack "A\x200B\x202F" <> T.pack "B")
  check (length findings == 2) "scan count"
  check (findingCodePoint (head findings) == "U+200B") "scan first"
  check (findingIndex (head findings) == 1) "scan index"
  check (removeInvisibleCharacters (T.pack "A\x200B B\xFEFF") == T.pack "A B") "remove"
  check (stripMarkdownPasteResidue (T.pack "## Heading\n- **Item**\n\\[link\\]") == T.pack "Heading\nItem\n[link]") "tidy"
  putStrLn "haskell tests ok"

check :: Bool -> String -> IO ()
check True _ = pure ()
check False label = hPutStrLn stderr ("failed: " ++ label) >> exitFailure
