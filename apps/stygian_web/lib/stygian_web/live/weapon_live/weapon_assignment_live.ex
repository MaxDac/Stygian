defmodule StygianWeb.WeaponLive.WeaponAssignmentLive do
  @moduledoc """
  This live view allows to assign or remove a weapon from a character.
  """
  
  use StygianWeb, :container_live_view

  alias Stygian.Characters
  alias Stygian.Characters.CharacterSelectionForm

  alias StygianWeb.WeaponLive.WeaponAssignmentDetail

  @impl true
  def mount(_, _, socket) do
    {:ok, 
     socket
     |> assign_form()
     |> assign_character()
     |> assign_characters()}
  end

  @impl true
  def handle_event("validate", %{"character_selection_form" => params}, socket) do
    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("filter", %{"character_selection_form" => params}, socket) do
    changeset =
      %CharacterSelectionForm{}
      |> CharacterSelectionForm.changeset(params)

    if changeset.valid? do
      {:noreply, 
       socket
       |> assign_form(params)
       |> assign_characters()}
    else
      {:noreply, assign_form(socket, params)}
    end
  end

  defp assign_form(socket, attrs \\ %{}) do
    changeset =
      %CharacterSelectionForm{}
      |> CharacterSelectionForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, changeset)
  end

  defp assign_characters(socket) do
    assign_async(socket, :characters, fn ->
      {:ok,
       %{
         characters: Characters.list_characters_slim()
       }}
    end)
  end

  defp assign_character(socket, character_id \\ nil) do
    assign(socket, :character_id, character_id)
  end
end
