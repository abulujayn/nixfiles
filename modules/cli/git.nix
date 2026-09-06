{ lib, pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    gh
    git
  ];

  environment.etc.gitconfig.text = lib.generators.toGitINI {
    credential."github.com".helper = [
      ""
      "${pkgs.gh}/bin/gh auth git-credential"
    ];
    init.defaultBranch = "main";
    url."https://github.com/".insteadOf = [
      "gh:"
      "github:"
    ];
    user = {
      name = username;
      email = "zaeem@parkar.au";
    };
  };

  system.userFiles.${username} = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    ".config/gh/config.yml".source = pkgs.writeText "gh-config.yml" ''
      %YAML 1.1
      ---
      aliases: {}
      editor: ""
      git_protocol: https
      version: '1'
    '';
  };

  system.userFilesCleanup.${username} =
    [ ".config/git/config" ]
    ++ lib.optional pkgs.stdenv.hostPlatform.isLinux ".config/gh/config.yml";
}
