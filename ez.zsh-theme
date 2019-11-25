# vim: filetype=sh

# Prompt symbol
EZ_PROMPT_SYMBOL=" ∅"
# ▲→

# Colors
EZ_COLORS_HOST_ME=green
EZ_COLORS_HOST_AWS_VAULT=yellow
EZ_COLORS_CURRENT_DIR=magenta
EZ_COLORS_RETURN_STATUS_TRUE=yellow
EZ_COLORS_RETURN_STATUS_FALSE=red
EZ_COLORS_GIT_STATUS_DEFAULT=yellow
EZ_COLORS_GIT_STATUS_STAGED=yellow
EZ_COLORS_GIT_STATUS_UNSTAGED=yellow
EZ_COLORS_GIT_PROMPT_SHA=green
EZ_COLORS_BG_JOBS=yellow

# Left Prompt
 PROMPT='$(ez_host)$(ez_current_dir)$(ez_bg_jobs)$(ez_git_status)$(ez_return_status)'
 # PROMPT='$(ez_host)$(ez_current_dir)$(ez_bg_jobs)$(ez_git_status)$(ez_return_status)'

# Right Prompt
 # RPROMPT='$(git_prompt_info)'

# Prompt with current SHA
# PROMPT='$(ez_host)$(ez_current_dir)$(ez_bg_jobs)$(ez_return_status)'
# RPROMPT='$(ez_git_status) $(git_prompt_short_sha)'

# Host
ez_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[$EZ_COLORS_HOST_ME]%}$me%{$reset_color%}:"
  fi
  if [[ $AWS_VAULT ]]; then
    echo "%{$fg[$EZ_COLORS_HOST_AWS_VAULT]%}$AWS_VAULT%{$reset_color%} "
  fi
}

# Current directory
ez_current_dir() {


  # echo -n "%{$fg[blue]%}%~ $fg[$EZ_COLORS_CURRENT_DIR]%}%c "
  echo -n "%F{$EZ_COLORS_CURRENT_DIR}%1~"
}

# Prompt symbol
ez_return_status() {
  # echo -n "%(?.%F{$EZ_COLORS_RETURN_STATUS_TRUE}.%F{$EZ_COLORS_RETURN_STATUS_FALSE})$EZ_PROMPT_SYMBOL%f "
  echo -n "%{$fg[$EZ_COLORS_RETURN_STATUS_TRUE]%}$EZ_PROMPT_SYMBOL%f "
}

# Git status
ez_git_status() {
    local message=""
    local message_color="%F{$EZ_COLORS_GIT_STATUS_DEFAULT}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{$EZ_COLORS_GIT_STATUS_STAGED}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$EZ_COLORS_GIT_STATUS_UNSTAGED}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+=" ${message_color}${branch}%f"
    fi

    if [ -d .git ]; then
      if [[ -n $(git status -s) ]]; then
          message+="%{$fg[magenta]%}*"
      # elif [[ -n ${unstaged} ]]; then
      #     message_color="%F{$EZ_COLORS_GIT_STATUS_UNSTAGED}"
      fi
    else
      # git rev-parse --git-dir 2> /dev/null;
    fi;


    echo -n "${message}"
}

# Git prompt SHA
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{%F{$EZ_COLORS_GIT_PROMPT_SHA}%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%} "

# Background Jobs
ez_bg_jobs() {
  bg_status="%{$fg[$EZ_COLORS_BG_JOBS]%}%(1j.↓%j .)"
  echo -n $bg_status
}
