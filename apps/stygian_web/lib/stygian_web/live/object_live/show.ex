defmodule StygianWeb.ObjectLive.Show do
  use StygianWeb, :container_live_view

  alias Stygian.Objects

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:object, Objects.get_object!(id))}
  end

  defp page_title(:show), do: "Show Object"
  defp page_title(:edit), do: "Edit Object"
end
