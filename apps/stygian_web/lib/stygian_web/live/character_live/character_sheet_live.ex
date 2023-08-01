defmodule StygianWeb.CharacterLive.CharacterSheetLive do
  use StygianWeb, :container_live_view

  alias Stygian.Characters

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
