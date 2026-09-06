{ config, lib, pkgs, ... }:

let
  inherit (lib) concatMapAttrsStringSep concatStringsSep escapeShellArg mapAttrsToList mkOption types;

  fileType = types.submodule {
    options.source = mkOption {
      type = types.path;
      description = "Store path to link into the user's home directory.";
    };
  };

  userFiles = config.system.userFiles;
  cleanupPaths = config.system.userFilesCleanup;

  homeFor = user: config.users.users.${user}.home;

  cleanupCommands = concatMapAttrsStringSep "\n" (
    user: paths:
    concatStringsSep "\n" (map (relativePath: ''
      remove_home_manager_link \
        ${escapeShellArg user} \
        ${escapeShellArg "${homeFor user}/${relativePath}"}
    '') paths)
  ) cleanupPaths;

  linkCommands = concatMapAttrsStringSep "\n" (
    user: files:
    concatStringsSep "\n" (mapAttrsToList (relativePath: file: ''
      link_user_file \
        ${escapeShellArg user} \
        ${escapeShellArg "${homeFor user}/${relativePath}"} \
        ${escapeShellArg (toString file.source)}
    '') files)
  ) userFiles;

  activation = ''
    run_as_user() {
      local managed_user="$1"
      shift
      ${
        if pkgs.stdenv.hostPlatform.isDarwin then
          ''/usr/bin/sudo --user="$managed_user" -- "$@"''
        else
          ''${pkgs.util-linux}/bin/runuser -u "$managed_user" -- "$@"''
      }
    }

    remove_home_manager_link() {
      local managed_user="$1"
      local target="$2"
      local link_target

      if [[ -L "$target" ]]; then
        link_target="$(${pkgs.coreutils}/bin/readlink "$target")"
        case "$link_target" in
          ${
            if pkgs.stdenv.hostPlatform.isDarwin then
              "/nix/store/*-home-manager-files/*|/nix/store/*-hm_*)"
            else
              "/nix/store/*)"
          }
            run_as_user "$managed_user" ${pkgs.coreutils}/bin/rm -- "$target"
            ;;
        esac
      fi
    }

    link_user_file() {
      local managed_user="$1"
      local target="$2"
      local source="$3"
      local parent

      parent="$(${pkgs.coreutils}/bin/dirname "$target")"
      run_as_user "$managed_user" ${pkgs.coreutils}/bin/mkdir -p -- "$parent"

      if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Refusing to replace non-symlink user file: $target" >&2
        return 1
      fi

      run_as_user "$managed_user" ${pkgs.coreutils}/bin/ln -sfn -- "$source" "$target"
    }

    ${cleanupCommands}
    ${linkCommands}
  '';
in
{
  options.system = {
    userFiles = mkOption {
      type = types.attrsOf (types.attrsOf fileType);
      default = { };
      description = "Declarative, system-owned symlinks in user home directories.";
    };

    userFilesCleanup = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = { };
      description = "Obsolete declarative links to remove when they still point into the Nix store.";
    };
  };

  config = {
    assertions = mapAttrsToList (user: _: {
      assertion = builtins.hasAttr user config.users.users;
      message = "system.userFiles references undefined user ${user}";
    }) (userFiles // cleanupPaths);

    system.activationScripts =
      if pkgs.stdenv.hostPlatform.isDarwin then
        {
          postActivation.text = lib.mkAfter activation;
        }
      else
        {
          userFiles = {
            deps = [ "users" ];
            text = activation;
          };
        };
  };
}
