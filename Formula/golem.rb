# Made by golem's release workflow from packaging/homebrew/golem.rb.in in
# https://github.com/MilanPavel/golem. Change it there: the next release replaces
# this file.
class Golem < Formula
  desc "Personal AI agent that runs on your own machine"
  homepage "https://github.com/MilanPavel/golem"
  url "https://github.com/MilanPavel/golem/releases/download/v0.1.0/golem-0.1.0-darwin-arm64.tar.gz"
  sha256 "9471205e55758f63012c600dcfbc324b70723e8ccf3c643c8d1105406aa5c1f4"

  depends_on arch: :arm64
  depends_on :macos

  # Install the signed archive byte for byte. Homebrew would otherwise give
  # every library an absolute install name and sign it again ad-hoc, and delete
  # the RECORD files of the daemon's Python packages.
  preserve_rpath
  skip_clean "libexec"

  def install
    prefix.install "bin", "libexec"
  end

  # No service block: golem daemon install owns the launchd job, the same way
  # for every install. Two owners would start two daemons.
  def caveats
    <<~EOS
      Start the golem daemon, now and at every login:
        golem daemon install
      After `brew upgrade golem`, switch the running daemon to the new version:
        golem daemon restart
      Before `brew uninstall golem`, remove the service:
        golem daemon uninstall
      Chats and settings stay in ~/.golem.
    EOS
  end

  test do
    # A second line names the running daemon's version, when one answers.
    assert_match(/^golem #{Regexp.escape(version.to_s)}$/, shell_output("#{bin}/golem --version"))
  end
end
