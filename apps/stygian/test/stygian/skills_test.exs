defmodule Stygian.SkillsTest do
  use Stygian.DataCase

  alias Stygian.Skills

  describe "skill_types" do
    alias Stygian.Skills.SkillType

    import Stygian.SkillsFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_skill_types/0 returns all skill_types" do
      skill_type = skill_type_fixture()
      assert Skills.list_skill_types() == [skill_type]
    end

    test "get_skill_type!/1 returns the skill_type with given id" do
      skill_type = skill_type_fixture()
      assert Skills.get_skill_type!(skill_type.id) == skill_type
    end

    test "create_skill_type/1 with valid data creates a skill_type" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %SkillType{} = skill_type} = Skills.create_skill_type(valid_attrs)
      assert skill_type.description == "some description"
      assert skill_type.name == "some name"
    end

    test "create_skill_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Skills.create_skill_type(@invalid_attrs)
    end

    test "update_skill_type/2 with valid data updates the skill_type" do
      skill_type = skill_type_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %SkillType{} = skill_type} = Skills.update_skill_type(skill_type, update_attrs)
      assert skill_type.description == "some updated description"
      assert skill_type.name == "some updated name"
    end

    test "update_skill_type/2 with invalid data returns error changeset" do
      skill_type = skill_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Skills.update_skill_type(skill_type, @invalid_attrs)
      assert skill_type == Skills.get_skill_type!(skill_type.id)
    end

    test "delete_skill_type/1 deletes the skill_type" do
      skill_type = skill_type_fixture()
      assert {:ok, %SkillType{}} = Skills.delete_skill_type(skill_type)
      assert_raise Ecto.NoResultsError, fn -> Skills.get_skill_type!(skill_type.id) end
    end

    test "change_skill_type/1 returns a skill_type changeset" do
      skill_type = skill_type_fixture()
      assert %Ecto.Changeset{} = Skills.change_skill_type(skill_type)
    end
  end

  describe "skills" do
    alias Stygian.Skills.Skill

    import Stygian.SkillsFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_skills/0 returns all skills" do
      skill = skill_fixture()
      assert Skills.list_skills() == [skill]
    end

    test "list_skills/0 returns the correct number of skills with different types associated" do
      attribute_skill_type = skill_type_fixture(%{name: "Attribute"})
      non_attribute_skill_type = skill_type_fixture(%{name: "Not Attribute"})

      skill_1 = skill_fixture(%{name: "Skill 1"})
      skill_2 = skill_fixture(%{name: "Skill 2"})
      skill_3 = skill_fixture(%{name: "Skill 3"})

      Skills.add_skill_type_to_skill(skill_1, attribute_skill_type)
      Skills.add_skill_type_to_skill(skill_2, non_attribute_skill_type)
      Skills.add_skill_type_to_skill(skill_3, attribute_skill_type)
      Skills.add_skill_type_to_skill(skill_3, non_attribute_skill_type)

      skills = Skills.list_skills()

      assert length(skills) == 3
    end

    test "list_preloaded_skills/0 returns all skills" do
      skill = skill_fixture()

      assert [found_skill] = Skills.list_preloaded_skills()

      assert found_skill.name == skill.name
      assert found_skill.description == skill.description
      refute found_skill.is_attribute
      assert [] == found_skill.skill_types
    end

    test "list_preloaded_skills/0 returns all skills with the correct `is_attribute` flag" do
      attribute_skill_type = skill_type_fixture(%{name: "Attribute"})
      non_attribute_skill_type = skill_type_fixture(%{name: "Not Attribute"})

      skill_1 = skill_fixture(%{name: "Skill 1"})
      skill_2 = skill_fixture(%{name: "Skill 2"})
      skill_3 = skill_fixture(%{name: "Skill 3"})

      Skills.add_skill_type_to_skill(skill_1, attribute_skill_type)
      Skills.add_skill_type_to_skill(skill_2, non_attribute_skill_type)
      Skills.add_skill_type_to_skill(skill_3, attribute_skill_type)
      Skills.add_skill_type_to_skill(skill_3, non_attribute_skill_type)

      skills = Skills.list_preloaded_skills()

      assert length(skills) == 3
      assert length(Enum.filter(skills, &(&1.is_attribute))) == 2
    end

    test "add_is_attribute/1 correctly adds the is_attribute flag to false when the type is not attribute" do
      skill_type = skill_type_fixture(%{name: "Not Attribute"})
      %{id: skill_id} = skill = skill_fixture()

      assert {:ok, _} = Skills.add_skill_type_to_skill(skill, skill_type)

      # Recovering skill with preloaded skill_types
      skill = 
        Skills.get_preloaded_skill!(skill_id)

      skill = Skill.add_is_attribute(skill)
      refute skill.is_attribute
    end

    test "add_is_attribute/1 correctly adds the is_attribute flag to false when no type is present" do
      %{id: skill_id} = skill_fixture()

      # Recovering skill with preloaded skill_types
      skill = 
        Skills.get_preloaded_skill!(skill_id)

      skill = Skill.add_is_attribute(skill)
      refute skill.is_attribute
    end

    test "add_is_attribute/1 correctly adds the is_attribute flag to true" do
      skill_type = skill_type_fixture(%{name: "Attribute"})
      %{id: skill_id} = skill = skill_fixture()

      assert {:ok, _} = Skills.add_skill_type_to_skill(skill, skill_type)

      # Recovering skill with preloaded skill_types
      skill = 
        Skills.get_preloaded_skill!(skill_id)

      skill = Skill.add_is_attribute(skill)
      assert skill.is_attribute
    end

    test "get_skill!/1 returns the skill with given id" do
      skill = skill_fixture()
      assert Skills.get_skill!(skill.id) == skill
    end

    test "get_preloaded_skill!/1 returns the skill with given id with the skill types preloaded" do
      skill_type = skill_type_fixture()
      skill = skill_fixture()

      assert {:ok, _} = Skills.add_skill_type_to_skill(skill, skill_type)

      found_skill = Skills.get_preloaded_skill!(skill.id)
      assert found_skill.name == skill.name
      assert [found_skill_type] = found_skill.skill_types
      assert found_skill_type.name == skill_type.name
    end

    test "create_skill/1 with valid data creates a skill" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Skill{} = skill} = Skills.create_skill(valid_attrs)
      assert skill.description == "some description"
      assert skill.name == "some name"
    end

    test "create_skill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Skills.create_skill(@invalid_attrs)
    end

    test "update_skill/2 with valid data updates the skill" do
      skill = skill_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Skill{} = skill} = Skills.update_skill(skill, update_attrs)
      assert skill.description == "some updated description"
      assert skill.name == "some updated name"
    end

    test "update_skill/2 with invalid data returns error changeset" do
      skill = skill_fixture()
      assert {:error, %Ecto.Changeset{}} = Skills.update_skill(skill, @invalid_attrs)
      assert skill == Skills.get_skill!(skill.id)
    end

    test "delete_skill/1 deletes the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{}} = Skills.delete_skill(skill)
      assert_raise Ecto.NoResultsError, fn -> Skills.get_skill!(skill.id) end
    end

    test "change_skill/1 returns a skill changeset" do
      skill = skill_fixture()
      assert %Ecto.Changeset{} = Skills.change_skill(skill)
    end

    test "get_skill_by_name/1 returns the skill with given name" do
      skill = skill_fixture()
      assert Skills.get_skill_by_name(skill.name) == skill
    end

    test "get_skill_by_name/1 returns nil if the name is not found" do
      assert Skills.get_skill_by_name("some name") == nil
    end

    test "add_skill_type_to_skill/2 adds the skill_type to the skill" do
      skill = skill_fixture()
      skill_type = skill_type_fixture()
      assert {:ok, _} = Skills.add_skill_type_to_skill(skill, skill_type)
      assert Skills.skill_has_type?(skill, skill_type)
    end

    test "skill_has_type/2 returns true if the skill has the skill_type" do
      skill = skill_fixture()
      skill_type = skill_type_fixture()
      assert {:ok, _} = Skills.add_skill_type_to_skill(skill, skill_type)
      assert Skills.skill_has_type?(skill, skill_type)
    end

    test "skill_has_type/2 returns false if the skill does not have the skill_type" do
      skill = skill_fixture()
      skill_type = skill_type_fixture()
      assert !Skills.skill_has_type?(skill, skill_type)
    end

    test "list_creational_skills/0 returns only creational skills" do
      skill_type = skill_type_fixture(%{name: "Creational"})
      non_creational_skill_type = skill_type_fixture(%{name: "Non creational"})
      skill = skill_fixture(%{name: "Creational skill"})
      non_creational_skill = skill_fixture(%{name: "Non creational skill"})

      Skills.add_skill_type_to_skill(skill, skill_type)
      Skills.add_skill_type_to_skill(non_creational_skill, non_creational_skill_type)

      assert [listed_skill] = Skills.list_creational_skills()
      assert skill.id == listed_skill.id
    end

    test "list_creational_skills/0 do not return duplicates" do
      skill_type = skill_type_fixture(%{name: "Creational"})
      other_skill_type = skill_type_fixture(%{name: "Whatever"})
      non_creational_skill_type = skill_type_fixture(%{name: "Non creational"})

      skill = skill_fixture(%{name: "Creational skill"})
      non_creational_skill = skill_fixture(%{name: "Non creational skill"})

      Skills.add_skill_type_to_skill(skill, skill_type)
      Skills.add_skill_type_to_skill(skill, other_skill_type)
      Skills.add_skill_type_to_skill(non_creational_skill, non_creational_skill_type)

      assert [listed_skill] = Skills.list_creational_skills()
      assert skill.id == listed_skill.id
    end
  end
end
