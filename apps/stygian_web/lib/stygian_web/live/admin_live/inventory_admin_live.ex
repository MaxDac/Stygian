defmodule StygianWeb.AdminLive.InventoryAdminLive do
  @moduledoc """
  Allows the admin to manage the character inventory from the admin panel.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters
  alias Stygian.Characters.CharacterSelectionForm
  alias Stygian.Objects

  @impl true
  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign_characters()
     |> assign_form()
     |> assign_inventory()}
  end

  @impl true
  def handle_event(
        "changed_filters",
        %{"character_selection_form" => %{"character_id" => character_id} = params},
        socket
      ) do
    {:noreply,
     socket
     |> assign_form(params)
     |> assign_inventory(character_id)}
  end

  @impl true
  def handle_event("remove_object", %{"id" => character_object_id}, socket) do
    character_object = Objects.get_character_object!(character_object_id)

    case Objects.delete_character_object(character_object) do
      {:ok, _} ->
        {:noreply,
         socket
         |> stream_delete(:inventory, character_object)
         |> put_flash(
           :info,
           "L'oggetto è stato rimosso correttamente dall'inventario del personaggio."
         )}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           "Non è stato possibile rimuovere l'oggetto dall'inventario del personaggio."
         )}
    end
  end

  defp assign_characters(socket) do
    assign_async(socket, :characters, fn ->
      {:ok,
       %{
         characters: Characters.list_characters_slim()
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

  defp assign_inventory(socket, character_id \\ nil)

  defp assign_inventory(socket, nil) do
    stream(socket, :inventory, [])
  end

  defp assign_inventory(socket, character_id) do
    stream(socket, :inventory, Objects.list_character_objects(character_id))
  end
end
