# Package ecosystem publish record
Target: `https://aitextwatermarkremover.com/`

Artifact: `aitextwatermarkremover-tools` `0.1.0`

Source: [bbwdadfg/aitextwatermarkremover-tools](https://github.com/bbwdadfg/aitextwatermarkremover-tools), commit `b8e0c0c4bef76c831b34a29edd3a26d007be37a8`

The artifact is an offline helper for scanning/removing invisible Unicode characters and cleaning Markdown paste residue. It is an independent third-party helper, not an official SDK, and makes no detector-bypass guarantee.

## Verified

- **GitHub** — https://github.com/bbwdadfg/aitextwatermarkremover-tools
  Public repository HTTP 200; tags v0.1.0, v0.1.1, luarocks-v0.1.0, cocoapods-v0.1.0, maven-v0.1.0, homebrew-v0.1.0.
- **PyPI** — https://pypi.org/project/aitextwatermarkremover-tools/
  JSON API reports version 0.1.0; project page and simple index HTTP 200.
- **Go proxy** — https://proxy.golang.org/github.com/bbwdadfg/aitextwatermarkremover-tools/@v/v0.1.1.info
  Go proxy resolves v0.1.0 and v0.1.1; pkg.go.dev documentation page follows to HTTP 200.
- **npm** — https://www.npmjs.com/package/aitextwatermarkremover-tools
  Published 0.1.0; registry metadata has homepage, GitHub repository, and atwr bin. npmjs.com HTML verifier returned HTTP 403.
- **Packagist** — https://packagist.org/packages/bbwdadfg/aitextwatermarkremover-tools
  create-package returned success; package JSON lists repository and versions including v0.1.1.
- **RubyGems** — https://rubygems.org/gems/aitextwatermarkremover-tools
  API reports 0.1.0, homepage https://aitextwatermarkremover.com/, source_code_uri GitHub repo.
- **pub.dev** — https://pub.dev/packages/aitextwatermarkremover_tools
  Published 0.1.0; API reports homepage https://aitextwatermarkremover.com/.
- **NuGet** — https://www.nuget.org/packages/AtwrTools/0.1.0
  Push returned Created. Package page HTTP 200 contains 0.1.0 and homepage. Flat-container API lists 0.1.0.
- **CocoaPods** — https://cocoapods.org/pods/AtwrTools
  pod trunk info reports AtwrTools 0.1.0. First trunk push returned HTTP 500 after create; retry said duplicate. cocoapods.org/pods/AtwrTools HTTP 200.
- **LuaRocks** — https://luarocks.org/modules/bbwdadfg/aitextwatermarkremover-tools
  luarocks upload 0.1.0-1 succeeded; rockspec HTTP 200 at https://luarocks.org/manifests/bbwdadfg/aitextwatermarkremover-tools-0.1.0-1.rockspec.
- **GitLab Package Registry** — https://gitlab.com/baiwei.chu/aitextwatermarkremover-tools/-/packages
  Public project 85475708 created. Generic package PUT returned 201. Unauthenticated project, packages page, and artifact URL return HTTP 200. Archive sha256 3d8337c33bdb524ec8535555480462275d1843c74cf3e6f219b1b82de2f7fa91.
- **Homebrew** — https://github.com/bbwdadfg/homebrew-aitextwatermarkremover-tools
  Public tap Formula is live. brew tap, brew trust --formula, brew install, and `atwr --help` succeeded locally.
- **Open VSX** — https://open-vsx.org/extension/bbwdadfg/aitextwatermarkremover-tools
  ovsx publish succeeded for bbwdadfg.aitextwatermarkremover-tools 0.1.0. Public extension page returns HTTP 200.

## Published, still indexing

- **Maven Central/javadoc.io** — https://central.sonatype.com/publishing/deployments
  central-publishing-maven-plugin uploaded and VALIDATED deployment 52b22a6a-c4f8-4f2d-8eb7-bc0814f5dee8. Publisher API POST returned HTTP 204. repo1 POM still 404 at record time (indexing lag).
- **GitHub Packages** — https://github.com/bbwdadfg/aitextwatermarkremover-tools/pkgs/npm/aitextwatermarkremover-tools
  npm publish to npm.pkg.github.com succeeded for 0.1.0. Public package page remains 404 until visibility is changed from the default private state.

## Submitted / pending review

- **RubyDoc.info** — https://www.rubydoc.info/gems/aitextwatermarkremover-tools
  Ruby gem is public. RubyDoc project/version pages still return HTTP 404 while indexing.
- **Swift Package Registry** — https://github.com/bbwdadfg/aitextwatermarkremover-tools
  Public Package.swift and AtwrTools sources are on GitHub. swift package dump-package succeeded. Public swiftpackageregistry.com index page was not confirmed in this run.
- **Chocolatey** — https://community.chocolatey.org/packages/aitextwatermarkremover-tools
  nuget push to push.chocolatey.org returned Created. Community package page is live and still in pending automated review.

## Blocked by credentials or platform review

- **crates.io/docs.rs**
  cargo publish --dry-run passed. Live publish returned 403 authentication failed. ~/.cargo/credentials.toml exists but was rejected; Keychain crates-token is absent.
- **Clojars**
  Local mvn test passed. Deploy to https://repo.clojars.org returned 401 Unauthorized with the stored Clojars user/token.
- **Docker Hub**
  No local docker CLI. Hub repository create with the stored PAT as Bearer returned 401 requiring a Hub /v2/auth/token session. Registry image push was not completed.
- **JSR**
  TypeScript module and jsr.json are in the repo. Keychain jsr-token is missing. First publish also needs jsr.io scope/package approval.
- **CPAN/MetaCPAN**
  Local Perl tests passed and a source tarball was built. cpan-upload to PAUSE returned 401 Unauthorized with stored cpan-user/cpan-token.
- **Hackage**
  Haskell package tests passed locally. Keychain hackage-token is missing. First Hackage upload also commonly needs uploader-group approval.

## Permanently excluded

- **Hex.pm/HexDocs**
  User-provided Hex.pm notice says account bbwdadfg and its sole-owner packages were removed for spam; do not retry, create an alternate account, or republish there.

No credentials were written to the repository or this record.
