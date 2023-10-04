defmodule StygianWeb.AdminLive.CharacterSheetEditSkill do
  @moduledoc """
  A form that changes a character attribute.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters
  alias Stygian.Characters.CharacterSkillForm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h2>Assegna attributo</.h2>

      <.simple_form
        for={@form}
        id="character-skill-form"
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

          <.skill_selection skills={@skills} field={@form[:skill_id]} label="Abilità o Attributo" />

          <.input field={@form[:new_value]} label="Nuovo valore" type="number" />
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
     |> assign_form()}
  end

  @impl true
  def handle_event(
        "validate",
        %{
          "character_skill_form" =>
            %{"character_id" => character_id, "skill_id" => skill_id} = params
        },
        socket
      )
      when character_id != "" and skill_id != "" do
    [character_id, skill_id] =
      Enum.map([character_id, skill_id], &String.to_integer/1)

    current_value =
      case Characters.get_character_skill(character_id, skill_id) do
        nil ->
          0

        %{value: new_value} ->
          new_value
      end

    params = Map.put(params, "new_value", current_value)
    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("validate", %{"character_skill_form" => params}, socket) do
    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("save", %{"character_skill_form" => params}, socket) do
    send_form(params)
    {:noreply, assign_form(socket)}
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %CharacterSkillForm{}
      |> CharacterSkillForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp send_form(params) do
    send(self(), {:update_attribute, params})
  end
end
