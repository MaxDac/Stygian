defmodule StygianWeb.CharacterLive.CharacterCompletionLive do
  use StygianWeb, :container_live_view

  alias Stygian.Characters
  alias Stygian.Characters.Character
  alias Stygian.Characters.CharacterSkill

  alias Stygian.Skills

  import StygianWeb.CharacterLive.CharacterCompletionSelectorComponent

  @max_attributes 9
  @max_abilities 5

  @max_attribute_value 8
  @max_ability_value 5

  @min_attribute_value 3
  @min_ability_value 0

  @impl true
  def mount(_params, _session, socket = %{assigns: %{current_user: current_user}}) do
    case Characters.get_user_character?(current_user) do
      %{step: 1} ->
        form =
          %Character{}
          |> Characters.change_character_name_and_avatar(%{user_id: current_user.id})
          |> to_form()

        {:ok,
         socket
         |> assign(form: form)
         |> assign_attributes()
         |> assign_can_save()
        }

      # Character already created, redirecting to completion
      %{step: 2} ->
        {:ok,
         socket
         |> put_flash(:info, "Hai gi&agrave; completato la creazione del personaggio.")
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

  def handle_event("plus", %{"skill" => skill_id, "kind" => "attribute"}, socket) do
    {:noreply, plus_attributes(socket, String.to_integer(skill_id)) |> assign_can_save()}
  end

  def handle_event("plus", %{"skill" => skill_id, "kind" => "ability"}, socket) do
    {:noreply, plus_abilities(socket, String.to_integer(skill_id)) |> assign_can_save()}
  end

  def handle_event("minus", %{"skill" => skill_id, "kind" => "attribute"}, socket) do
    {:noreply, minus_attributes(socket, String.to_integer(skill_id)) |> assign_can_save()}
  end

  def handle_event("minus", %{"skill" => skill_id, "kind" => "ability"}, socket) do
    {:noreply, minus_abilities(socket, String.to_integer(skill_id)) |> assign_can_save()}
  end

  defp assign_attributes(socket) do
    skills = Skills.list_creational_skills()

    {attributes, abilities} =
      skills
      |> Enum.split_with(&filter_attributes/1)

    socket
    |> update_attributes(Enum.map(attributes, &%CharacterSkill{skill: &1, value: 4}))
    |> update_abilities(Enum.map(abilities, &%CharacterSkill{skill: &1, value: 0}))
    |> assign(attribute_points: @max_attributes, ability_points: @max_abilities)
  end

  defp filter_attributes(%{skill_types: [%{name: "Attribute"}]}), do: true
  defp filter_attributes(_), do: false

  defp plus_attributes(socket = %{assigns: %{ attribute_points: 0 }}, _), do: socket
  defp plus_attributes(socket = %{assigns: %{ attribute_points: points, attributes: attributes }}, skill_id) do
    case plus(attributes, skill_id, @max_attribute_value) do
      {true, attributes} ->
        socket
        |> update_attributes(attributes)
        |> assign(attribute_points: points - 1)

      {false, _} ->
        socket
    end
  end

  defp plus_abilities(socket = %{assigns: %{ ability_points: 0 }}, _), do: socket
  defp plus_abilities(socket = %{assigns: %{ ability_points: points, abilities: abilities }}, skill_id) do
    case plus(abilities, skill_id, @max_ability_value) do
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

  defp minus_attributes(socket = %{assigns: %{ attribute_points: @max_attributes }}, _), do: socket
  defp minus_attributes(socket = %{assigns: %{ attribute_points: points, attributes: attributes }}, skill_id) do
    case minus(attributes, skill_id, @min_attribute_value) do
      {true, attributes} ->
        socket
        |> update_attributes(attributes)
        |> assign(attribute_points: points + 1)

      {false, _} ->
        socket
    end
  end

  defp minus_abilities(socket = %{assigns: %{ ability_points: @max_abilities }}, _), do: socket
  defp minus_abilities(socket = %{assigns: %{ ability_points: points, abilities: abilities }}, skill_id) do
    case minus(abilities, skill_id, @min_ability_value) do
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

  defp replace_attribute(attributes, new_attribute = %CharacterSkill{skill: %{id: new_attribute_id}}) do
    attributes
    |> Enum.map(fn
      %CharacterSkill{skill: %{id: id}} when id == new_attribute_id ->
        new_attribute
      attribute ->
        attribute
    end)
  end

  defp assign_can_save(socket = %{assigns: %{attribute_points: 0, ability_points: 0}}) do
    socket
    |> assign(can_save: true)
  end

  defp assign_can_save(socket) do
    socket
    |> assign(can_save: false)
  end
end
