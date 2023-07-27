# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Stygian.Repo.insert!(%Stygian.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Stygian.Accounts

Accounts.register_user(%{
  email: "massimiliano.dacunzo@hotmail.com",
  username: "ghostLayer",
  password: "password1234",
})

Accounts.register_user(%{
  email: "gabriele.dacunzo@outlook.com",
  username: "Gahadiel",
  password: "password1234",
})
