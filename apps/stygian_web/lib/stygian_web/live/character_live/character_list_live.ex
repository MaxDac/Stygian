defmodule StygianWeb.CharacterLive.CharacterListLive do
  @moduledoc false

  use StygianWeb, :container_live_view

  alias Stygian.Characters

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
     socket
     |> assign_characters()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Character List</.h1>

    <div :for={character <- @characters} class="font-typewriter w-full text-center">
      <.link href={~p"/character/sheet/#{character.id}"}>
        <%= character.name %>
      </.link>
    </div>
   """
  end

  defp assign_characters(socket) do
    socket
    |> assign(:characters, Characters.list_characters_slim())
  end
end
