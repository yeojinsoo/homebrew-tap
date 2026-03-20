class DiscoverySkills < Formula
  desc "CLI tool for managing Claude Code custom skills"
  homepage "https://github.com/yeojinsoo/discovery-skills-cli"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.5.0/discovery-skills-aarch64-apple-darwin.tar.xz"
      sha256 "b95a31be575e02481ecfb0a6a98b6365f920d512a9b64d02b6f9f03adffe41bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.5.0/discovery-skills-x86_64-apple-darwin.tar.xz"
      sha256 "29f47458b83295d8dc2febf1603f4292177288d219d09e4b9f81f625632a37d8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.5.0/discovery-skills-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc55417c0bc4f1b8e8fcd71da583ee16958cb5d28059859c8ec069ea33246f12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yeojinsoo/discovery-skills-cli/releases/download/v0.5.0/discovery-skills-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e9981345027618947839708a301bdf07bba3ac559f833e315f3f6d11728d4457"
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
