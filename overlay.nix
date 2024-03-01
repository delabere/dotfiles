{ tmux-jump, session-x, ... }@inputs:
final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    tmux-jump = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "tmux-jump";
      version = tmux-jump.shortRev;
      src = tmux-jump;
    };
    session-x = session-x.packages.${final.system}.default;
  };
}
