class SourceCoop < Formula
  desc "CLI for Source Cooperative — OIDC login and STS credential exchange"
  homepage "https://source.coop"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.1/source-coop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d07bcf24de3361492c6b2df6aaa00c39f06989b321f3d98e4a90eff957f5f0e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.1/source-coop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9fb371c9dcc9a26febe86eab0f220de76f11943fcae55e70d924e4ef1d7331eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.1/source-coop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a2474f24e524b2ff8288b6dab77db9f5cbf8533ac748d04f6bb6dbddda26502f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.1/source-coop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6132a50a015f3d84c6c31e695f5a9a62ce73450a62d92f37cc65768e9635a16f"
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
