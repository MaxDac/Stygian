#!/bin/bash

#init db
psql --command "CREATE USER postgres WITH SUPERUSER PASSWORD 'mysecretpassword';" 

# Installing Back End dependencies
mix deps.get && mix deps.compile

# Creating and migrating database
mix ecto.create && mix ecto.migrate

mix run apps/stygian/priv/repo/seeds.exs

# Installing Front End dependencies
npm install --prefix apps/stygian_web/assets
