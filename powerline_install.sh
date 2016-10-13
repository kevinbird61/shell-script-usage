# Install basic install tools
yes | sudo apt-get install python-pip git

# install the source
pip install --user git+git://github.com/Lokaltog/powerline

# Add into .profile
echo "if [ -d \"$HOME/.local/bin\" ]; then" >> ~/.profile
echo "	PATH=\"$HOME/.local/bin:$PATH\"" >> ~/.profile
echo "fi" >> ~./profile

# Font installation
wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
sudo mv PowerlineSymbols.otf /usr/share/fonts/

# Figure the font
sudo fc-cache -vf 
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/

# Change Vim statusline into powerline 
echo "set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/" >> ~/.vimrc
echo "set laststatus=2" >> ~/.vimrc
echo "set t_Co=256" >> ~/.vimrc

# Change Bash style to powerline
echo "if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then" >> ~/.bashrc
echo "	source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh" >> ~/.bashrc
echo "fi" >> ~/.bashrc
