defmodule StygianWeb.CharacterLive.CharacterCreateLiveTest do
  use StygianWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stygian.AccountsFixtures
  import Stygian.CharactersFixtures

  describe "Character creation page" do
    test "Redirects if not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/character/create")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/log_in"
      assert %{"error" => "You must log in to access this page."} = flash
    end

    test "Correctly redirects to the character completion page", %{conn: conn} do
      user = user_fixture()
      _ = character_fixture(%{user_id: user.id})

      assert {:error, redirect} =
               conn
               |> log_in_user(user)
               |> live(~p"/character/create")

      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/character/complete"

      assert %{
               "error" =>
                 "Devi completare la creazione del personaggio prima di accedere alla sua scheda."
             } = flash
    end

    # test "Correctly save the character", %{conn: conn} do
    #   user = user_fixture()

    #   assert {:ok, lv, _html} =
    #     conn
    #     |> log_in_user(user)
    #     |> live(~p"/character/create")

    #   result =
    #     lv
    #     |> form("#creation_1_form", %{
    #       "character[name]" => "Some Awful Name",
    #       "character[avatar]" => "https://some.awful.avatar",
    #       "character[user_id]" => user.id
    #     })
    #     |> render_submit()
    #     |> follow_redirect(conn)

    #   assert result =~ "Completion"
    # end
  end
end