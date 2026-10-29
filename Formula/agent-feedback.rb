class AgentFeedback < Formula
  desc "Menu bar app for visual screenshot feedback to Claude Code sessions"
  homepage "https://github.com/bendemartin97/agent-feedback"
  url "https://github.com/bendemartin97/agent-feedback/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "86350f14ab763b0db2db1a69739c37476dc95d884f8b1aa1806c96e13d729b60"
  license "MIT"
  head "https://github.com/bendemartin97/agent-feedback.git", branch: "main"

  depends_on "jq"
  depends_on :macos

  def install
    system "scripts/make-app.sh", libexec/"AgentFeedback.app"
    libexec.install "hooks", "skills", "bin"
    bin.install_symlink libexec/"bin/agent-feedback"
  end

  service do
    run [opt_libexec/"AgentFeedback.app/Contents/MacOS/AgentFeedback"]
    keep_alive successful_exit: false
  end

  def caveats
    <<~EOS
      Start the menu bar app (and at login):
        brew services start agent-feedback
      Link hooks and skill into ~/.claude (--hooks also adds the hooks to settings.json):
        agent-feedback setup --hooks
      For Codex as well (then trust the hooks once with /hooks in Codex):
        agent-feedback setup --hooks --codex
      For pi (then restart running pi sessions or /reload):
        agent-feedback setup --pi
      macOS asks for Screen Recording permission on the first capture.
    EOS
  end

  test do
    assert_predicate libexec/"AgentFeedback.app/Contents/MacOS/AgentFeedback", :executable?
    assert_match "setup", shell_output("#{bin}/agent-feedback 2>&1", 1)
  end
end
