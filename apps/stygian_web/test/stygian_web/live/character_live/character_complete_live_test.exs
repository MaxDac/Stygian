defmodule StygianWeb.CharacterLive.CharacterCompleteLiveTest do
  use StygianWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stygian.AccountsFixtures

  describe "Character complete page" do
    test "Redirects if not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/character/complete")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/log_in"
      assert %{"error" => "Devi effettuare il login per accedere a questa pagina."} = flash
    end

    test "Correctly redirects to the character creation page", %{conn: conn} do
      user = user_fixture()

      assert {:error, redirect} =
               conn
               |> log_in_user(user)
               |> live(~p"/character/complete")

      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/character/create"

      assert %{
               "error" =>
                 "Troppo presto! Devi prima fornire le informazioni generali sul personaggio."
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
