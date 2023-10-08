defmodule StygianWeb.ChatLive.ObjectUsageLive do
  @moduledoc """
  Live Component that allows the character to use an object.
  """
  
  use StygianWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h2>Usa Oggetto</.h2>
    </div>
    """
  end
end
