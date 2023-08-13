defmodule StygianWeb.ChatLive.ChatDiceThrowerLive do
  @moduledoc """
  LiveView for the dice thrower.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters
  alias Stygian.Characters.DiceThrower
  alias Stygian.Maps

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_character_skills()
     |> assign_form()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h1>ChatDiceThrowerLive</.h1>

      <div class="flex flex-col justify-evenly">
        <.simple_form for={@form} phx-target={@myself} phx-submit="submit" class="space-y-3">
          <.input
            field={@form[:attribute_id]}
            label="Attributo"
            type="select"
            options={to_options(@attributes)}
          />

          <.input
            field={@form[:skill_id]}
            label="Skill"
            type="select"
            options={to_options(@skills)}
          />

          <.input
            field={@form[:modifier]}
            label="Modificatore"
            type="select"
            options={range_as_options(0..10)}
          />

          <.input
            field={@form[:difficulty]}
            label="Difficoltà"
            type="select"
            options={range_as_options(10..30)}
          />

          <.button phx-disable-with="Sending..." class="w-full">
            Tira
          </.button>
        </.simple_form>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("submit", %{"dice_thrower" => params}, socket) do
    changeset = DiceThrower.changeset(%DiceThrower{}, params)

    if changeset.valid? do
      insert_dice_chat(socket, params)
    else
      {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp assign_form(socket) do
    form =
      %DiceThrower{
        attribute_id: 1,
        skill_id: 1,
        modifier: 0,
        difficulty: 20
      }
      |> DiceThrower.changeset()
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_character_skills(%{assigns: %{current_character: character}} = socket) do
    {attributes, skills} =
      Characters.list_character_attributes_skills(character)

    socket
    |> assign(:attributes, attributes)
    |> assign(:skills, skills)
  end

  defp to_options(list) do
    Enum.map(list, fn %{id: id, skill: %{name: name}} -> {name, id} end)
  end

  defp range_as_options(range) do
    Enum.map(range, fn value -> {value, value} end)
  end

  defp insert_dice_chat(%{assigns: %{
    current_character: character,
    map: %{id: map_id},
    attributes: attributes,
    skills: skills
  }} = socket, %{
    "attribute_id" => attribute_id,
    "skill_id" => skill_id,
    "modifier" => modifier,
    "difficulty" => difficulty
  }) do
    {attribute_id, skill_id, modifier, difficulty} =
      {String.to_integer(attribute_id),
       String.to_integer(skill_id),
       String.to_integer(modifier),
       String.to_integer(difficulty)}
      |> IO.inspect(label: "DiceThrower params")

    IO.inspect(attributes |> Enum.at(0), label: "attributes")

    dice_result = :rand.uniform(20)
    attribute_value = Enum.find(attributes, fn a -> a.id == attribute_id end).value
    skill_value = Enum.find(skills, fn s -> s.id == skill_id end).value

    result = dice_result + attribute_value + skill_value + modifier

    text =
      case {dice_result, result} do
        {1, _} ->
          "Hai ottenuto un fallimento critico."
        {20, _} ->
          "Hai ottenuto un successo critico."
        {_, n} when n < difficulty ->
          "Hai ottenuto un fallimento."
        _ ->
          "Hai ottenuto un successo."
      end

    insertion_result = Maps.create_chat(%{
      character_id: character.id,
      text: text,
      map_id: map_id,
      type: :dices
    })

    case insertion_result do
      {:ok, chat} ->
        send(self(), {:chat, chat})
        {:noreply, socket}
      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Errore durante l'inserimento del messaggio.")}
    end
  end
end
