defmodule StygianWeb.CharacterLive.CharacterSheetLiveTest do
  use StygianWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stygian.AccountsFixtures
  import Stygian.CharactersFixtures

  describe "Character sheet page" do
    test "Redirects if not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/character/sheet")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/log_in"
      assert %{"error" => "Devi effettuare il login per accedere a questa pagina."} = flash
    end

    test "Correctly redirects to the character creation page", %{conn: conn} do
      assert {:error, redirect} =
               conn
               |> log_in_user(user_fixture())
               |> live(~p"/character/sheet")

      assert {:live_redirect, %{to: path}} = redirect
      assert path == ~p"/character/create"
    end

    test "Correctly redirects to the character completion page", %{conn: conn} do
      user = user_fixture()
      _ = character_fixture(%{user_id: user.id})

      assert {:error, redirect} =
               conn
               |> log_in_user(user)
               |> live(~p"/character/sheet")

      assert {:live_redirect, %{to: path}} = redirect
      assert path == ~p"/character/complete"
    end
  end
end
