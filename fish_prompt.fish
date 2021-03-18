# name: poopoo
#
# You can override some default options in your config.fish:
#   set -g theme_display_git_untracked no

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  set -l show_untracked (git config --bool bash.showUntrackedFiles)
  set untracked ''
  if [ "$theme_display_git_untracked" = 'no' -o "$show_untracked" = 'false' ]
    set untracked '--untracked-files=no'
  end
  echo (command git status -s --ignore-submodules=dirty $untracked ^/dev/null)
end

set -x LSCOLORS "Exgxcxdxbxegedabagacad"

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l magenta (set_color -o magenta)
  set -l normal (set_color normal)

  if test $last_status = 0
      set arrow "$green➜ "
  else
      set arrow "$red➜ "
  end
  set -l cwd $yellow(prompt_pwd)

  if [ (_git_branch_name) ]
    set -l git_branch $green(_git_branch_name)
    set git_info "$red [$git_branch$red]"

    if [ (_is_git_dirty) ]
      set -l dirty "$red ✗"
      set git_info "$git_info$dirty"
    end
  end
  echo -n -s '💩💩  ' $cwd $git_info $normal ' ' \n
  echo $arrow 
end

