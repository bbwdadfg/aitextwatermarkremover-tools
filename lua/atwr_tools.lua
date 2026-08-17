-- Local utilities for scanning and removing invisible Unicode characters.
local M = {}
local NAMES = {
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
}

local function utf8_iter(text)
  return text:gmatch("[%z\1-\127\194-\244][\128-\191]*")
end

local function codepoint(character)
  local b1, b2, b3, b4 = character:byte(1, 4)
  if not b2 then
    return b1
  elseif not b3 then
    return (b1 - 0xC0) * 0x40 + (b2 - 0x80)
  elseif not b4 then
    return (b1 - 0xE0) * 0x1000 + (b2 - 0x80) * 0x40 + (b3 - 0x80)
  end
  return (b1 - 0xF0) * 0x40000 + (b2 - 0x80) * 0x1000 + (b3 - 0x80) * 0x40 + (b4 - 0x80)
end

function M.scan_invisible_characters(text)
  local findings = {}
  local index = 0
  for character in utf8_iter(text) do
    local cp = codepoint(character)
    local name = NAMES[cp]
    if name then
      findings[#findings + 1] = {
        index = index,
        character = character,
        codePoint = string.format("U+%04X", cp),
        name = name,
      }
    end
    index = index + #character
  end
  return findings
end

function M.remove_invisible_characters(text)
  local parts = {}
  for character in utf8_iter(text) do
    if not NAMES[codepoint(character)] then
      parts[#parts + 1] = character
    end
  end
  return table.concat(parts)
end

function M.strip_markdown_paste_residue(text)
  text = text:gsub("\r\n", "\n")
  local lines = {}
  for raw in (text .. "\n"):gmatch("(.-)\n") do
    local line = raw
    line = line:gsub("^%s-#+%s?", "")
    line = line:gsub("^%s-[-*+]%s", "")
    line = line:gsub("^%s-%d+%.%s", "")
    line = line:gsub("^%s->%s?", "")
    line = line:gsub("\\([\\`*_{}%[%]()#+.!|>~-])", "%1")
    line = line:gsub("%*%*", "")
    line = line:gsub("__", "")
    line = line:gsub("~~", "")
    line = line:gsub("`", "")
    line = line:gsub("[ \t]+$", "")
    lines[#lines + 1] = line
  end
  local joined = table.concat(lines, "\n")
  joined = joined:gsub("\n\n\n+", "\n\n")
  return joined
end

return M
