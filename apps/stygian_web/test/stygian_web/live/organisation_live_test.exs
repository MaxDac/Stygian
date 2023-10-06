defmodule StygianWeb.OrganisationLiveTest do
  use StygianWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stygian.OrganisationsFixtures
  import Stygian.AccountsFixtures

  @create_attrs %{
    name: "some name",
    description: "some description",
    image: "some image",
    base_salary: 42
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    image: "some updated image",
    base_salary: 43
  }
  @invalid_attrs %{name: nil, description: nil, image: nil, base_salary: nil}

  defp create_organisation(_) do
    organisation = organisation_fixture()
    %{organisation: organisation}
  end

  defp create_admin_user(_) do
    user = user_fixture(%{admin: true})
    %{user: user}
  end

  describe "Index" do
    setup [:create_organisation, :create_admin_user]

    test "lists all organisations", %{conn: conn, organisation: organisation, user: user} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/organisations")

      assert html =~ "Listing Organisations"
      assert html =~ organisation.name
    end

    test "saves new organisation", %{conn: conn, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/organisations")

      assert index_live |> element("a", "New Organisation") |> render_click() =~
               "New Organisation"

      assert_patch(index_live, ~p"/admin/organisations/new")

      assert index_live
             |> form("#organisation-form", organisation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#organisation-form", organisation: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/organisations")

      html = render(index_live)
      assert html =~ "Organisation created successfully"
      assert html =~ "some name"
    end

    test "updates organisation in listing", %{conn: conn, organisation: organisation, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/organisations")

      assert index_live
             |> element("#organisations-#{organisation.id} a", "Edit")
             |> render_click() =~
               "Edit Organisation"

      assert_patch(index_live, ~p"/admin/organisations/#{organisation}/edit")

      assert index_live
             |> form("#organisation-form", organisation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#organisation-form", organisation: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/organisations")

      html = render(index_live)
      assert html =~ "Organisation updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes organisation in listing", %{conn: conn, organisation: organisation, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/organisations")

      assert index_live
             |> element("#organisations-#{organisation.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#organisations-#{organisation.id}")
    end
  end

  describe "Show" do
    setup [:create_organisation, :create_admin_user]

    test "displays organisation", %{conn: conn, organisation: organisation, user: user} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/organisations/#{organisation}")

      assert html =~ "Show Organisation"
      assert html =~ organisation.name
    end

    test "updates organisation within modal", %{
      conn: conn,
      organisation: organisation,
      user: user
    } do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/admin/organisations/#{organisation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Organisation"

      assert_patch(show_live, ~p"/admin/organisations/#{organisation}/show/edit")

      assert show_live
             |> form("#organisation-form", organisation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#organisation-form", organisation: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/organisations/#{organisation}")

      html = render(show_live)
      assert html =~ "Organisation updated successfully"
      assert html =~ "some updated name"
    end
  end
end
