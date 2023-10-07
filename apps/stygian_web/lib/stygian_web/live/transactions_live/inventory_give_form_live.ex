defmodule StygianWeb.TransactionsLive.InventoryGiveFormLive do
  @moduledoc """
  This module handles the objects transactions between characters.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters
  alias Stygian.Characters.CharacterSelectionForm
  alias Stygian.Objects

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

        <.character_selection
          characters={@characters}
          field={@form[:character_id]}
          label="Personaggi disponibili"
        />

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
  def handle_event(
        "save",
        %{"character_selection_form" => %{"character_id" => character_id}},
        %{assigns: %{character_object: character_object}} = socket
      ) do
    case Objects.give_object(character_object, character_id) do
      {:ok, character_object} ->
        notify_parent({:saved, character_object})

        {:noreply,
         socket
         |> put_flash(:info, "Transazione effettuata con successo.")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_characters(socket, current_owner_id) do
    assign_async(socket, :characters, fn ->
      {:ok,
       %{
         characters:
           Characters.list_characters_slim()
           |> Enum.filter(&(&1.id != current_owner_id))
       }}
    end)
  end

  defp assign_form(socket, attrs \\ %{})

  defp assign_form(socket, %Ecto.Changeset{} = attrs) do
    form = to_form(attrs)

    assign(socket, :form, form)
  end

  defp assign_form(socket, attrs) do
    changeset =
      %CharacterSelectionForm{}
      |> CharacterSelectionForm.changeset(attrs)

    assign_form(socket, changeset)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
