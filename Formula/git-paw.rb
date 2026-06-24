class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.7.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "45e55461d176861b9e94c93427474812a819d649186087b099e4a76be3f8ed3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.7.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "fac91d54b86a89e91237bb2bc8991ba193c28ac84fde89b7bc4c46aba388b0c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.7.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7036443a31682885e429a24f43a6c6f1dbb625a9b1add9432c21f1bc4562d5f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.7.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "157e56b381e89ee6d6f28850101b2cd425e5e621348e46d58d7d9c2e90b188c8"
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
