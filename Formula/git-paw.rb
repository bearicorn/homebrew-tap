class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.9.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "a2a0fedb92923a9c0b0973d9cb4df9b29a45265ca96048bdb3e611f497b555a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.9.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "e70943b1388bfde1b6052d0bb7ed0f487dac4413347c95a6150e5164aba79e97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.9.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f06628cedebc4c019b56b75248160b600c82708eb22576ecb9908b899eb10f7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.9.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7307153d1a4ad56ba0dae305b200f357692f0080ffba0cfd41379449e46bfa53"
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
    bin.install "git-paw" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-paw" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-paw" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-paw" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
