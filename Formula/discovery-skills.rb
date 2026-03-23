class DiscoverySkills < Formula
  desc "CLI tool for managing Claude Code custom skills"
  homepage "https://github.com/yeojinsoo/discovery-skills-cli"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.6.0/discovery-skills-aarch64-apple-darwin.tar.xz"
      sha256 "c59042f16744a695911e34ffc9ad418adb8d9c4253097ef9ab63da7ac72895b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.6.0/discovery-skills-x86_64-apple-darwin.tar.xz"
      sha256 "ae5bd44c613ffb155cace31ad6b72d1ddb27f5f46c60e81d85e1d76789b9f93a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.6.0/discovery-skills-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f49058b68f565d39757bf55f87ac6af8ab77024ec0fdd8aada685445deea4643"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.6.0/discovery-skills-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fcdcd1496dbafe515d4c9a7d78fb027fd88a7764fa06d9e9c7c7ae6316d9a3b7"
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
    bin.install "discovery-skills", "ds" if OS.mac? && Hardware::CPU.arm?
    bin.install "discovery-skills", "ds" if OS.mac? && Hardware::CPU.intel?
    bin.install "discovery-skills", "ds" if OS.linux? && Hardware::CPU.arm?
    bin.install "discovery-skills", "ds" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
