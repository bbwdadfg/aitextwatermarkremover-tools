# frozen_string_literal: true
require_relative "lib/atwr_tools"
findings = AtwrTools.scan_invisible_characters("A\u200b\u202fB")
raise "scan" unless findings.length == 2 && findings[0].code_point == "U+200B" && findings[0].index == 1
raise "remove" unless AtwrTools.remove_invisible_characters("A\u200b B\ufeff") == "A B"
raise "tidy" unless AtwrTools.strip_markdown_paste_residue("## Heading\n- **Item**\n\\[link\\]") == "Heading\nItem\n[link]"
puts "ruby tests ok"
