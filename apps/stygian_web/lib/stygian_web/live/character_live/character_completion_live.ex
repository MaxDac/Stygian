defmodule StygianWeb.CharacterLive.CharacterCompletionLive do
  use StygianWeb, :container_live_view

  require Logger

  alias Stygian.Characters
  alias Stygian.Characters.CharacterSkill

  alias Stygian.Skills

  import StygianWeb.CharacterLive.CharacterCompletionSelectorComponent

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    case Characters.get_user_character?(current_user) do
      character = %{step: 1} ->
        {:ok,
         socket
         |> assign(character: character)
         |> assign_character_stats()
         |> assign_attributes()
         |> assign_can_save()}

      # Character already created, redirecting to completion
      %{step: 2} ->
        {:ok,
         socket
         # Removed as it's not an error.
         # |> put_flash(:info, "Hai gi&agrave; completato la creazione del personaggio.")
         |> push_navigate(to: ~p"/character/sheet")}

      _ ->
        {:ok,
         socket
         |> put_flash(
           :error,
           "Troppo presto! Devi prima fornire le informazioni generali sul personaggio."
         )
         |> push_navigate(to: ~p"/character/create")}
    end
  end

  @impl true
  def handle_event("plus", %{"skill" => skill_id, "kind" => "attribute"}, socket) do
    {:noreply, plus_attributes(socket, String.to_integer(skill_id)) |> assign_can_save()}
  end

  @impl true
  def handle_event("plus", %{"skill" => skill_id, "kind" => "ability"}, socket) do
    {:noreply, plus_abilities(socket, String.to_integer(skill_id)) |> assign_can_save()}
  end

  @impl true
  def handle_event("minus", %{"skill" => skill_id, "kind" => "attribute"}, socket) do
    {:noreply, minus_attributes(socket, String.to_integer(skill_id)) |> assign_can_save()}
  end

  @impl true
  def handle_event("minus", %{"skill" => skill_id, "kind" => "ability"}, socket) do
    {:noreply, minus_abilities(socket, String.to_integer(skill_id)) |> assign_can_save()}
  end

  @impl true
  def handle_event(
        "save",
        _params,
        %{
          assigns: %{
            character: character,
            attribute_points: 0,
            ability_points: 0,
            attributes: attributes,
            abilities: abilities
          }
        } = socket
      ) do
    case complete_character(character, attributes, abilities) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Personaggio completato con successo.")
         |> redirect(to: ~p"/character/redirect/#{character.id}")}

      {:error, changeset} ->
        Logger.error("Error while saving character: #{inspect(changeset)}")

        {:noreply,
         socket
         |> put_flash(:error, "Errore durante il salvataggio del personaggio.")}
    end
  end

  defp assign_attributes(%{assigns: %{character: %{id: character_id}, max_attributes: max_attributes, max_skills: max_skills}} = socket) do
    skills = Skills.list_creational_skills()

    {attributes, abilities} =
      skills
      |> Enum.split_with(&filter_attributes/1)

    socket
    |> update_attributes(
      Enum.map(
        attributes,
        &%CharacterSkill{skill: &1, skill_id: &1.id, character_id: character_id, value: 4}
      )
    )
    |> update_abilities(
      Enum.map(
        abilities,
        &%CharacterSkill{skill: &1, skill_id: &1.id, character_id: character_id, value: 0}
      )
    )
    |> assign(attribute_points: max_attributes, ability_points: max_skills)
  end

  defp filter_attributes(%{skill_types: [%{name: "Attribute"}]}), do: true
  defp filter_attributes(_), do: false

  defp plus_attributes(%{assigns: %{attribute_points: 0}} = socket, _), do: socket

  defp plus_attributes(
         %{assigns: %{attribute_points: points, attributes: attributes, max_attribute_value: max_attribute_value}} = socket,
         skill_id
       ) do
    case plus(attributes, skill_id, max_attribute_value) do
      {true, attributes} ->
        socket
        |> update_attributes(attributes)
        |> assign(attribute_points: points - 1)

      {false, _} ->
        socket
    end
  end

  defp plus_abilities(%{assigns: %{ability_points: 0}} = socket, _), do: socket

  defp plus_abilities(
         %{assigns: %{ability_points: points, abilities: abilities, max_skill_value: max_skill_value}} = socket,
         skill_id
       ) do
    case plus(abilities, skill_id, max_skill_value) do
      {true, abilities} ->
        socket
        |> update_abilities(abilities)
        |> assign(ability_points: points - 1)

      {false, _} ->
        socket
    end
  end

  defp plus(skills, skill_id, max_skill_value) do
    skill = skills |> Enum.find(&(&1.skill.id == skill_id))

    case skill do
      %CharacterSkill{value: value} when value < max_skill_value ->
        skill = %CharacterSkill{skill | value: value + 1}
        {true, replace_attribute(skills, skill)}

      _ ->
        {false, skills}
    end
  end

  defp minus_attributes(%{assigns: %{attribute_points: max_attributes, max_attributes: max_attributes}} = socket, _), do: socket

  defp minus_attributes(
         %{assigns: %{attribute_points: points, attributes: attributes, min_attribute_value: min_attribute_value}} = socket,
         skill_id
       ) do
    case minus(attributes, skill_id, min_attribute_value) do
      {true, attributes} ->
        socket
        |> update_attributes(attributes)
        |> assign(attribute_points: points + 1)

      {false, _} ->
        socket
    end
  end

  defp minus_abilities(%{assigns: %{ability_points: max_skills, max_skills: max_skills}} = socket, _), do: socket

  defp minus_abilities(
         %{assigns: %{ability_points: points, abilities: abilities, min_skill_value: min_skill_value}} = socket,
         skill_id
       ) do
    case minus(abilities, skill_id, min_skill_value) do
      {true, abilities} ->
        socket
        |> update_abilities(abilities)
        |> assign(ability_points: points + 1)

      {false, _} ->
        socket
    end
  end

  defp minus(skills, skill_id, min_skill_value) do
    skill = skills |> Enum.find(&(&1.skill.id == skill_id))

    case skill do
      %CharacterSkill{value: value} when value > min_skill_value ->
        skill = %CharacterSkill{skill | value: value - 1}
        skills = replace_attribute(skills, skill)
        {true, skills}

      _ ->
        {false, skills}
    end
  end

  defp update_attributes(socket, attributes) do
    socket
    |> assign(attributes: attributes)
  end

  defp update_abilities(socket, abilities) do
    socket
    |> assign(abilities: abilities)
  end

  defp replace_attribute(
         attributes,
         %CharacterSkill{skill: %{id: new_attribute_id}} = new_attribute
       ) do
    attributes
    |> Enum.map(fn
      %CharacterSkill{skill: %{id: id}} when id == new_attribute_id ->
        new_attribute

      attribute ->
        attribute
    end)
  end

  defp assign_character_stats(%{assigns: %{character: character}} = socket) do
    max_abilities = Characters.get_max_available_attribute_points(character)
    max_skills = Characters.get_max_available_attribute_points(character)

    max_attribute_value = Characters.get_creation_max_attribute_value()
    max_skill_value = Characters.get_creation_max_skill_value(character)

    min_attribute_value = Characters.get_creation_min_attribute_value()
    min_skill_value = Characters.get_creation_min_skill_value()

    socket
    |> assign(
      max_abilities: max_abilities,
      max_skills: max_skills,
      max_attribute_value: max_attribute_value,
      max_skill_value: max_skill_value,
      min_attribute_value: min_attribute_value,
      min_skill_value: min_skill_value
    )
  end

  defp assign_can_save(%{assigns: %{attribute_points: 0, ability_points: 0}} = socket) do
    socket
    |> assign(can_save: true)
  end

  defp assign_can_save(socket) do
    socket
    |> assign(can_save: false)
  end

  defp complete_character(character, attributes, abilities) do
    with {:ok, _} <- Characters.create_character_skills(attributes, abilities, character),
         result = {:ok, _} <- Characters.complete_character(character) do
      result
    end
  end
end
