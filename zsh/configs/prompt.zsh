autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' max-exports 1
zstyle ':vcs_info:*' formats '%%B%F{3}%b%f%%b%c%u%m'
zstyle ':vcs_info:*' actionformats '%%B%F{2}%b%f%%b:%%B%F{3}%a%f%%b%c%u%m'
zstyle ':vcs_info:*' stagedstr ' %B%F{2}✚%f%b'
zstyle ':vcs_info:*' unstagedstr ' %B%F{4}✱%f%b'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-fix-misc git-remote git-stashed

function +vi-git-untracked() {
  if git status --porcelain | grep '?? ' &> /dev/null; then
    hook_com[staged]+=' %B%F{7}◼%f%b'
  fi
}

function +vi-git-fix-misc() {
  if (( ${#hook_com[misc]} > 0 )) && [[ "${hook_com[misc][1]}" != " " ]]; then
    hook_com[misc]=" ${hook_com[misc]}"
  fi

  case "${hook_com[action]}" in
    rebase-i|cherry)
      hook_com[misc]="${hook_com[misc][1,10]}"
    ;;
  esac
}

function +vi-git-remote() {
  local ahead behind ahead_behind

  ahead_behind="$(git rev-list --count --left-right 'HEAD...@{upstream}' 2> /dev/null)"

  if (( $? != 0 )); then
    return
  fi

  ahead="$ahead_behind[(w)1]"
  if (( $ahead > 0 )); then
    hook_com[misc]+=' %B%F{13}⇡%f%b'
  fi

  behind="$ahead_behind[(w)2]"
  if (( $behind > 0 )); then
    hook_com[misc]+=' %B%F{13}⇣%f%b'
  fi
}

function +vi-git-stashed() {
  local stashed="$(git stash list 2> /dev/null | wc -l)"

  if (( $stashed > 0 )); then
    hook_com[misc]+=' %B%F{6}✭%f%b'
  fi
}

function precmd() {
  vcs_info
  k8s_cluster=""
  if [[ -f ~/.kube/config ]]; then
    k8s_cluster=$(sed -n '/current-context: / s/current-context: //p' "/home/marc/.kube/config")
  fi
  if [[ "$k8s_cluster" == stg* ]] || [[ "$k8s_cluster" == prd* ]]; then
    color="%B%K{1}"
  else
    color="%F{5}"
  fi
  k8s_prompt="$color$k8s_cluster%f%b%k"


  vault_addr=""
  vault_addr=$(sed 's/.*vault-adm.service\.\(.*\)\.cloudwatt.*/\1/' <<< $VAULT_ADDR)

}

setopt PROMPT_SUBST

PROMPT='%B%F{4}%3~%(!. %F{1}#%f.) %F{1}❯%F{3}❯%F{2}❯%f%b '
RPROMPT='${k8s_prompt} ${vcs_info_msg_0_}'
