class OcmuxRs < Formula
  desc "A terminal multiplexer for managing OpenCode sessions"
  homepage "https://github.com/joeyism/ocmux-rs"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.3.0/ocmux-rs-aarch64-apple-darwin.tar.xz"
      sha256 "fcfa1931c8a7d731b928d4b19e59c5bdce247bc455f44fdc18c028f6d8bfe3f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joeyism/ocmux-rs/releases/download/v0.3.0/ocmux-rs-x86_64-apple-darwin.tar.xz"
      sha256 "d26a22aac6db00216cd2d85dad5b563a536cda8fca2f0a512db19773685e3aca"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/joeyism/ocmux-rs/releases/download/v0.3.0/ocmux-rs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fe07b4f798e94be98fcc92411f444465950725cc7d5beed8a325ce8bcdd0f04c"
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
