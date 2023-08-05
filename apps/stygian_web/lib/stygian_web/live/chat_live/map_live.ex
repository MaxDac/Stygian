defmodule StygianWeb.ChatLive.MapLive do
  use StygianWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    IO.inspect params
    {:ok, socket}
  end
end
