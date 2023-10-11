defmodule StygianWeb.AdminLive.AdminDashboardLive do
  @moduledoc """
  The AdminDashboardLive module.
  """

  use StygianWeb, :container_live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Admin Dashboard</.h1>

    <div class="w-full flex flex-col space-y-5 items-center">
      <.link class="text-xl font-typewriter" patch={~p"/admin/objects"}>Oggetti</.link>
      <.link class="text-xl font-typewriter" patch={~p"/admin/object_effects"}>Effetti</.link>
      <.link class="text-xl font-typewriter" patch={~p"/admin/effects"}>Lista Effetti Attivi</.link>
      <.link class="text-xl font-typewriter" patch={~p"/admin/transactions"}>Lista transazioni</.link>
      <.link class="text-xl font-typewriter" patch={~p"/admin/character"}>Edita personaggio</.link>
      <.link class="text-xl font-typewriter" patch={~p"/admin/organisations"}>
        Edita Organizzazioni
      </.link>
    </div>
    """
  end
end
