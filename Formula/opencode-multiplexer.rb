class OpencodeMultiplexer < Formula
  desc "A terminal multiplexer for managing OpenCode sessions"
  homepage "https://github.com/joeyism/ocmux-rs"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.4.0/opencode-multiplexer-aarch64-apple-darwin.tar.xz"
      sha256 "e1a649c6840d67b895ed13fbf95ced8bb67e7b0adbad6a24f771eb6486ccd90a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.4.0/opencode-multiplexer-x86_64-apple-darwin.tar.xz"
      sha256 "dfc70c45c55496ad814ab3a8c0d6575068c6a5c1e9f8411aacf136b5a6fb5669"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/joeyism/ocmux-rs/releases/download/v0.4.0/opencode-multiplexer-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c77ba4aa303fd4d49127da64eff82859159b1eac27686cd00d33665b0aa828b6"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "ocmux" if OS.mac? && Hardware::CPU.arm?
    bin.install "ocmux" if OS.mac? && Hardware::CPU.intel?
    bin.install "ocmux" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
