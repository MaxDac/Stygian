defmodule Stygian.WeaponsTest do
  use Stygian.DataCase

  alias Stygian.Weapons

  describe "weapons" do
    alias Stygian.Weapons.Weapon

    import Stygian.WeaponsFixtures

    @invalid_attrs %{name: nil, description: nil, image_url: nil, required_skill_min_value: nil, damage_bonus: nil, cost: nil}

    test "list_weapons/0 returns all weapons" do
      weapon = weapon_fixture()
      assert Weapons.list_weapons() == [weapon]
    end

    test "get_weapon!/1 returns the weapon with given id" do
      weapon = weapon_fixture()
      assert Weapons.get_weapon!(weapon.id) == weapon
    end

    test "create_weapon/1 with valid data creates a weapon" do
      valid_attrs = %{name: "some name", description: "some description", image_url: "some image_url", required_skill_min_value: 42, damage_bonus: 42, cost: 42}

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
      update_attrs = %{name: "some updated name", description: "some updated description", image_url: "some updated image_url", required_skill_min_value: 43, damage_bonus: 43, cost: 43}

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
end
