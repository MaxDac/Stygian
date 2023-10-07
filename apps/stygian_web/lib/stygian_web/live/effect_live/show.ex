defmodule StygianWeb.EffectLive.Show do
  @moduledoc """
  Shows a single object effect.
  """

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
     |> assign(:effect, Objects.get_effect!(id))}
  end

  defp page_title(:show), do: "Show Effect"
  defp page_title(:edit), do: "Edit Effect"
end
