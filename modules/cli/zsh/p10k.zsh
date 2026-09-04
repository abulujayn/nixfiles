# Personal prompt elements, loaded after p10k-base.zsh.
# Host modules populate P10K_HOST_RIGHT_PROMPT_ELEMENTS before this file.

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  context                 # hostname
  dir                     # current directory
  vcs                     # git status
  nix_shell               # nix shell purity status
  direnv                  # direnv status
  asdf                    # asdf version manager
  virtualenv              # python virtual environment
  anaconda                # conda environment
  pyenv                   # python environment
  goenv                   # go environment
  nodenv                  # node.js environment
  nvm                     # node.js environment
  nodeenv                 # node.js environment
  rbenv                   # ruby environment
  rvm                     # ruby environment
  fvm                     # flutter environment
  luaenv                  # lua environment
  jenv                    # java environment
  plenv                   # perl environment
  perlbrew                # perl environment
  phpenv                  # php environment
  scalaenv                # scala environment
  haskell_stack           # Haskell environment
  toolbox                 # Toolbox environment
  chezmoi_shell           # Chezmoi shell
  newline                 # \n
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  command_execution_time  # duration of the last command
  background_jobs         # presence of background jobs
  kubecontext             # current kubernetes context (https://kubernetes.io/)
  terraform               # terraform workspace (https://www.terraform.io)
  aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
  aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
  azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
  gcloud                  # google cloud cli account and project (https://cloud.google.com/)
  google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
  nordvpn                 # nordvpn connection status, linux only (https://nordvpn.com/)
  ranger                  # ranger shell (https://github.com/ranger/ranger)
  yazi                    # yazi shell (https://github.com/sxyazi/yazi)
  nnn                     # nnn shell (https://github.com/jarun/nnn)
  lf                      # lf shell (https://github.com/gokcehan/lf)
  xplr                    # xplr shell (https://github.com/sayanarijit/xplr)
  vim_shell               # vim shell indicator (:sh)
  midnight_commander      # midnight commander shell (https://midnight-commander.org/)
  vi_mode                 # vi mode (you don't need this if you've enabled prompt_char)
  todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
  timewarrior             # timewarrior tracking status (https://timewarrior.net/)
  taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
  per_directory_history   # Oh My Zsh per-directory-history local/global indicator
  ${P10K_HOST_RIGHT_PROMPT_ELEMENTS[@]}
  newline
)

(( ! $+functions[p10k] )) || p10k reload
