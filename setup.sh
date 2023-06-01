# 書き直す
for dotfile in .vim .vimrc .zsh .zshrc .tmux .tmux.conf
do
  rm -fr ~/$dotfile
  ln -vnfs $HOME/dotfiles/$dotfile $HOME/$dotfile
done
