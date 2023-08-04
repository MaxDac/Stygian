#!/bin/bash

. $HOME/.bashrc.d/asdf.sh
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git 
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
# asdf install erlang 25.3.2.5
# asdf install elixir 1.15.4-otp-25
# asdf install nodejs 18.17.0 