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

  system.userFilesCleanup.${username} = [ ".config/git/config" ".config/gh/config.yml" ];
}
