class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.19.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "927db108f7180ab08d854844a03e374fd5caaebf4a97d654d2fdb940753b86aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.19.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "0c7e7ff13c293698da2026586c1cc4b9bbd1e4f0f333397dc138a49be60fc6a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.19.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7f2b17fd38466ac3a864deabcafe6fb519669f33f59ca63f747b016ad2c92d69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.19.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9fa355183c49af3771337a48628c8a529c6c81e1664578ed4d57447ad8a3db24"
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
