defmodule StygianWeb.ObjectLiveTest do
  use StygianWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stygian.ObjectsFixtures
  import Stygian.AccountsFixtures

  @create_attrs %{
    description: "some description",
    image_url: "some image_url",
    name: "some name",
    usages: 42
  }
  @update_attrs %{
    description: "some updated description",
    image_url: "some updated image_url",
    name: "some updated name",
    usages: 43
  }
  @invalid_attrs %{description: nil, image_url: nil, name: nil, usages: nil}

  defp create_object(_) do
    object = object_fixture()
    %{object: object}
  end

  defp create_admin_user(_) do
    user = user_fixture(%{admin: true})
    %{user: user}
  end

  describe "Index" do
    setup [:create_object, :create_admin_user]

    test "lists all objects", %{conn: conn, object: object, user: user} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/objects")

      assert html =~ "Listing Objects"
      assert html =~ object.description
    end

    test "saves new object", %{conn: conn, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/objects")

      assert index_live |> element("a", "Nuovo Oggetto") |> render_click() =~
               "Nuovo Oggetto"

      assert_patch(index_live, ~p"/admin/objects/new")

      assert index_live
             |> form("#object-form", object: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#object-form", object: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/objects")

      html = render(index_live)
      assert html =~ "Object created successfully"
      assert html =~ "some description"
    end

    test "updates object in listing", %{conn: conn, object: object, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/objects")

      assert index_live |> element("#objects-#{object.id} a", "Edit") |> render_click() =~
               "Edit Object"

      assert_patch(index_live, ~p"/admin/objects/#{object}/edit")

      assert index_live
             |> form("#object-form", object: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#object-form", object: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/objects")

      html = render(index_live)
      assert html =~ "Object updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes object in listing", %{conn: conn, object: object, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/objects")

      assert index_live |> element("#objects-#{object.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#objects-#{object.id}")
    end
  end

  describe "Show" do
    setup [:create_object, :create_admin_user]

    test "displays object", %{conn: conn, object: object, user: user} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/objects/#{object}")

      assert html =~ "Show Object"
      assert html =~ object.description
    end

    test "updates object within modal", %{conn: conn, object: object, user: user} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/objects/#{object}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Object"

      assert_patch(show_live, ~p"/admin/objects/#{object}/show/edit")

      assert show_live
             |> form("#object-form", object: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#object-form", object: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/objects/#{object}")

      html = render(show_live)
      assert html =~ "Object updated successfully"
      assert html =~ "some updated description"
    end
  end
end
