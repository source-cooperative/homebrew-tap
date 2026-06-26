class SourceCoop < Formula
  desc "CLI for Source Cooperative — OIDC login and STS credential exchange"
  homepage "https://source.coop"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.3/source-coop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8b836a215cca3e81bb1f5451e2c53eb62347cad3359ae57ba502343da800ffbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.3/source-coop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "eb5d5ff9125b8a420694ccbd4f53ce546393e8e06388c24cc01f7126eb56f8cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.3/source-coop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f84c22a1783f29666f47f0d6ebfb28d55f8ef1ae144a1b4adae3928a7c4e152e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.3/source-coop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15579450384f29327a235777423ad4365ef49944717bc0429e9a990ea3de9e41"
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
