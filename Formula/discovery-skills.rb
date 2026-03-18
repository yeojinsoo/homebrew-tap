class DiscoverySkills < Formula
  desc "CLI tool for managing Claude Code custom skills"
  homepage "https://github.com/yeojinsoo/discovery-skills-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.2.0/discovery-skills-aarch64-apple-darwin.tar.xz"
      sha256 "b0e8cb5eb0e310c9c6d7a851df26439cdf5a0bceeadeb5ff6c1a0fa70c7c56c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.2.0/discovery-skills-x86_64-apple-darwin.tar.xz"
      sha256 "0e8c8a7b7ace2b2a0b71f1e7d071e2ba238176aaf69cac1fd2598f19d23ea15e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.2.0/discovery-skills-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6447b471422c413901c248cdcc09b4cb143db265fb612edbcad3dc0f26a54a8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.2.0/discovery-skills-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e0baaadb6c7a85b11e7d3ba60aa649dcec28e3a704cb97fe8e1a49ff43f7a5e"
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
    bin.install "discovery-skills" if OS.mac? && Hardware::CPU.arm?
    bin.install "discovery-skills" if OS.mac? && Hardware::CPU.intel?
    bin.install "discovery-skills" if OS.linux? && Hardware::CPU.arm?
    bin.install "discovery-skills" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
