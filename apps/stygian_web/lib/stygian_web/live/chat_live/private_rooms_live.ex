defmodule StygianWeb.ChatLive.PrivateRoomsLive do
  @moduledoc """
  Manages the private rooms.
  """
  
  use StygianWeb, :container_live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Locazioni private.</.h1>
    """
  end
end
