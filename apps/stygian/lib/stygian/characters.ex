defmodule Stygian.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset

  alias Stygian.Repo

  alias Stygian.Accounts
  alias Stygian.Accounts.User
  alias Stygian.Characters.Character
  alias Stygian.Characters.CharacterEffect
  alias Stygian.Characters.CharacterSkill
  alias Stygian.Characters.CharacterSkillForm

  alias Stygian.Objects
  alias Stygian.Objects.CharacterObject
  alias Stygian.Objects.Effect
  alias Stygian.Objects.Object

  alias Stygian.Skills.Skill

  @max_attribute_points 9
  @max_skill_points 9

  @creation_max_attribute_sum 33
  @creation_max_skill_sum 9

  @creation_max_attribute_value 8
  @creation_min_attribute_value 3

  @creation_max_skill_value 4
  @creation_min_skill_value 0

  @physique_skill_name "Fisico"
  @mind_skill_name "Mente"
  @will_skill_name "Volontà"

  @default_character_initial_cigs 200
  @default_character_initial_experience 0

  @rest_limit_hours 24
  @rest_sanity_recovery 5
  @rest_cost 5

  @character_effect_time_in_hour 3
  @character_sanity_from_cig 3

  @spec get_max_available_attribute_points(character :: Character.t()) :: non_neg_integer()
  def get_max_available_attribute_points(character)
  def get_max_available_attribute_points(%{age: :young}), do: @max_attribute_points + 1
  def get_max_available_attribute_points(%{age: :old}), do: @max_attribute_points - 1
  def get_max_available_attribute_points(_), do: @max_attribute_points

  @spec get_max_available_skill_points(character :: Character.t()) :: non_neg_integer()
  def get_max_available_skill_points(character)
  def get_max_available_skill_points(%{age: :young}), do: @max_skill_points - 4
  def get_max_available_skill_points(%{age: :old}), do: @max_skill_points + 4
  def get_max_available_skill_points(_), do: @max_skill_points

  @spec get_creation_max_attribute_points(character :: Character.t()) :: non_neg_integer()
  def get_creation_max_attribute_points(character)
  def get_creation_max_attribute_points(%{age: :young}), do: @creation_max_attribute_sum + 1
  def get_creation_max_attribute_points(%{age: :old}), do: @creation_max_attribute_sum - 1
  def get_creation_max_attribute_points(_), do: @creation_max_attribute_sum

  @spec get_creation_max_skill_points(character :: Character.t()) :: non_neg_integer()
  def get_creation_max_skill_points(character)
  def get_creation_max_skill_points(%{age: :young}), do: @creation_max_skill_sum - 4
  def get_creation_max_skill_points(%{age: :old}), do: @creation_max_skill_sum + 4
  def get_creation_max_skill_points(_), do: @creation_max_skill_sum

  def get_creation_max_attribute_value, do: @creation_max_attribute_value

  def get_creation_min_attribute_value, do: @creation_min_attribute_value

  @spec get_creation_max_skill_value(character :: Character.t()) :: non_neg_integer()
  def get_creation_max_skill_value(character)
  def get_creation_max_skill_value(%{age: :young}), do: @creation_max_skill_value - 1
  def get_creation_max_skill_value(%{age: :old}), do: @creation_max_skill_value + 1
  def get_creation_max_skill_value(_), do: @creation_max_skill_value

  def get_creation_min_skill_value, do: @creation_min_skill_value

  @doc """
  Returns the list of characters.

  ## Examples

      iex> list_characters()
      [%Character{}, ...]

  """
  def list_characters do
    Repo.all(Character)
  end

  @doc """
  Returns a slim list of characters, containing only the id, the user and the name.
  """
  def list_characters_slim do
    Character
    |> from()
    |> where([c], c.step == 2)
    |> select([c], %Character{id: c.id, name: c.name, user_id: c.user_id})
    |> Repo.all()
  end

  @doc """
  Gets a list of NPCs
  """
  def list_npcs do
    Character
    |> from()
    |> where([c], c.npc)
    |> Repo.all()
  end

  @doc """
  Gets a single character.

  Raises `Ecto.NoResultsError` if the Character does not exist.

  ## Examples

      iex> get_character!(123)
      %Character{}

      iex> get_character!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character!(id), do: Repo.get!(Character, id)

  @doc """
  This function behaves as the one above, only that it will return nil if the character does not exist.
  """
  def get_character(id), do: Repo.get(Character, id)

  @doc """
  Gets a single character with a smaller set of information for the character resume.
  """
  @spec get_character_slim(id :: non_neg_integer()) :: Character.t() | nil
  def get_character_slim(id) do
    Character
    |> from()
    |> where([c], c.id == ^id)
    |> select([c], %Character{
      id: c.id,
      name: c.name,
      avatar: c.avatar,
      description: c.description,
      health: c.health,
      sanity: c.sanity,
      lost_health: c.lost_health,
      lost_sanity: c.lost_sanity
    })
    |> Repo.one()
  end

  @doc """
  Gets the character by name, if exists, otherwise returns nil.
  """
  @spec get_character_by_name(character_name :: String.t()) :: Character.t() | nil
  def get_character_by_name(character_name) do
    Character
    |> from()
    |> where([c], c.name == ^character_name)
    |> Repo.one()
  end

  @doc """
  Determines whether the character belongs to the user or not.
  """
  @spec character_belongs_to_user?(character_id :: integer(), user_id :: integer()) :: boolean()
  def character_belongs_to_user?(character_id, user_id) do
    Character
    |> from()
    |> where([c], c.user_id == ^user_id and c.id == ^character_id)
    |> Repo.exists?()
  end

  @doc """
  Returns the first character of a user.
  TODO - fix in issue #16, the admin user can have more than one character, but only NPCs.
  """
  @spec get_user_first_character(User.t()) :: Character.t() | nil
  def get_user_first_character(user)

  # If the user is an admin, it will have to select the character manually from the list of NPCs.
  def get_user_first_character(%{admin: true}), do: nil

  def get_user_first_character(%{id: user_id}) do
    Character
    |> from()
    |> where([c], c.user_id == ^user_id)
    |> Repo.one()
  end

  @doc """
  Creates a character.

  ## Examples

      iex> create_character(%{field: value})
      {:ok, %Character{}}

      iex> create_character(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character(%{"user_id" => user_id} = attrs) do
    create_character_internal(attrs, user_id)
  end

  def create_character(%{user_id: user_id} = attrs) do
    create_character_internal(attrs, user_id)
  end

  def create_character(_) do
    {:error, Ecto.Changeset.add_error(%Ecto.Changeset{}, :user_id, "is required")}
  end

  defp create_character_internal(attrs, user_id) do
    case user_has_character?(user_id) do
      false ->
        attrs = add_step_to_character_attrs(attrs, 1)

        %Character{}
        |> Character.name_avatar_changeset(attrs)
        |> Repo.insert()

      _ ->
        {:error, Ecto.Changeset.add_error(%Ecto.Changeset{}, :user_id, "already has a character")}
    end
  end

  defp user_has_character?(user_id) do
    Character
    |> from()
    |> where([c], c.user_id == ^user_id)
    |> Repo.exists?()
  end

  defp add_step_to_character_attrs(attrs, step) do
    case {Map.has_key?(attrs, :step), Map.has_key?(attrs, "step"), Map.keys(attrs)} do
      {false, true, _} ->
        attrs

      {true, false, _} ->
        attrs

      {_, _, [k | _]} when is_atom(k) ->
        Map.put(attrs, :step, step)

      _ ->
        Map.put(attrs, "step", step)
    end
  end

  @doc """
  Determines whether a user has already a completed character.
  """
  @spec user_has_complete_charater?(User.t()) :: boolean()
  def user_has_complete_charater?(user) do
    character = get_user_character?(user)
    character.step == 2
  end

  @doc """
  Creates an NPC.
  """
  @spec create_npc(params :: map(), skills :: list(Skill.t())) ::
          {:ok, Character.t()} | {:error, Changeset.t()}
  def create_npc(params, skills) do
    %{id: admin_user_id} = Accounts.get_admin_user()

    params =
      params
      |> Map.put("npc", true)
      |> Map.put("user_id", admin_user_id)

    character_changeset =
      %Character{}
      |> Character.npc_changeset(params)

    character =
      character_changeset
      |> Repo.insert()

    with {:ok, %Character{id: character_id}} <- character,
         {:ok, _} <- create_character_skills_internal(skills, character_id) do
      {:ok, character}
    end
  end

  @doc """
  Updates a character.

  ## Examples

      iex> update_character(character, %{field: new_value})
      {:ok, %Character{}}

      iex> update_character(character, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates the sheet characteristics of the character.
  """
  def update_character_sheet(%Character{} = character, attrs) do
    character
    |> Character.modify_character_notes_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a character.

  ## Examples

      iex> delete_character(character)
      {:ok, %Character{}}

      iex> delete_character(character)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  @doc """
  Returns the user's character if existent, nil otherwise.
  """
  @spec get_user_character?(User.t()) :: Character.t() | nil
  def get_user_character?(user) do
    Character
    |> from()
    |> where([c], c.user_id == ^user.id)
    |> Repo.one()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character changes.

  ## Examples

      iex> change_character(character)
      %Ecto.Changeset{data: %Character{}}

  """
  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking the name and the avatar.

  ## Examples

      iex> change_character_name_and_avatar(character)
      %Ecto.Changeset{data: %Character{}}

  """
  def change_character_name_and_avatar(%Character{} = character, attrs \\ %{}) do
    Character.name_avatar_changeset(character, attrs)
  end

  @doc """
  Returns a changeset that will allow the user to modify the characteristics of their own character.
  """
  def change_character_notes(%Character{} = character, attrs \\ %{}) do
    Character.modify_character_notes_changeset(character, attrs)
  end

  @doc """
  Returns a changeset that allow the user to modify the cigs of the character.
  """
  def change_cigs(%Character{} = character, attrs \\ %{}) do
    Character.change_cigs_changeset(character, attrs)
  end

  @doc """
  Updates the step of the character to 2, thus completing it.
  """
  def complete_character(character) do
    {health, sanity} = compute_health_and_sanity(character)

    attrs =
      %{}
      |> add_step_to_character_attrs(2)
      |> Map.put("health", health)
      |> Map.put("sanity", sanity)
      |> Map.put("cigs", @default_character_initial_cigs)
      |> Map.put("experience", @default_character_initial_experience)

    character
    |> Character.complete_character_changeset(attrs)
    |> Repo.update()
  end

  @spec compute_health_and_sanity(character :: Character.t()) ::
          {non_neg_integer(), non_neg_integer()}
  defp compute_health_and_sanity(character) do
    {physique, mind, will} = {
      get_character_skill_value_by_skill_name(character, @physique_skill_name),
      get_character_skill_value_by_skill_name(character, @mind_skill_name),
      get_character_skill_value_by_skill_name(character, @will_skill_name)
    }

    health = physique * 8 + div(will, 2) * 4
    sanity = (mind + will) * 5

    {health, sanity}
  end

  @doc """
  Perform the resting of the character.
  This operation restores some of the characters characteristics, and sets the new timer.
  It can be performed only once every 24 hours.
  """
  @spec rest_character(character :: Character.t()) ::
          {:ok, Character.t()} | {:error, String.t()} | {:error, Changeset.t()}
  def rest_character(character)

  def rest_character(%{cigs: cigs}) when cigs < @rest_cost,
    do: {:error, "Non hai abbastanza sigarette per poter pagare l'albergo."}

  def rest_character(character) do
    limit =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(@rest_limit_hours * -1, :hour)

    case character.rest_timer do
      nil ->
        apply_rest_effect(character)

      rest_timer ->
        if NaiveDateTime.compare(rest_timer, limit) == :lt do
          apply_rest_effect(character)
        else
          {:error, "Non puoi ancora far riposare il personaggio."}
        end
    end
  end

  defp apply_rest_effect(%{cigs: cigs} = _character) when cigs < @rest_cost,
    do: {:error, "Non hai abbastanza sigarette per poter pagare l'albergo."}

  defp apply_rest_effect(%{lost_sanity: lost_sanity, cigs: cigs} = character) do
    attrs = %{
      lost_sanity: max(lost_sanity - @rest_sanity_recovery, 0),
      rest_timer: NaiveDateTime.utc_now(),
      cigs: cigs - @rest_cost
    }

    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  alias Stygian.Characters.CharacterSkill

  @doc """
  Returns the list of character_skills.

  ## Examples

      iex> list_character_skills()
      [%CharacterSkill{}, ...]

  """
  def list_character_skills(character) do
    CharacterSkill
    |> from()
    |> where([cs], cs.character_id == ^character.id)
    |> preload(skill: [:skill_types])
    |> Repo.all()
  end

  @doc """
  Returns the list of character skills, split between attributes and skills.
  """
  @spec list_character_attributes_skills(character :: Character.t()) ::
          {attributes :: list(CharacterSkill.t()), skills :: list(CharacterSkill.t())}
  def list_character_attributes_skills(character) do
    case list_character_skills(character) do
      nil ->
        {[], []}

      skills ->
        Enum.split_with(skills, fn s ->
          Enum.any?(s.skill.skill_types, &(&1.name == "Attribute"))
        end)
    end
  end

  @doc """
  Gets a single character_skill.

  Raises `Ecto.NoResultsError` if the Character skill does not exist.

  ## Examples

      iex> get_character_skill!(123)
      %CharacterSkill{}

      iex> get_character_skill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character_skill!(id), do: Repo.get!(CharacterSkill, id)

  @doc """
  Returns the character skill if existent, null otherwise.
  """
  @spec get_character_skill(character_id :: non_neg_integer(), skill_id :: non_neg_integer()) ::
          CharacterSkill.t() | nil
  def get_character_skill(character_id, skill_id) do
    CharacterSkill
    |> from()
    |> where([cs], cs.character_id == ^character_id and cs.skill_id == ^skill_id)
    |> Repo.one()
  end

  @doc """
  Gets a character skill and its value based on the skill name.
  This function is needed at creation, for instance, to compute the automatic character values.
  """
  @spec get_character_skill_by_skill_name(Character.t(), String.t()) :: CharacterSkill.t() | nil
  def get_character_skill_by_skill_name(%{id: character_id}, skill_name) do
    CharacterSkill
    |> from()
    |> join(:inner, [cs], s in Skill, on: cs.skill_id == s.id and s.name == ^skill_name)
    |> where([cs], cs.character_id == ^character_id)
    |> preload(:skill)
    |> Repo.one()
  end

  defp get_character_skill_value_by_skill_name(character, skill_name) do
    case get_character_skill_by_skill_name(character, skill_name) do
      %CharacterSkill{value: value} ->
        value

      nil ->
        0
    end
  end

  @doc """
  Returns the character skill value, modified by the existing effects on the character.
  """
  def get_character_skill_effect_value(character_id, skill_id) do
    %{value: value} =
      get_character_skill(character_id, skill_id)

    list_active_character_skill_effects(character_id)
    |> Enum.filter(&(&1.skill_id == skill_id))
    |> Enum.reduce(value, fn %{value: value}, acc -> acc + value end)
  end

  @doc """
  Creates a character_skill.

  ## Examples

      iex> create_character_skill(%{field: value})
      {:ok, %CharacterSkill{}}

      iex> create_character_skill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character_skill(attrs \\ %{}) do
    %CharacterSkill{}
    |> CharacterSkill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a character_skill.

  ## Examples

      iex> update_character_skill(character_skill, %{field: new_value})
      {:ok, %CharacterSkill{}}

      iex> update_character_skill(character_skill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character_skill(%CharacterSkill{} = character_skill, attrs) do
    character_skill
    |> CharacterSkill.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a character skill from the character form data to change the skill,
  the CharacterSkillForm struct.
  """
  @spec update_character_skill_form(attrs :: map()) ::
          {:ok, CharacterSkill.t()} | {:error, String.t()} | {:error, Changeset.t()}
  def update_character_skill_form(%{"new_value" => new_value} = attrs) do
    with %{valid?: true, changes: %{character_id: character_id, skill_id: skill_id}} <-
           CharacterSkillForm.changeset(%CharacterSkillForm{}, attrs),
         character_skill <- get_character_skill(character_id, skill_id),
         attrs <- Map.put(attrs, "value", new_value) do
      update_character_skill(character_skill, attrs)
    else
      _ ->
        {:error, "Errore nell'aggiornamento della skill."}
    end
  end

  @doc """
  Updates the character skills during creation, performing the necessary checks.
  The checks are the following:
  - The total sum of attributes must be 33.
  - The minimum value for an attribute must be 3.
  - The maximum value for an attribute must be 8.
  - The total sum of skills must be 5.
  - The minimum value for a skill must be 0.
  - The maximum value for a skill must be 5.

  The character id must already be contained in the `CharacterSkill` type.
  """
  @spec create_character_skills(
          list(CharacterSkill.t()),
          list(CharacterSkill.t()),
          character :: Character.t()
        ) ::
          {:ok, any()} | {:error, Changeset.t()}
  def create_character_skills(character_attributes, character_skills, character) do
    [%{character_id: character_id} | _] = character_attributes

    case check_creation_skills(character_attributes, character_skills, character) do
      changeset = {:error, _} ->
        changeset

      {:ok, {attributes, skills}} ->
        Enum.concat(attributes, skills)
        |> create_character_skills_internal(character_id)
    end
  end

  @doc """
  Creates a character relationship with its skills.
  The method is public only to help with the character seeds creation.
  """
  @spec create_character_skills_internal(
          skills :: list(CharacterSkill.t()),
          character_id :: non_neg_integer()
        ) ::
          {:ok, any()} | {:error, any()} | any()
  def create_character_skills_internal(skills, character_id) do
    skills
    |> Enum.map(&Map.put(&1, :character_id, character_id))
    |> Enum.reduce(
      Ecto.Multi.new()
      |> Ecto.Multi.delete_all(
        :delete_all,
        from(c in CharacterSkill, where: c.character_id == ^character_id)
      ),
      fn %{skill_id: skill_id, character_id: character_id, value: value}, multi ->
        multi
        |> Ecto.Multi.insert(
          skill_id,
          CharacterSkill.changeset(%CharacterSkill{}, %{
            character_id: character_id,
            skill_id: skill_id,
            value: value
          })
        )
      end
    )
    |> Repo.transaction()
  end

  @spec check_creation_skills(
          attributes :: list(CharacterSkill.t()),
          skills :: list(CharacterSkill.t()),
          character :: Character.t()
        ) ::
          {:ok, {list(CharacterSkill.t()), list(CharacterSkill.t())}} | {:error, Changeset.t()}
  defp check_creation_skills(attributes, skills, character) do
    check_creation_skills_count({:ok, {attributes, skills}})
    |> check_creation_skills_sum(character)
    |> check_creation_skills_level(character)
  end

  defp check_creation_skills_count({:ok, {attributes, _}}) when length(attributes) != 6 do
    {:error,
     Changeset.add_error(%Changeset{}, :character_attributes, "wrong number of attributes")}
  end

  defp check_creation_skills_count(previous_result), do: previous_result

  defp check_creation_skills_sum({:error, _} = error, _), do: error

  defp check_creation_skills_sum({:ok, {attributes, skills}}, character) do
    creation_max_attribute_sum = get_creation_max_attribute_points(character)
    creation_max_skill_sum = get_creation_max_skill_points(character)

    case {
      attributes
      |> Enum.map(& &1.value)
      |> Enum.sum(),
      skills
      |> Enum.map(& &1.value)
      |> Enum.sum()
    } do
      {^creation_max_attribute_sum, ^creation_max_skill_sum} ->
        {:ok, {attributes, skills}}

      {a, _} when a != creation_max_attribute_sum ->
        {:error,
         Changeset.add_error(%Changeset{}, :character_attributes, "wrong number of attributes")}

      {_, b} when b != creation_max_skill_sum ->
        {:error,
         Changeset.add_error(%Changeset{}, :character_attributes, "wrong number of attributes")}
    end
  end

  defp check_creation_skills_level({:error, _} = error, _), do: error

  defp check_creation_skills_level({:ok, {attributes, skills}}, character) do
    creation_min_attribute = get_creation_min_attribute_value()
    creation_max_attribute = get_creation_max_attribute_value()
    creation_min_skill = get_creation_min_skill_value()
    creation_max_skill = get_creation_max_skill_value(character)

    {attribute_values, skill_values} = {
      attributes
      |> Enum.map(& &1.value),
      skills
      |> Enum.map(& &1.value)
    }

    case {
      attribute_values
      |> Enum.min(),
      attribute_values
      |> Enum.max(),
      skill_values
      |> Enum.min(),
      skill_values
      |> Enum.max()
    } do
      {a_min, _, _, _} when a_min < creation_min_attribute ->
        {:error,
         Changeset.add_error(%Changeset{}, :character_attributes, "wrong level for attributes")}

      {_, a_max, _, _} when a_max > creation_max_attribute ->
        {:error,
         Changeset.add_error(%Changeset{}, :character_attributes, "wrong level for attributes")}

      {_, _, s_min, _} when s_min < creation_min_skill ->
        {:error, Changeset.add_error(%Changeset{}, :character_skills, "wrong level for skills")}

      {_, _, _, s_max} when s_max > creation_max_skill ->
        {:error, Changeset.add_error(%Changeset{}, :character_skills, "wrong level for skills")}

      _ ->
        {:ok, {attributes, skills}}
    end
  end

  @doc """
  Deletes a character_skill.

  ## Examples

      iex> delete_character_skill(character_skill)
      {:ok, %CharacterSkill{}}

      iex> delete_character_skill(character_skill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character_skill(%CharacterSkill{} = character_skill) do
    Repo.delete(character_skill)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character_skill changes.

  ## Examples

      iex> change_character_skill(character_skill)
      %Ecto.Changeset{data: %CharacterSkill{}}

  """
  def change_character_skill(%CharacterSkill{} = character_skill, attrs \\ %{}) do
    CharacterSkill.changeset(character_skill, attrs)
  end

  @doc """
  Assigns experience points to a character.
  """
  @spec assign_experience_points(character_id :: non_neg_integer(), attrs :: map()) ::
          {:ok, Character.t()} | {:error, Changeset.t()}
  def assign_experience_points(character_id, %{"experience" => experience}) do
    experience = extract_number(experience)

    case get_character(character_id) do
      nil ->
        {:error, Changeset.add_error(%Changeset{}, :character_id, "Il personaggio non esiste.")}

      %{experience: current_experience} when current_experience + experience < 0 ->
        {:error,
         Changeset.add_error(
           %Changeset{},
           :experience,
           "Non è possibile ridurre l'esperienza ad un valore minore di 0."
         )}

      %{experience: current_experience} = character ->
        character
        |> Character.change_experience_changeset(%{
          "experience" => current_experience + experience
        })
        |> Repo.update()
    end
  end

  @spec assign_character_status(character_id :: non_neg_integer(), params :: map()) ::
          {:ok, Character.t()} | {:error, Changeset.t()}
  def assign_character_status(character_id, %{"health" => health, "sanity" => sanity}) do
    {health, sanity} = {extract_number(health), extract_number(sanity)}

    case get_character(character_id) do
      nil ->
        {:error, Changeset.add_error(%Changeset{}, :character_id, "Il personaggio non esiste.")}

      %{health: current_health} when current_health < health ->
        {:error,
         Changeset.add_error(
           %Changeset{},
           :health,
           "Il valore specificato è maggiore della salute del personaggio."
         )}

      %{sanity: current_sanity} when current_sanity < sanity ->
        {:error,
         Changeset.add_error(
           %Changeset{},
           :sanity,
           "Il valore specificato è maggiore della sanità del personaggio."
         )}

      %{health: current_health, sanity: current_sanity} = character ->
        {lost_health, lost_sanity} = {
          current_health - health,
          current_sanity - sanity
        }

        character
        |> Character.change_health_and_sanity_changeset(%{
          "lost_health" => lost_health,
          "lost_sanity" => lost_sanity
        })
        |> Repo.update()
    end
  end

  defp extract_number(exp) when is_binary(exp), do: String.to_integer(exp)
  defp extract_number(exp), do: exp

  alias Stygian.Characters.CharacterEffect

  @doc """
  Returns the list of character_effects.

  ## Examples

      iex> list_character_effects()
      [%CharacterEffect{}, ...]

  """
  def list_character_effects do
    Repo.all(CharacterEffect)
  end

  @doc """
  Lists all the active effects for all the characters. It will preload chracter and the effect information.
  """
  @spec list_active_character_effects() :: list({Character.t(), Effect.t()})
  def list_active_character_effects do
    limit = character_effect_active_limit()

    CharacterEffect
    |> from()
    |> where([ce], ce.inserted_at > ^limit)
    |> join(:inner, [ce], c in Character, on: ce.character_id == c.id)
    |> join(:inner, [ce], o in Object, on: ce.object_id == o.id)
    |> join(:inner, [_, _, o], e in Effect, on: o.id == e.object_id)
    |> join(:inner, [_, _, _, e], s in Skill, on: e.skill_id == s.id)
    |> select([ce, c, o, e, s], %{id: ce.id, character: c, object: o, effect: e, skill: s})
    |> Repo.all()
    |> Enum.map(fn %{effect: effect, skill: skill} = item ->
      Map.put(item, :effect, Map.put(effect, :skill, skill))
    end)
  end

  @doc """
  Returns the list of active character effects.
  """
  @spec list_active_character_effects(character_id :: non_neg_integer()) ::
          list(CharacterEffect.t())
  def list_active_character_effects(character_id) do
    list_active_character_effects_query(character_id)
    |> Repo.all()
  end

  @doc """
  Lists all the effects on the character given by the consumed objects.
  """
  def list_active_character_skill_effects(character_id) do
    list_active_character_effects_query(character_id)
    |> join(:inner, [ce], e in Effect, on: ce.object_id == e.object_id)
    |> select([_, e], e)
    |> Repo.all()
  end

  defp list_active_character_effects_query(character_id) do
    limit = character_effect_active_limit()

    CharacterEffect
    |> from()
    |> where([ce], ce.character_id == ^character_id and ce.inserted_at > ^limit)
  end

  defp character_effect_active_limit do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(-1 * @character_effect_time_in_hour, :hour)
  end

  @doc """
  Determines whether the character has the effect of the object or not.
  """
  @spec character_has_effect?(character_id :: non_neg_integer(), object_id :: non_neg_integer()) ::
          boolean()
  def character_has_effect?(character_id, object_id) do
    limit = character_effect_active_limit()

    CharacterEffect
    |> from()
    |> where(
      [ce],
      ce.character_id == ^character_id and ce.object_id == ^object_id and ce.inserted_at > ^limit
    )
    |> Repo.exists?()
  end

  @doc """
  Gets a single character_effect.

  Raises `Ecto.NoResultsError` if the Character effect does not exist.

  ## Examples

      iex> get_character_effect!(123)
      %CharacterEffect{}

      iex> get_character_effect!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character_effect!(id), do: Repo.get!(CharacterEffect, id)

  @doc """
  Creates a character_effect.

  ## Examples

      iex> create_character_effect(%{field: value})
      {:ok, %CharacterEffect{}}

      iex> create_character_effect(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character_effect(attrs \\ %{}) do
    %CharacterEffect{}
    |> CharacterEffect.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Use this function only in unit tests, as it changes the inserted_at field.
  """
  def create_character_effect_test(attrs \\ %{}) do
    %CharacterEffect{}
    |> CharacterEffect.changeset_test(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a character_effect.

  ## Examples

      iex> update_character_effect(character_effect, %{field: new_value})
      {:ok, %CharacterEffect{}}

      iex> update_character_effect(character_effect, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character_effect(%CharacterEffect{} = character_effect, attrs) do
    character_effect
    |> CharacterEffect.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a character_effect.

  ## Examples

      iex> delete_character_effect(character_effect)
      {:ok, %CharacterEffect{}}

      iex> delete_character_effect(character_effect)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character_effect(%CharacterEffect{} = character_effect) do
    Repo.delete(character_effect)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character_effect changes.

  ## Examples

      iex> change_character_effect(character_effect)
      %Ecto.Changeset{data: %CharacterEffect{}}

  """
  def change_character_effect(%CharacterEffect{} = character_effect, attrs \\ %{}) do
    CharacterEffect.changeset(character_effect, attrs)
  end

  @doc """
  Applies the usage request for an object owned by the charcter, and register its effect.
  If the object has no more usages, it won't be possible to furtherly use it.
  """
  @spec use_object(character_object_id :: non_neg_integer()) ::
          {:ok, %{character_object: CharacterObject.t()}} | {:error, String.t()} | {:error, any()}
  def use_object(character_object_id) do
    with {:ok, character_object} <- check_character_object(character_object_id),
         {:ok, character_object} <- check_character_effects(character_object),
         {:ok, character_object} <- check_character_status(character_object) do
      Ecto.Multi.new()
      |> update_usages(character_object)
      |> create_character_effect(character_object)
      |> update_character_status(character_object)
      |> Repo.transaction()
    end
  end

  defp check_character_object(character_object_id) do
    case Objects.get_character_object(character_object_id) do
      nil ->
        {:error, "Il personaggio non possiede l'oggetto selezionato."}

      %{usages: 0} ->
        {:error, "L'oggetto non ha più utilizzi disponibili."}

      character_object ->
        {:ok, character_object}
    end
  end

  defp check_character_effects(
         %{character_id: character_id, object_id: object_id} = character_effect
       ) do
    case character_has_effect?(character_id, object_id) do
      true ->
        {:error, "Il personaggio ha già l'effetto dell'oggetto selezionato."}

      false ->
        {:ok, character_effect}
    end
  end

  defp check_character_status(
         %{character_id: character_id, object: %{health: health, sanity: sanity}} =
           character_object
       ) do
    character = get_character(character_id)

    case {character, health, sanity} do
      {nil, _, _} ->
        {:ezrror, "Il personaggio non esiste."}

      {_, 0, 0} ->
        {:ok, character_object}

      {%{lost_health: lost_health, health: character_health}, health, _}
      when character_health - lost_health <= -1 * health ->
        {:error, "Il personaggio non può perdere più salute."}

      {%{lost_sanity: lost_sanity, sanity: character_sanity}, _, sanity}
      when character_sanity - lost_sanity <= -1 * sanity ->
        {:error, "Il personaggio non può perdere più sanità mentale."}

      _ ->
        {:ok, character_object}
    end
  end

  defp update_usages(transaction, %{usages: usages} = character_object) do
    changeset =
      character_object
      |> CharacterObject.changeset(%{usages: usages - 1})

    transaction
    |> Ecto.Multi.update(:character_object, changeset)
  end

  defp create_character_effect(transaction, %{character_id: character_id, object_id: object_id}) do
    character_effect =
      %CharacterEffect{}
      |> CharacterEffect.changeset(%{
        character_id: character_id,
        object_id: object_id
      })

    transaction
    |> Ecto.Multi.insert(:character_effect, character_effect)
  end

  defp update_character_status(transaction, %{
         character_id: character_id,
         object: %{health: health, sanity: sanity}
       }) do
    character = get_character!(character_id)

    case {character, health, sanity} do
      {%{lost_health: lost_health, lost_sanity: lost_sanity}, health, sanity} ->
        status_changeset =
          character
          |> Character.change_health_and_sanity_changeset(%{
            "lost_health" => max(lost_health - health, 0),
            "lost_sanity" => max(lost_sanity - sanity, 0)
          })

        transaction
        |> Ecto.Multi.update(:character, status_changeset)
    end
  end

  @doc """
  Applies the effect of a character smoking a cig.
  """
  @spec smoke_cig(character_id :: non_neg_integer()) ::
          {:ok, Character.t()} | {:error, String.t()} | {:error, any()}
  def smoke_cig(character_id) do
    with {:ok, character} <- check_character(character_id),
         {:ok, character} <- check_character_cigs(character) do
      Ecto.Multi.new()
      |> update_character_cigs(character)
      |> update_character_cig_status(character)
      |> Repo.transaction()
    end
  end

  defp check_character(character_id) do
    case get_character(character_id) do
      nil ->
        {:error, "Il personaggio non esiste."}

      character ->
        {:ok, character}
    end
  end

  defp check_character_cigs(%{cigs: cigs} = character) do
    case cigs do
      0 ->
        {:error, "Il personaggio non ha più sigarette."}

      _ ->
        {:ok, character}
    end
  end

  defp update_character_cigs(transaction, %{cigs: cigs} = character) do
    changeset =
      character
      |> Character.change_cigs_changeset(%{cigs: cigs - 1})

    transaction
    |> Ecto.Multi.update(:character_cig, changeset)
  end

  defp update_character_cig_status(
         transaction,
         %{last_cigs_effect: last_cigs_effect, lost_sanity: lost_sanity} = character
       ) do
    limit =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(@character_effect_time_in_hour * -1, :hour)

    if is_nil(last_cigs_effect) || NaiveDateTime.compare(last_cigs_effect, limit) == :lt do
      lost_sanity = max(lost_sanity - @character_sanity_from_cig, 0)

      changeset =
        character
        |> Character.change_health_and_sanity_changeset(%{
          lost_sanity: lost_sanity,
          last_cigs_effect: NaiveDateTime.utc_now()
        })

      transaction
      |> Ecto.Multi.update(:character_status, changeset)
    else
      transaction
    end
  end
end
