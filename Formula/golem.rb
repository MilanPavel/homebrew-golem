# Made by golem's release workflow from packaging/homebrew/golem.rb.in in
# https://github.com/MilanPavel/golem. Change it there: the next release replaces
# this file.
class Golem < Formula
  desc "Personal AI agent that runs on your own machine"
  homepage "https://github.com/MilanPavel/golem"
  url "https://github.com/MilanPavel/golem/releases/download/v0.13.1/golem-0.13.1-darwin-arm64.tar.gz"
  sha256 "52acc83afda05f17fd82412c362ee7f81d439dfdaa32e840b0423d37f4a2f2b5"

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
      Run golem to chat in the terminal,
      or golem web to set up in your browser.
      After `brew upgrade golem`, press Ctrl-R in golem or run `golem daemon restart`
      to restart its service and the web page. `golem web` restarts the page too.
      Before `brew uninstall golem`, remove them:
        golem uninstall
      Chats and settings stay in ~/.golem.
    EOS
  end

  test do
    # A second line names the running daemon's version, when one answers.
    assert_match(/^golem #{Regexp.escape(version.to_s)}$/, shell_output("#{bin}/golem --version"))
  end
end
