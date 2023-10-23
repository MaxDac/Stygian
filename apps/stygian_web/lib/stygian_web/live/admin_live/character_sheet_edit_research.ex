defmodule StygianWeb.AdminLive.CharacterSheetEditResearch do
  @moduledoc """
  Form to handle the assignation of research points points.
  """

  use StygianWeb, :live_component

  import Stygian

  alias Stygian.Characters
  alias Stygian.Characters.CharacterResearchForm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h2>Assegna punti ricerca</.h2>

      <.simple_form
        for={@form}
        id="character-research-form"
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
            field={@form[:research_points]}
            label="Punti ricerca"
            type="number"
            value={@got_research_points}
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
     |> assign_research_points()
     |> assign_selected_character_research_id()
     |> assign_form()}
  end

  @impl true
  def handle_event(
        "validate",
        %{
          "character_research_form" => %{"character_id" => character_id} = params
        },
        %{assigns: %{selected_character_research_id: research_character_id}} = socket
      )
      when is_not_null_nor_empty(character_id) and character_id != research_character_id do
    character_id = id_from_params(character_id)

    socket =
      case Characters.get_character!(character_id) do
        %{research_points: research_points} ->
          socket
          |> assign_research_points(research_points)
          |> assign_selected_character_research_id(character_id)

        _ ->
          socket
      end

    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("validate", %{"character_research_form" => params}, socket) do
    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("save", %{"character_research_form" => params}, socket) do
    changeset =
      %CharacterResearchForm{}
      |> CharacterResearchForm.changeset(params)

    if changeset.valid? do
      send_form(params)
      {:noreply, assign_form(socket)}
    else
      {:noreply, assign_form(socket, params)}
    end
  end

  defp assign_research_points(socket, research_points \\ nil) do
    assign(socket, :got_research_points, research_points)
  end

  defp assign_selected_character_research_id(socket, character_id \\ nil)

  # Changing it to string so that the equality between the cached value and the
  # param from the form will be of the same type.
  defp assign_selected_character_research_id(socket, character_id)
       when not is_binary(character_id),
       do: assign_selected_character_research_id(socket, to_string(character_id))

  defp assign_selected_character_research_id(socket, character_id) do
    assign(socket, :selected_character_research_id, character_id)
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %CharacterResearchForm{}
      |> CharacterResearchForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp send_form(params) do
    send(self(), {:update_research, params})
  end
end
