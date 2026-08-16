{ ai-unstable, ... }:

{
  imports = [ ../opencode ];

  home.packages = [
    ai-unstable.claude-code
    ai-unstable.codex
    ai-unstable.t3code
    ai-unstable.code-cursor-fhs
    ai-unstable.cursor-cli
    # ai-unstable.crush
  ];
}
