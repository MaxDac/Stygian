defmodule StygianWeb.CharacterLive.CharacterCompletionLive do
  use StygianWeb, :container_live_view

  alias Stygian.Characters

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
