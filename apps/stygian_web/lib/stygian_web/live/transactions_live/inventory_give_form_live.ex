defmodule StygianWeb.TransactionsLive.InventoryGiveFormLive do
  @moduledoc """
  This module handles the objects transactions between characters.  
  """

  use StygianWeb, :live_component

  alias Stygian.Characters
  alias Stygian.Characters.CharacterSelectionForm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="character_selection_form"
        phx-submit="save"
        phx-change="validate"
        phx-target={@myself}
      >
        <.h1>Dai <%= @character_object.object.name %> a un personaggio</.h1>

        <.character_selection characters={@characters} field={@form[:character_id]} label="Personaggi disponibili" />

        <.button type="submit">Dai oggetto</.button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, 
     socket
     |> assign(assigns)
     |> assign_characters(assigns.character_object.character_id)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"character_selection_form" => params}, socket) do
    form =
      %CharacterSelectionForm{}
      |> CharacterSelectionForm.changeset(params)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  @impl true
  def handle_event("save", %{"character_selection_form" => params}, socket) do
    {:noreply, socket}
  end

  defp assign_characters(socket, current_owner_id) do
    assign_async(socket, :characters, fn -> 
      {:ok, %{
        characters: 
          Characters.list_characters_slim()
          |> Enum.filter(& &1.id != current_owner_id)
      }} 
    end)
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %CharacterSelectionForm{}
      |> CharacterSelectionForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end
end
