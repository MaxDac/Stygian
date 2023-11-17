defmodule StygianWeb.WeaponLive.WeaponAssignmentLive do
  @moduledoc """
  This live view allows to assign or remove a weapon from a character.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters
  alias Stygian.Characters.CharacterSelectionForm
  alias Stygian.Weapons

  alias StygianWeb.WeaponLive.WeaponAssignmentDetail
  alias StygianWeb.WeaponLive.WeaponAssignmentForm

  @impl true
  def mount(_, _, socket) do
    {:ok,
     socket
     |> reset_assigns()
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
       |> assign_character(changeset.changes.character_id)
       |> assign_characters()}
    else
      {:noreply, assign_form(socket, params)}
    end
  end

  @impl true
  def handle_event("add_weapon", %{"character_id" => _}, socket) do
    {:noreply,
     socket
     |> assign_modal_state(:show)}
  end

  @impl true
  def handle_event(
        "remove_weapon",
        %{
          "character_id" => character_id,
          "weapon_id" => weapon_id
        },
        socket
      ) do
    case Weapons.remove_weapon_from_character(character_id, weapon_id) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Arma rimossa con successo")
         |> reset_assigns()}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Errore durante la rimozione dell'arma")}
    end
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply, reset_assigns(socket)}
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

  defp assign_modal_state(socket, :show), do: assign(socket, :modal_state, :show)
  defp assign_modal_state(socket, _), do: assign(socket, :modal_state, :hide)

  defp assign_detail_component_id(socket) do
    assign(socket, :detail_component_id, "#{:rand.uniform(100)}_weapon_assignment_detail")
  end

  defp assign_form_component_id(socket) do
    assign(socket, :form_component_id, "#{:rand.uniform(100)}_weapon_assignment_form")
  end

  defp reset_assigns(socket) do
    socket
    |> assign_form_component_id()
    |> assign_detail_component_id()
    |> assign_form()
    |> assign_character()
    |> assign_modal_state(:hide)
  end
end
