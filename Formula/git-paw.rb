class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.20.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "18e130490925b954817631040b1989a5076e4ee803c7d0713eabcd7dbb9e8b49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.20.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "cb69ff76332b447813c7a706cf0dcd62921695524bb72b38302da2a895af88a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.20.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f48fdc1970f72d6e1fa6ef397040985b015423f1c955a25c9a15a7ef223d3748"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.20.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "adbc26ad5b49db65d716f9b0f065d53413132d4baa74bdb965b727bd0486cb5e"
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
