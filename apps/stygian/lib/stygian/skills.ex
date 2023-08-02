defmodule Stygian.Skills do
  @moduledoc """
  The Skills context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Skills.Skill
  alias Stygian.Skills.SkillType
  alias Stygian.Skills.SkillRelSkillType

  @non_creational_skill_type_name "Non creational"

  @doc """
  Returns the list of skill_types.

  ## Examples

      iex> list_skill_types()
      [%SkillType{}, ...]

  """
  def list_skill_types do
    Repo.all(SkillType)
  end

  @doc """
  Gets a single skill_type.

  Raises `Ecto.NoResultsError` if the Skill type does not exist.

  ## Examples

      iex> get_skill_type!(123)
      %SkillType{}

      iex> get_skill_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_skill_type!(id), do: Repo.get!(SkillType, id)

  def get_skill_type_by_name(name), do: Repo.get_by(SkillType, name: name)

  @doc """
  Creates a skill_type.

  ## Examples

      iex> create_skill_type(%{field: value})
      {:ok, %SkillType{}}

      iex> create_skill_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_skill_type(attrs \\ %{}) do
    %SkillType{}
    |> SkillType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a skill_type.

  ## Examples

      iex> update_skill_type(skill_type, %{field: new_value})
      {:ok, %SkillType{}}

      iex> update_skill_type(skill_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_skill_type(%SkillType{} = skill_type, attrs) do
    skill_type
    |> SkillType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a skill_type.

  ## Examples

      iex> delete_skill_type(skill_type)
      {:ok, %SkillType{}}

      iex> delete_skill_type(skill_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_skill_type(%SkillType{} = skill_type) do
    Repo.delete(skill_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking skill_type changes.

  ## Examples

      iex> change_skill_type(skill_type)
      %Ecto.Changeset{data: %SkillType{}}

  """
  def change_skill_type(%SkillType{} = skill_type, attrs \\ %{}) do
    SkillType.changeset(skill_type, attrs)
  end

  @doc """
  Returns the list of skills.

  ## Examples

      iex> list_skills()
      [%Skill{}, ...]

  """
  def list_skills do
    Repo.all(Skill)
  end

  @doc """
  Gets a single skill.

  Raises `Ecto.NoResultsError` if the Skill does not exist.

  ## Examples

      iex> get_skill!(123)
      %Skill{}

      iex> get_skill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_skill!(id), do: Repo.get!(Skill, id)

  @doc """
  Gets a single skill by name.
  """
  def get_skill_by_name(name), do: Repo.get_by(Skill, name: name)

  @doc """
  Gets all the skills available on creation.
  """
  @spec list_creational_skills() :: [Skill.t()]
  def list_creational_skills() do
    Skill
    |> distinct(true)
    |> from()
    |> join(:left, [s], sr in SkillRelSkillType, on: s.id == sr.skill_id)
    |> join(:left, [_, sr], st in SkillType,
      on: sr.skill_type_id == st.id and st.name != @non_creational_skill_type_name
    )
    |> order_by([s, _, _], asc: s.id)
    |> select([s], s)
    |> preload(:skill_types)
    |> Repo.all()
  end

  @doc """
  Creates a skill.

  ## Examples

      iex> create_skill(%{field: value})
      {:ok, %Skill{}}

      iex> create_skill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_skill(attrs \\ %{}) do
    %Skill{}
    |> Skill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Adds a skill_type to a skill.
  """
  def add_skill_type_to_skill(%{id: skill_id}, %{id: skill_type_id}) do
    %SkillRelSkillType{}
    |> SkillRelSkillType.changeset(%{skill_id: skill_id, skill_type_id: skill_type_id})
    |> Repo.insert()
  end

  @doc """
  Determines whether a skill already has the given skill_type.
  """
  def skill_has_type?(skill, skill_type) do
    SkillRelSkillType
    |> from()
    |> where([s], s.skill_id == ^skill.id and s.skill_type_id == ^skill_type.id)
    |> Repo.exists?()
  end

  @doc """
  Updates a skill.

  ## Examples

      iex> update_skill(skill, %{field: new_value})
      {:ok, %Skill{}}

      iex> update_skill(skill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_skill(%Skill{} = skill, attrs) do
    skill
    |> Skill.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a skill.

  ## Examples

      iex> delete_skill(skill)
      {:ok, %Skill{}}

      iex> delete_skill(skill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_skill(%Skill{} = skill) do
    Repo.delete(skill)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking skill changes.

  ## Examples

      iex> change_skill(skill)
      %Ecto.Changeset{data: %Skill{}}

  """
  def change_skill(%Skill{} = skill, attrs \\ %{}) do
    Skill.changeset(skill, attrs)
  end
end
