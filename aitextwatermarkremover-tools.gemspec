Gem::Specification.new do |spec|
  spec.name = "aitextwatermarkremover-tools"
  spec.version = "0.1.0"
  spec.summary = "Scan and remove invisible Unicode characters from text."
  spec.description = "Local utilities to scan and remove invisible Unicode characters and tidy Markdown paste residue. Independent third-party helper inspired by aitextwatermarkremover.com. Not an official SDK. Runs offline."
  spec.authors = ["bbwdadfg"]
  spec.email = ["bbwdadfg@users.noreply.github.com"]
  spec.homepage = "https://aitextwatermarkremover.com/"
  spec.license = "MIT"
  spec.files = ["lib/atwr_tools.rb", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.0"
  spec.metadata = {
    "homepage_uri" => "https://aitextwatermarkremover.com/",
    "source_code_uri" => "https://github.com/bbwdadfg/aitextwatermarkremover-tools",
    "changelog_uri" => "https://github.com/bbwdadfg/aitextwatermarkremover-tools/blob/master/CHANGELOG.md"
  }
end
