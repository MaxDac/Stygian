defmodule StygianWeb.WeaponLive.Show do
  use StygianWeb, :live_view

  alias Stygian.Weapons

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:weapon, Weapons.get_weapon!(id))}
  end

  defp page_title(:show), do: "Show Weapon"
  defp page_title(:edit), do: "Edit Weapon"
end
