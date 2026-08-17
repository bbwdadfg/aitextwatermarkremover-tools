Pod::Spec.new do |spec|
  spec.name = "AtwrTools"
  spec.version = "0.1.0"
  spec.summary = "Scan and remove invisible Unicode characters from text."
  spec.description = <<-DESC
    Local utilities to scan and remove invisible Unicode characters and tidy Markdown paste residue. Independent third-party helper inspired by aitextwatermarkremover.com. Not an official SDK. Runs offline.
  DESC
  spec.homepage = "https://aitextwatermarkremover.com/"
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.author = { "bbwdadfg" => "bbwdadfg@users.noreply.github.com" }
  spec.source = {
    :git => "https://github.com/bbwdadfg/aitextwatermarkremover-tools.git",
    :tag => "cocoapods-v#{spec.version}"
  }
  spec.source_files = "Sources/AtwrTools/**/*.swift"
  spec.swift_versions = ["5.9"]
  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "10.15"
end
