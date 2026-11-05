# Made by golem's release workflow from packaging/homebrew/golem.rb.in in
# https://github.com/MilanPavel/golem. Change it there: the next release replaces
# this file.
class Golem < Formula
  desc "Personal AI agent that runs on your own machine"
  homepage "https://github.com/MilanPavel/golem"
  url "https://github.com/MilanPavel/golem/releases/download/v0.9.0/golem-0.9.0-darwin-arm64.tar.gz"
  sha256 "fffa5bb13245c7098c0c1d97a1635e0f5b0a3170c129726fc815e14517a303de"

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
      Run golem to get started.
      After `brew upgrade golem`, press Ctrl-R in golem to restart its service.
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
