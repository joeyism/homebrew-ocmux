class OpencodeMultiplexer < Formula
  desc "A terminal multiplexer for managing OpenCode sessions"
  homepage "https://github.com/joeyism/ocmux-rs"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.5.0/opencode-multiplexer-aarch64-apple-darwin.tar.xz"
      sha256 "75fba0431c7afa223024990b1d1aae4bea0eaa20df6055b698788fa890d1489e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.5.0/opencode-multiplexer-x86_64-apple-darwin.tar.xz"
      sha256 "6c1876acf2ccd164a5c8927ed07e88cd3a1072142e9e15dd6d10c12ba01a0859"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/joeyism/ocmux-rs/releases/download/v0.5.0/opencode-multiplexer-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "83522ead67222feef2beb3d6cfc99b9e8667b0d7a9ee5d73552050460e84d3b9"
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
