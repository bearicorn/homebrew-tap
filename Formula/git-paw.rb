class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.1.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "10460718e4cf95dd7bc5f4e6ff30c1cb7069c7fd13d5dd839a235d2358aa3732"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.1.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "e706ff701cdf6d816198323277768e4466ea5324876055d85b0f09e8caaa9557"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.1.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b02378263a634b6b695ae27095a64b4e31a596d37fc04381280fbbd707c90e14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.1.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f5ff214724856c3ca8136a888b15d29a7b2ea18f63fc5dc64412fda760b461d8"
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
