GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWDIRTYSTATE=true

__git () {
  local git_prompt=$(__git_ps1 '%s')
  if [ "${git_prompt}" = "" ]
  then
    return
  fi

  local git_branch=${echo_bold_white}${git_prompt//[<>=+* ]/}

  local has_upstream_changes=${git_prompt//[^<>=]/}
  case "${has_upstream_changes}" in
    "<>")
      local git_upstream="${echo_bold_red}<>"
      ;;
    ">")
      local git_upstream="${echo_bold_yellow}>"
      ;;
    "<")
      local git_upstream="${echo_bold_yellow}<"
      ;;
    "=")
      local git_upstream="${echo_bold_green}="
      ;;
  esac

  local is_dirty=${git_prompt//[^*]/}
  if [ "${is_dirty}" = "*" ]
  then
    local git_dirty=${echo_bold_red}✗
  else
    local git_dirty=${echo_bold_green}✓
  fi

  local is_staged=${git_prompt//[^+]/}
  local git_staged=${echo_bold_yellow}${is_staged//[+]/⚡}

  echo -e ${git_branch}${git_dirty}${git_staged}${git_upstream}${echo_reset_color}
}

__nvm () {
  nvm_ls "current" | tr -d [:blank:]
}

function prompt_command() {
  local return_code=$?
  if [ ${return_code} -ne 0 ]
  then
    local return_status="${return_code} ${red}✗${reset_color}"
  else
    local return_status="${return_code} ${green}✓${reset_color}"
  fi
  PS1="[${bold_red}$(rvm-prompt)${reset_color}][${bold_cyan}\$(__nvm)${reset_color}][\$(__git)]\n${blue}\u${reset_color}@${yellow}\h${reset_color}:${bold_green}\w${reset_color}\n${return_status} ${bold_white}⚥ ${normal}"
}

PROMPT_COMMAND=prompt_command
