defmodule StygianWeb.AdminLive.CharacterSheetEditStatus do
  @moduledoc """
  Updates health and sanity for the character.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters
  alias Stygian.Characters.CharacterStatusForm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h2>Assegna status</.h2>

      <.simple_form
        for={@form}
        id="character-status-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="flex flex-row justify-evenly">
          <.character_selection
            characters={@characters}
            field={@form[:character_id]}
            label="Personaggio"
          />

          <.input
            :if={@health && @lost_health}
            field={@form[:health]}
            label={"Salute (massimo: #{@health})"}
            type="number"
          />

          <.input
            :if={@sanity && @lost_sanity}
            field={@form[:sanity]}
            label={"Sanità Mentale (massimo: #{@sanity})"}
            type="number"
          />
        </div>

        <.button type="submit">Aggiorna</.button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_character_status()
     |> assign_form()}
  end

  @impl true
  def handle_event(
        "validate",
        %{"character_status_form" => %{"character_id" => character_id}},
        socket
      ) do
    {:noreply,
     socket
     |> assign_character(character_id)}
  end

  @impl true
  def handle_event("validate", %{"character_status_form" => params}, socket) do
    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("save", %{"character_status_form" => params}, socket) do
    changeset =
      %CharacterStatusForm{}
      |> CharacterStatusForm.changeset(params)

    if changeset.valid? do
      send_form(params)
      {:noreply, assign_form(socket)}
    else
      {:noreply, assign_form(socket, params)}
    end
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %CharacterStatusForm{}
      |> CharacterStatusForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_character_status(socket, character \\ %{})

  defp assign_character_status(socket, %{
         id: character_id,
         health: health,
         sanity: sanity,
         lost_health: lost_health,
         lost_sanity: lost_sanity
       }) do
    socket
    |> assign(:health, health)
    |> assign(:sanity, sanity)
    |> assign(:lost_health, lost_health)
    |> assign(:lost_sanity, lost_sanity)
    |> assign_form(%{
      "character_id" => character_id,
      "health" => health - lost_health,
      "sanity" => sanity - lost_sanity
    })
  end

  defp assign_character_status(socket, _) do
    assign_character_status(socket, %{
      id: nil,
      health: 0,
      sanity: 0,
      lost_health: 0,
      lost_sanity: 0
    })
  end

  defp assign_character(socket, character_id) do
    case Characters.get_character(character_id) do
      nil ->
        send_notification(:warning, "Il perrsonaggio non esiste")
        socket

      character ->
        assign_character_status(socket, character)
    end
  end

  defp send_form(params) do
    send(self(), {:update_status, params})
  end

  defp send_notification(level, message) do
    send(self(), {:notification, level, message})
  end
end
