defmodule StygianWeb.WeaponLiveTest do
  @moduledoc """
  Tests for the Weapon LiveView.
  """

  use StygianWeb.ConnCase

  import Phoenix.LiveViewTest

  import Stygian.WeaponsFixtures
  import Stygian.AccountsFixtures

  @create_attrs %{name: "some name", description: "some description", image_url: "some image_url", required_skill_min_value: 42, damage_bonus: 42, cost: 42}
  @update_attrs %{name: "some updated name", description: "some updated description", image_url: "some updated image_url", required_skill_min_value: 43, damage_bonus: 43, cost: 43}
  @invalid_attrs %{name: nil, description: nil, image_url: nil, required_skill_min_value: nil, damage_bonus: nil, cost: nil}

  defp create_weapon(_) do
    weapon = weapon_fixture()
    %{weapon: weapon}
  end

  defp create_admin_user(_) do
    user = user_fixture(%{admin: true})
    %{user: user}
  end

  describe "Index" do
    setup [:create_weapon, :create_admin_user]

    test "lists all weapons", %{conn: conn, weapon: weapon, user: user} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/weapons")

      assert html =~ "Listing Weapons"
      assert html =~ weapon.name
    end

    test "saves new weapon", %{conn: conn, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/weapons")

      assert index_live |> element("a", "New Weapon") |> render_click() =~
               "New Weapon"

      assert_patch(index_live, ~p"/admin/weapons/new")

      assert index_live
             |> form("#weapon-form", weapon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#weapon-form", weapon: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/weapons")

      html = render(index_live)
      assert html =~ "Weapon created successfully"
      assert html =~ "some name"
    end

    test "updates weapon in listing", %{conn: conn, weapon: weapon, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/weapons")

      assert index_live |> element("#weapons-#{weapon.id} a", "Edit") |> render_click() =~
               "Edit Weapon"

      assert_patch(index_live, ~p"/admin/weapons/#{weapon}/edit")

      assert index_live
             |> form("#weapon-form", weapon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#weapon-form", weapon: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/weapons")

      html = render(index_live)
      assert html =~ "Weapon updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes weapon in listing", %{conn: conn, weapon: weapon, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/weapons")

      assert index_live |> element("#weapons-#{weapon.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#weapons-#{weapon.id}")
    end
  end

  describe "Show" do
    setup [:create_weapon, :create_admin_user]

    test "displays weapon", %{conn: conn, weapon: weapon, user: user} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/weapons/#{weapon}")

      assert html =~ "Show Weapon"
      assert html =~ weapon.name
    end

    test "updates weapon within modal", %{conn: conn, weapon: weapon, user: user} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/weapons/#{weapon}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Weapon"

      assert_patch(show_live, ~p"/admin/weapons/#{weapon}/show/edit")

      assert show_live
             |> form("#weapon-form", weapon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#weapon-form", weapon: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/weapons/#{weapon}")

      html = render(show_live)
      assert html =~ "Weapon updated successfully"
      assert html =~ "some updated name"
    end
  end
end
