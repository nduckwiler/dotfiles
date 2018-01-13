function g -d 'git alias'
  # Adapted from Chris Toomey's fn: https://github.com/christoomey/dotfiles/blob/master/zsh/configs/git.zsh
  # No arguments: `git status`
  # With arguments: acts like `git`
  if count $argv > /dev/null
    git $argv
  else
    git status
  end
end
