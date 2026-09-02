class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.15.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "b7a417a95639bc0e6667c6568b394b3ffb77739333016614bed66211beca9e11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.15.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "4fc0a705abff504c83519a8762703431cb0f57ff7522f894177e6cebdcc71aaf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.15.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3b9c670bf3322bea8c60142881a03e3823c9e1764123ed4fc9c9e4c86df91dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.15.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ac99ae6d9024a575906b1c09e13158a9d7e7235edb8c0890f7997d6ee9b87d7"
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
