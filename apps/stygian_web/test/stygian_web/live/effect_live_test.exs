defmodule StygianWeb.EffectLiveTest do
  use StygianWeb.ConnCase

  import Phoenix.LiveViewTest

  import Stygian.AccountsFixtures
  import Stygian.ObjectsFixtures

  @create_attrs %{value: 42}
  @update_attrs %{value: 43}
  @invalid_attrs %{value: nil}

  defp create_effect(_) do
    effect = effect_fixture()
    %{effect: effect}
  end

  defp create_admin_user(_) do
    user = user_fixture(%{admin: true})
    %{user: user}
  end

  describe "Index" do
    setup [:create_effect, :create_admin_user]

    test "lists all object_effects", %{conn: conn, user: user} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/object_effects")

      assert html =~ "Listing Object effects"
    end

    test "saves new effect", %{conn: conn, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/object_effects")

      assert index_live |> element("a", "New Effect") |> render_click() =~
               "New Effect"

      assert_patch(index_live, ~p"/admin/object_effects/new")

      assert index_live
             |> form("#effect-form", effect: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#effect-form", effect: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/object_effects")

      html = render(index_live)
      assert html =~ "Effect created successfully"
    end

    test "updates effect in listing", %{conn: conn, effect: effect, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/object_effects")

      assert index_live |> element("#object_effects-#{effect.id} a", "Edit") |> render_click() =~
               "Edit Effect"

      assert_patch(index_live, ~p"/admin/object_effects/#{effect}/edit")

      assert index_live
             |> form("#effect-form", effect: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#effect-form", effect: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/object_effects")

      html = render(index_live)
      assert html =~ "Effect updated successfully"
    end

    test "deletes effect in listing", %{conn: conn, effect: effect, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/object_effects")

      assert index_live |> element("#object_effects-#{effect.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#object_effects-#{effect.id}")
    end
  end

  describe "Show" do
    setup [:create_effect, :create_admin_user]

    test "displays effect", %{conn: conn, effect: effect, user: user} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/object_effects/#{effect}")

      assert html =~ "Show Effect"
    end

    test "updates effect within modal", %{conn: conn, effect: effect, user: user} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/object_effects/#{effect}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Effect"

      assert_patch(show_live, ~p"/admin/object_effects/#{effect}/show/edit")

      assert show_live
             |> form("#effect-form", effect: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#effect-form", effect: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/object_effects/#{effect}")

      html = render(show_live)
      assert html =~ "Effect updated successfully"
    end
  end
end
