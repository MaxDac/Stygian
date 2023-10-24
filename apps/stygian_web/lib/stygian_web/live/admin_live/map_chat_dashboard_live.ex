defmodule StygianWeb.AdminLive.MapChatDashboardLive do
  @moduledoc """
  Dashboard to show all the chat logs for a certain time range.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Maps
  alias Stygian.Maps.MapChatsSelectionForm

  alias StygianWeb.AdminLive.MapChatDashboardForm

  import StygianWeb.AdminLive.MapChatDashboardLogComponents

  @impl true
  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign_chats()}
  end

  @impl true
  def handle_info({:filters, params}, socket) do
    {:noreply,
     socket
     |> assign_chats(params)}
  end

  defp assign_chats(socket, filters \\ nil)

  defp assign_chats(socket, nil) do
    stream(socket, :chats, [])
  end

  defp assign_chats(socket, filters) do
    changeset =
      %MapChatsSelectionForm{}
      |> MapChatsSelectionForm.changeset(filters)
      |> IO.inspect(label: "changeset")

    if changeset.valid? do
      stream(socket, :chats, Maps.list_map_chats_logs(changeset.changes))
    else
      stream(socket, :chats, [])
    end
  end
end
