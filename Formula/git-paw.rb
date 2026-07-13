class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.10.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "bd30b6c2ffad3855d6dfc2ddd059e36dbfab4ea20470b2f1084487654cb8e2ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.10.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "447dd3044739bfddba990bc809034b89dc44dbe4cbf6b038b158c2627f25a827"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.10.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6938a31af91c1b9693aa32a5141f5b43d8a8103a079266af1900f54df76399ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.10.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1af2a50b1e76b2d72b8e36204f960fa0ccca3174dcbba781822eda296cf62d49"
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
