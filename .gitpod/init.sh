#!/bin/bash

#init db
psql --command "CREATE USER postgres WITH SUPERUSER PASSWORD 'mysecretpassword';" 

# Setting up asdf
asdf global erlang 25.3.2.5
asdf global elixir 1.15.4-otp-25
asdf global nodejs 18.17.0

export PATH="$PATH:/home/gitpod/.asdf/shims"

# Installing Phoenix packages
mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new

# Installing Back End dependencies
mix deps.get && mix deps.compile

# Creating and migrating database
mix ecto.create && mix ecto.migrate

mix run apps/stygian/priv/repo/seeds.exs

# Installing Front End dependencies
npm install --prefix apps/stygian_web/assets
