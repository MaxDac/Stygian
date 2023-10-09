defmodule StygianWeb.ChatLive.ObjectUsageLive do
  @moduledoc """
  Live Component that allows the character to use an object.
  """
  
  use StygianWeb, :live_component
  
  alias Stygian.Objects

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h2>Usa Oggetto</.h2>
      
      <.table
        id="character_objects"
        rows={@streams.character_objects}
      >
        <:col :let={{_id, %{object: object}}} label="Nome"><%= object.name %></:col>
        <:col :let={{_id, %{object: object}}} label="Descr."><%= object.description %></:col>
        <:col :let={{_id, %{object: object}}} label="Immagine">
          <img alt={object.name} src={object.image_url} class="max-w-[100px] max-h-[100px] h-auto w-auto" />
        </:col>
        <:col :let={{_id, %{object: object}}} label="Usi rimasti"><%= object.usages %></:col>
        <:action :let={{_, object}}>
          <.table_link_standalone
            phx-click={JS.push("use_object", value: %{id: object.id})}
            data-confirm="Sei sicuro di voler usare questo oggetto?"
          >
            Usa
          </.table_link_standalone>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_objects()}
  end

  defp assign_objects(%{assigns: %{current_character: %{id: character_id}}} = socket) do
    stream(socket, :character_objects, Objects.list_character_objects(character_id))
  end
end
