defmodule StygianWeb.WeaponLive.Index do
  use StygianWeb, :live_view

  alias Stygian.Weapons
  alias Stygian.Weapons.Weapon

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :weapons, Weapons.list_weapons())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Weapon")
    |> assign(:weapon, Weapons.get_weapon!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Weapon")
    |> assign(:weapon, %Weapon{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Weapons")
    |> assign(:weapon, nil)
  end

  @impl true
  def handle_info({StygianWeb.WeaponLive.FormComponent, {:saved, weapon}}, socket) do
    {:noreply, stream_insert(socket, :weapons, weapon)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    weapon = Weapons.get_weapon!(id)
    {:ok, _} = Weapons.delete_weapon(weapon)

    {:noreply, stream_delete(socket, :weapons, weapon)}
  end
end
