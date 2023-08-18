defmodule StygianWeb.AdminLive.CharacterNpcCreationLive do
  @moduledoc """
  Creates a new NPC.
  """
  
  use StygianWeb, :container_live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>PNG - Creazione</.h1> 
    """
  end
end
