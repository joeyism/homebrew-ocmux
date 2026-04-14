class OcmuxRs < Formula
  desc "A terminal multiplexer for managing OpenCode sessions"
  homepage "https://github.com/joeyism/ocmux-rs"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.2.1/ocmux-rs-aarch64-apple-darwin.tar.xz"
      sha256 "d3445ae2f0e44342850b27a93d354c99823d99673c238ef454f92ad46ef772f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.2.1/ocmux-rs-x86_64-apple-darwin.tar.xz"
      sha256 "86b953dc2c839380867144d4d7c57f0d5166d8578aeb331e041d5be40c747a93"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/joeyism/ocmux-rs/releases/download/v0.2.1/ocmux-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "79a0cf5d4802f424b55120511b7f20e21e22c3e5b640a693761ef0ce968c9d70"
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
