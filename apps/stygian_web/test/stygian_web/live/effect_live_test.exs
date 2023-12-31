defmodule StygianWeb.EffectLiveTest do
  use StygianWeb.ConnCase

  import Phoenix.LiveViewTest

  import Stygian.AccountsFixtures
  import Stygian.ObjectsFixtures
  import Stygian.SkillsFixtures

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
      %{id: object_id} = object_fixture(%{name: "some other name"})
      %{id: skill_id} = skill_fixture(%{name: "some other name"})

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

      create_attrs =
        @create_attrs
        |> Map.put(:object_id, object_id)
        |> Map.put(:skill_id, skill_id)

      assert index_live
             |> form("#effect-form", effect: create_attrs)
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
end
