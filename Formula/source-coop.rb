class SourceCoop < Formula
  desc "CLI for Source Cooperative — OIDC login and STS credential exchange"
  homepage "https://source.coop"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.2/source-coop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1a2205ec7d39130fc2484575e177f38040b5191025fa5a21dc285cc00e0f8488"
    end
    if Hardware::CPU.intel?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.2/source-coop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a6845e56166ad906a682793fd8c5c9b52ffd98f24aa94017dbc57430c1188ec9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.2/source-coop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f5fc3e7adb2526731bca35fd38ccebcbc30f0d3f47c0d9cd973b1eda6a99ac4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/source-cooperative/source-coop-cli/releases/download/v0.1.2/source-coop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23aed42d362fc6b6fe5a5f38e4f855ab2a3eec5c96cdff4c71408f9056e7d2cc"
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
