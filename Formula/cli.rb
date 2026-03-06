class Cli < Formula
  desc "CLI for Source Cooperative — OIDC login and STS credential exchange"
  homepage "https://source.coop"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.0/source-coop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "be3073d9d8775f88bd8a46bbe24972bc248f30aae5b7e6a814b982809a25a749"
    end
    if Hardware::CPU.intel?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.0/source-coop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ab116976b784265b864164a6e693fd7a6fd56ed6de87cc45d565edfe212663fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.0/source-coop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aded12767da4435f52514c967b616974270aab53d66af1143f9e4df1dd7d6474"
    end
    if Hardware::CPU.intel?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.0/source-coop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c10b4a426728ed8db807535a410dd737513f4da696c935adca2280fb35e04c83"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "source-coop" if OS.mac? && Hardware::CPU.arm?
    bin.install "source-coop" if OS.mac? && Hardware::CPU.intel?
    bin.install "source-coop" if OS.linux? && Hardware::CPU.arm?
    bin.install "source-coop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
