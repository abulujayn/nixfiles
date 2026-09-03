{ username, ... }:

{
  home-manager.users.${username}.programs = {
    git = {
      enable = true;
      settings = {
        url."https://github.com/".insteadOf = [
          "gh:"
          "github:"
        ];
        user = {
          name = username;
          email = "zaeem@parkar.au";
        };
        init.defaultBranch = "main";
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
        hosts = [ "github.com" ];
      };
    };
  };
}
