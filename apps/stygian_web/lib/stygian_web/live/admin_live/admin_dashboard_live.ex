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

    <div class="w-full flex flex-col items-center">
      <.link 
        class="text-xl font-typewriter"
        patch={~p"/admin/objects"}>Oggetti</.link>
    </div>
    """
  end
end
