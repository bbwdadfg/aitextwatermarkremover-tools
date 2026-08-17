# Package ecosystem publish record

Target: `https://aitextwatermarkremover.com/`

Artifact: `aitextwatermarkremover-tools` `0.1.0`

Source: [bbwdadfg/aitextwatermarkremover-tools](https://github.com/bbwdadfg/aitextwatermarkremover-tools), commit `42a835be8f3bcfd0c6f5dccf81f252f2b5f938ed`

The artifact is an offline helper for scanning/removing invisible Unicode characters and cleaning Markdown paste residue. It is an independent third-party helper, not an official SDK, and makes no detector-bypass guarantee.

## Verified

- [GitHub repository](https://github.com/bbwdadfg/aitextwatermarkremover-tools) — public repo and `v0.1.0` tag.
- [PyPI project](https://pypi.org/project/aitextwatermarkremover-tools/) — version `0.1.0`; JSON API, project page, and simple index verified.
- [Go proxy module](https://proxy.golang.org/github.com/bbwdadfg/aitextwatermarkremover-tools/@v/v0.1.0.info) — version resolves through `go list`; [pkg.go.dev documentation](https://pkg.go.dev/github.com/bbwdadfg/aitextwatermarkremover-tools@v0.1.0) now returns HTTP 200.

## Blocked

- npm: local package and `npm pack --dry-run` passed, but the stored npm credential failed `npm whoami`/publish with `ENEEDAUTH`.

## Skipped as not applicable

No duplicate or empty artifacts were created for PHP, Rust, Ruby, Dart, Elixir, JVM, Docker, JSR, .NET, Apple, Lua, Perl, Haskell, Windows, GitHub Packages, or GitLab Packages. Those ecosystems require a real language-native artifact or a separately approved package surface.

No credentials were written to the repository or this record.
