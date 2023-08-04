#! /bin/bash
echo "Installing Erlang"
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 25.3.2.5

echo "Installing Elixir"
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.15.4-otp-25

echo "Installing Node"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 18.17.0