class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.16.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "ed7487c6dd9314f02a45cb5d4b0e0e05eaed9758b6930ecc314015dd9aa75108"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.16.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "95826c089e4338e24a6f3e6d7ce8e07fe3309eac715c602c70976207220c0f2c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.16.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41a8f307eceecfc5d7e8d89e63cee6382fb6e65f5881be6553e25e1a84aa51b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.16.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "531c83dcebfd8c76216fa5b7b3a307f2ccdcabfe1775ce1dc03f425db7f8e9bc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "git-paw"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-paw"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-paw"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-paw"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
