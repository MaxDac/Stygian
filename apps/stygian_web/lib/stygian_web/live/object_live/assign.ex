defmodule StygianWeb.ObjectLive.Assign do
  @moduledoc """
  This page assigns an object to a particular character.
  """

  use StygianWeb, :container_live_view

  alias Phoenix.LiveView.AsyncResult

  alias Stygian.Characters
  alias Stygian.Objects
  alias Stygian.Objects.CharacterObject

  @impl true
  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign_form()
     |> assign_all_characters()
     |> assign_all_objects()}
  end

  @impl true
  def handle_event("validate", %{"character_object" => character_object_params}, socket) do
    {character_object_params, socket} =
      character_object_params
      |> reassign_usages(socket)

    {:noreply,
     socket
     |> assign_form(character_object_params)}
  end

  @impl true
  def handle_event("save", %{"character_object" => character_object_params}, socket) do
    case Objects.create_character_objects(character_object_params) do
      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Errore nel creare l'oggetto")
         |> assign_form(character_object_params)}

      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Oggetto assegnato con successo")
         |> assign_form()}
    end
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %CharacterObject{}
      |> Objects.change_character_object(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_all_characters(socket) do
    assign_async(socket, :characters, fn ->
      {:ok,
       %{
         characters: Characters.list_characters()
       }}
    end)
  end

  defp assign_all_objects(socket) do
    assign_async(socket, :objects, fn ->
      {:ok,
       %{
         objects: Objects.list_objects()
       }}
    end)
  end

  defp reassign_usages(
         %{"object_id" => object_id} = params,
         %{assigns: %{previous_object_id: object_id}} = socket
       ) do
    # The object didn't change, no need to update the usages.
    {params, socket}
  end

  defp reassign_usages(
         %{"object_id" => object_id} = params,
         %{assigns: %{objects: %AsyncResult{result: objects}}} = socket
       )
       when is_binary(object_id) do
    case object_id != "" && Enum.filter(objects, &(&1.id == String.to_integer(object_id))) do
      [%{usages: object_usages}] ->
        {
          Map.put(params, "usages", object_usages),
          assign(socket, :previous_object_id, object_id)
        }

      _ ->
        {params, socket}
    end
  end

  defp reassign_usages(params, socket) do
    {params, socket}
  end
end
