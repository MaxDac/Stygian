defmodule Stygian.WeaponsTest do
  use Stygian.DataCase

  alias Stygian.Weapons

  describe "weapon_types" do
    alias Stygian.Weapons.WeaponType

    import Stygian.WeaponsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_weapon_types/0 returns all weapon_types" do
      weapon_type = weapon_type_fixture()
      assert Weapons.list_weapon_types() == [weapon_type]
    end

    test "get_weapon_type!/1 returns the weapon_type with given id" do
      weapon_type = weapon_type_fixture()
      assert Weapons.get_weapon_type!(weapon_type.id) == weapon_type
    end

    test "create_weapon_type/1 with valid data creates a weapon_type" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %WeaponType{} = weapon_type} = Weapons.create_weapon_type(valid_attrs)
      assert weapon_type.name == "some name"
      assert weapon_type.description == "some description"
    end

    test "create_weapon_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Weapons.create_weapon_type(@invalid_attrs)
    end

    test "update_weapon_type/2 with valid data updates the weapon_type" do
      weapon_type = weapon_type_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %WeaponType{} = weapon_type} =
               Weapons.update_weapon_type(weapon_type, update_attrs)

      assert weapon_type.name == "some updated name"
      assert weapon_type.description == "some updated description"
    end

    test "update_weapon_type/2 with invalid data returns error changeset" do
      weapon_type = weapon_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Weapons.update_weapon_type(weapon_type, @invalid_attrs)
      assert weapon_type == Weapons.get_weapon_type!(weapon_type.id)
    end

    test "delete_weapon_type/1 deletes the weapon_type" do
      weapon_type = weapon_type_fixture()
      assert {:ok, %WeaponType{}} = Weapons.delete_weapon_type(weapon_type)
      assert_raise Ecto.NoResultsError, fn -> Weapons.get_weapon_type!(weapon_type.id) end
    end

    test "change_weapon_type/1 returns a weapon_type changeset" do
      weapon_type = weapon_type_fixture()
      assert %Ecto.Changeset{} = Weapons.change_weapon_type(weapon_type)
    end
  end

  describe "weapons" do
    alias Stygian.Weapons.Weapon

    import Stygian.SkillsFixtures
    import Stygian.WeaponsFixtures

    @invalid_attrs %{
      name: nil,
      description: nil,
      image_url: nil,
      required_skill_min_value: nil,
      damage_bonus: nil,
      cost: nil
    }

    test "list_weapons/0 returns all weapons" do
      weapon = weapon_fixture()
      assert Weapons.list_weapons() == [weapon]
    end

    test "get_weapon!/1 returns the weapon with given id" do
      weapon = weapon_fixture()
      assert Weapons.get_weapon!(weapon.id) == weapon
    end

    test "get_weapon/1 returns the weapon with given id" do
      weapon = weapon_fixture()
      assert Weapons.get_weapon(weapon.id) == weapon
    end

    test "get_weapon/1 returns nil if the weapon does not exist" do
      assert is_nil(Weapons.get_weapon(42))
    end

    test "get_weapon_by_name/1 returns the weapon with that name" do
      weapon = weapon_fixture()
      assert Weapons.get_weapon_by_name(weapon.name) == weapon
    end

    test "get_weapon_by_name/1 returns nil if no weapon with the name exists" do
      weapon = weapon_fixture()
      assert is_nil(Weapons.get_weapon_by_name("#{weapon.name}_another"))
    end

    test "create_weapon/1 with valid data creates a weapon" do
      %{id: skill_id} = skill_fixture()
      %{id: weapon_type_id} = weapon_type_fixture()

      valid_attrs = %{
        name: "some name",
        description: "some description",
        image_url: "some image_url",
        required_skill_min_value: 42,
        damage_bonus: 42,
        cost: 42,
        required_skill_id: skill_id,
        weapon_type_id: weapon_type_id
      }

      assert {:ok, %Weapon{} = weapon} = Weapons.create_weapon(valid_attrs)
      assert weapon.name == "some name"
      assert weapon.description == "some description"
      assert weapon.image_url == "some image_url"
      assert weapon.required_skill_min_value == 42
      assert weapon.damage_bonus == 42
      assert weapon.cost == 42
    end

    test "create_weapon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Weapons.create_weapon(@invalid_attrs)
    end

    test "update_weapon/2 with valid data updates the weapon" do
      weapon = weapon_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        image_url: "some updated image_url",
        required_skill_min_value: 43,
        damage_bonus: 43,
        cost: 43
      }

      assert {:ok, %Weapon{} = weapon} = Weapons.update_weapon(weapon, update_attrs)
      assert weapon.name == "some updated name"
      assert weapon.description == "some updated description"
      assert weapon.image_url == "some updated image_url"
      assert weapon.required_skill_min_value == 43
      assert weapon.damage_bonus == 43
      assert weapon.cost == 43
    end

    test "update_weapon/2 with invalid data returns error changeset" do
      weapon = weapon_fixture()
      assert {:error, %Ecto.Changeset{}} = Weapons.update_weapon(weapon, @invalid_attrs)
      assert weapon == Weapons.get_weapon!(weapon.id)
    end

    test "delete_weapon/1 deletes the weapon" do
      weapon = weapon_fixture()
      assert {:ok, %Weapon{}} = Weapons.delete_weapon(weapon)
      assert_raise Ecto.NoResultsError, fn -> Weapons.get_weapon!(weapon.id) end
    end

    test "change_weapon/1 returns a weapon changeset" do
      weapon = weapon_fixture()
      assert %Ecto.Changeset{} = Weapons.change_weapon(weapon)
    end
  end

  describe "Character weapons" do
    alias Stygian.Characters
    alias Stygian.Weapons

    import Stygian.CharactersFixtures
    import Stygian.SkillsFixtures
    import Stygian.WeaponsFixtures

    test "list_character_weapons/1 returns an empty list when the character has no weapons" do
      %{id: character_id} = character_fixture()

      assert [] = Weapons.list_character_weapons(character_id)
    end

    test "list_character_weapons/1 returns all the weapons associated to the character" do
      %{id: character_id} = character_fixture()
      %{id: weapon_id} = weapon_fixture()
      _ = character_weapon_fixture(%{character_id: character_id, weapon_id: weapon_id})

      assert [weapon] = Weapons.list_character_weapons(character_id)

      assert weapon_id == weapon.id
    end

    test "add_weapon_to_character/2 correctly adds an existing weapon to a character" do
      %{id: character_id} = character_fixture()
      %{id: weapon_id} = weapon_fixture()

      assert {:ok, %Stygian.Characters.Character{}} =
               Weapons.add_weapon_to_character(character_id, weapon_id)

      character = Characters.get_character!(character_id) |> Stygian.Repo.preload(:weapons)

      assert [weapon] = character.weapons
      assert weapon_id == weapon.id

      assert not is_nil(Weapons.get_weapon(weapon_id))
    end

    test "remove_weapon_from_character/2 correctly removes the weapon from a character" do
      %{id: character_id} = character_fixture()
      %{id: weapon_id} = weapon_fixture()

      Weapons.add_weapon_to_character(character_id, weapon_id)

      assert {:ok, %Stygian.Characters.Character{}} =
               Weapons.remove_weapon_from_character(character_id, weapon_id)

      character = Characters.get_character!(character_id) |> Stygian.Repo.preload(:weapons)

      assert [] = character.weapons

      assert not is_nil(Weapons.get_weapon(weapon_id))
    end

    test "remove_weapon_from_character/2 does not remove a weapon when the character does not own it" do
      %{id: character_id} = character_fixture()
      %{id: weapon_id} = weapon_fixture()

      assert {:error, "L'arma non appartiene al personaggio"} =
               Weapons.remove_weapon_from_character(character_id, weapon_id)
    end

    test "remove_weapon_from_character/2 correctly removes only the weapon selected to be removed" do
      %{id: character_id} = character_fixture()

      %{id: skill_id} = skill_fixture(%{name: "second skill"})

      %{id: weapon_id_1} = weapon_fixture()
      %{id: weapon_id_2} = weapon_fixture(%{name: "second weapon", required_skill_id: skill_id})

      Weapons.add_weapon_to_character(character_id, weapon_id_1)
      Weapons.add_weapon_to_character(character_id, weapon_id_2)

      assert {:ok, %Stygian.Characters.Character{}} =
               Weapons.remove_weapon_from_character(character_id, weapon_id_1)

      character = Characters.get_character!(character_id) |> Stygian.Repo.preload(:weapons)

      assert [weapon] = character.weapons
      assert weapon_id_2 == weapon.id

      assert not is_nil(Weapons.get_weapon(weapon_id_1))
      assert not is_nil(Weapons.get_weapon(weapon_id_2))
    end
  end
end
