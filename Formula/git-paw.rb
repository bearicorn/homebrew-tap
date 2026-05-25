class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.5.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "c218109ab878d24e83de484b9b1a9f6f34d375f91ac895f11c21ef4c0560abf7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.5.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "f979023c15b484970b80bf72860525d5cdb24baf617bcc5c6a1a1c6ea4465dcb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.5.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "512d2d85f983f848f69f6ab1399e58b9f14ccbdb14dce12fcd5977fe5f4a8e7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.5.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15c1cbf4748885dbf4a6eb622f5a006e6df135871af5a7880fdcf560d4734ba7"
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
