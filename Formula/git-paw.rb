class GitPaw < Formula
  desc "Parallel AI Worktrees — orchestrate multiple AI coding CLI sessions across git worktrees"
  homepage "https://bearicorn.github.io/git-paw"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.17.0/git-paw-aarch64-apple-darwin.tar.xz"
      sha256 "65935574c4b80a06d482cc81ecd485ebd04e7f9e46ee421e3c83a4f79ddfcfc1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.17.0/git-paw-x86_64-apple-darwin.tar.xz"
      sha256 "ef08028dbc2c6c70df8e4e41c63a42ef6762b3ac76b5f6c023d6cfd1cac039a4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.17.0/git-paw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f3614f5f75ecf4c88b7949522da73add0b0c496a73cbceb59ce9b3d22e2e024"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bearicorn/git-paw/releases/download/v0.17.0/git-paw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8e36c7b0d1d3a452053ebfe83adfcbf189699360ad1da5706b51bd024caa2e6b"
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
