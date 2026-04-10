class OcmuxRs < Formula
  desc "A terminal multiplexer for managing OpenCode sessions"
  homepage "https://github.com/joeyism/ocmux-rs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.1.0/ocmux-rs-aarch64-apple-darwin.tar.xz"
      sha256 "a66d28e4c22ded220cc16d5ce77973f765056823e8650cb4307b67d09cf9de0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.1.0/ocmux-rs-x86_64-apple-darwin.tar.xz"
      sha256 "e6a7de976a46e08368e1b658642c5dbb841325272d18bcdb66be3da81bef2b79"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/joeyism/ocmux-rs/releases/download/v0.1.0/ocmux-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f1c3a37e9ee13d636d226f776cf8f7148021305e9828c70b4cc9aac816927b88"
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
