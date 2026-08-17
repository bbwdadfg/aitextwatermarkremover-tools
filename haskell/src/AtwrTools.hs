{-# LANGUAGE OverloadedStrings #-}
module AtwrTools
  ( Finding (..)
  , scanInvisibleCharacters
  , removeInvisibleCharacters
  , stripMarkdownPasteResidue
  ) where

import Data.Char (ord)
import qualified Data.Text as T

data Finding = Finding
  { findingIndex :: Int
  , findingCharacter :: Char
  , findingCodePoint :: String
  , findingName :: String
  } deriving (Eq, Show)

names :: [(Int, String)]
names =
  [
    (0x00AD, "SOFT HYPHEN"),
    (0x034F, "COMBINING GRAPHEME JOINER"),
    (0x061C, "ARABIC LETTER MARK"),
    (0x115F, "HANGUL CHOSEONG FILLER"),
    (0x1160, "HANGUL JUNGSEONG FILLER"),
    (0x17B4, "KHMER VOWEL INHERENT AQ"),
    (0x17B5, "KHMER VOWEL INHERENT AA"),
    (0x180B, "MONGOLIAN FREE VARIATION SELECTOR ONE"),
    (0x180C, "MONGOLIAN FREE VARIATION SELECTOR TWO"),
    (0x180D, "MONGOLIAN FREE VARIATION SELECTOR THREE"),
    (0x180F, "MONGOLIAN FREE VARIATION SELECTOR FOUR"),
    (0x200B, "ZERO WIDTH SPACE"),
    (0x200C, "ZERO WIDTH NON-JOINER"),
    (0x200D, "ZERO WIDTH JOINER"),
    (0x200E, "LEFT-TO-RIGHT MARK"),
    (0x200F, "RIGHT-TO-LEFT MARK"),
    (0x202A, "LEFT-TO-RIGHT EMBEDDING"),
    (0x202B, "RIGHT-TO-LEFT EMBEDDING"),
    (0x202C, "POP DIRECTIONAL FORMATTING"),
    (0x202D, "LEFT-TO-RIGHT OVERRIDE"),
    (0x202E, "RIGHT-TO-LEFT OVERRIDE"),
    (0x202F, "NARROW NO-BREAK SPACE"),
    (0x205F, "MEDIUM MATHEMATICAL SPACE"),
    (0x2060, "WORD JOINER"),
    (0x2061, "FUNCTION APPLICATION"),
    (0x2062, "INVISIBLE TIMES"),
    (0x2063, "INVISIBLE SEPARATOR"),
    (0x2064, "INVISIBLE PLUS"),
    (0x2066, "LEFT-TO-RIGHT ISOLATE"),
    (0x2067, "RIGHT-TO-LEFT ISOLATE"),
    (0x2068, "FIRST STRONG ISOLATE"),
    (0x2069, "POP DIRECTIONAL ISOLATE"),
    (0x206A, "INHIBIT SYMMETRIC SWAPPING"),
    (0x206B, "ACTIVATE SYMMETRIC SWAPPING"),
    (0x206C, "INHIBIT ARABIC FORM SHAPING"),
    (0x206D, "ACTIVATE ARABIC FORM SHAPING"),
    (0x206E, "NATIONAL DIGIT SHAPES"),
    (0x206F, "NOMINAL DIGIT SHAPES"),
    (0xFE00, "VARIATION SELECTOR-1"),
    (0xFE01, "VARIATION SELECTOR-2"),
    (0xFE02, "VARIATION SELECTOR-3"),
    (0xFE03, "VARIATION SELECTOR-4"),
    (0xFE0E, "TEXT VARIATION SELECTOR-15"),
    (0xFE0F, "EMOJI VARIATION SELECTOR-16"),
    (0xFEFF, "ZERO WIDTH NO-BREAK SPACE")
  ]

lookupName :: Char -> Maybe String
lookupName ch = lookup (ord ch) names

scanInvisibleCharacters :: T.Text -> [Finding]
scanInvisibleCharacters text = reverse $ snd $ T.foldl' step (0, []) text
  where
    step (idx, acc) ch =
      let next = idx + utf8Len ch
       in case lookupName ch of
            Just name -> (next, Finding idx ch (printfCode ch) name : acc)
            Nothing -> (next, acc)

removeInvisibleCharacters :: T.Text -> T.Text
removeInvisibleCharacters = T.filter (maybe True (const False) . lookupName)

stripMarkdownPasteResidue :: T.Text -> T.Text
stripMarkdownPasteResidue = T.intercalate (T.singleton '\n') . map stripLine . T.lines

stripLine :: T.Text -> T.Text
stripLine line =
  let noHead = dropPrefix line
      unescaped = T.replace "\\[" "[" (T.replace "\\]" "]" noHead)
      noWrap = T.filter (/= '`') . T.replace "**" "" . T.replace "__" "" . T.replace "~~" "" $ unescaped
   in T.dropWhileEnd (`elem` [' ', '\t']) noWrap

dropPrefix :: T.Text -> T.Text
dropPrefix line
  | T.isPrefixOf "# " stripped || T.isPrefixOf "## " stripped || T.isPrefixOf "### " stripped = T.drop 1 (T.dropWhile (== '#') stripped)
  | T.isPrefixOf "- " stripped || T.isPrefixOf "* " stripped || T.isPrefixOf "+ " stripped = T.drop 2 stripped
  | otherwise = stripped
  where
    stripped = T.dropWhile (`elem` [' ', '\t']) line

printfCode :: Char -> String
printfCode ch = "U+" ++ pad4 (showHex (ord ch))

pad4 :: String -> String
pad4 s = replicate (max 0 (4 - length s)) '0' ++ s

showHex :: Int -> String
showHex n
  | n < 16 = [hexDigit n]
  | otherwise = showHex (n `div` 16) ++ [hexDigit (n `mod` 16)]

hexDigit :: Int -> Char
hexDigit n
  | n < 10 = toEnum (fromEnum '0' + n)
  | otherwise = toEnum (fromEnum 'A' + n - 10)

utf8Len :: Char -> Int
utf8Len ch
  | ord ch < 0x80 = 1
  | ord ch < 0x800 = 2
  | ord ch < 0x10000 = 3
  | otherwise = 4
