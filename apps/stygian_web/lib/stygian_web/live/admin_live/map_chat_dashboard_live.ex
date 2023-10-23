defmodule StygianWeb.AdminLive.MapChatDashboardLive do
  @moduledoc """
  Dashboard to show all the chat logs for a certain time range.
  """

  use StygianWeb, :container_live_view

  alias StygianWeb.AdminLive.MapChatDashboardForm

  @impl true
  def mount(_, _, socket) do
    {:ok, socket}    
  end

  @impl true
  def handle_info({:filters, params}, socket) do
    IO.inspect(params, label: "form params")
    {:noreply, socket}
  end
end
