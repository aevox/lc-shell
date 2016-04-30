zstyle ':prezto:*:*' color 'yes'

zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'prompt' \
  'git' \
  'syntax-highlighting' \
  'history-substring-search' \
  'tmux' \
  'k' \
  'docker'

zstyle ':prezto:module:editor' key-bindings 'emacs'

zstyle ':prezto:module:prompt' theme 'lightcode'

zstyle ':prezto:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'line' \
  'cursor' \
  'root'
