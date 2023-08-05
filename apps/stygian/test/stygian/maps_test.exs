defmodule Stygian.MapsTest do
  use Stygian.DataCase

  alias Stygian.Maps

  describe "maps" do
    alias Stygian.Maps.Map

    import Stygian.MapsFixtures

    @invalid_attrs %{description: nil, image_name: nil, name: nil}

    test "list_maps/0 returns all maps" do
      map = map_fixture()
      assert Maps.list_maps() == [map]
    end

    test "get_map!/1 returns the map with given id" do
      map = map_fixture()
      assert Maps.get_map!(map.id) == map
    end

    test "get_map/1 returns the map with given id" do
      map = map_fixture()
      assert Maps.get_map(map.id) == map
    end

    test "get_map/1 returns nil if the map does not exist" do
      assert Maps.get_map(1) == nil
    end

    test "get_map_by_name/1 returns the map with given name" do
      map = map_fixture()
      assert Maps.get_map_by_name(map.name) == map
    end

    test "get_map_by_name/1 returns nil when the map does not exist" do
      assert Maps.get_map_by_name("some name") == nil
    end

    test "create_map/1 with valid data creates a map" do
      valid_attrs = %{description: "some description", image_name: "some image_name", name: "some name"}

      assert {:ok, %Map{} = map} = Maps.create_map(valid_attrs)
      assert map.description == "some description"
      assert map.image_name == "some image_name"
      assert map.name == "some name"
    end

    test "create_map/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maps.create_map(@invalid_attrs)
    end

    test "update_map/2 with valid data updates the map" do
      map = map_fixture()
      update_attrs = %{description: "some updated description", image_name: "some updated image_name", name: "some updated name"}

      assert {:ok, %Map{} = map} = Maps.update_map(map, update_attrs)
      assert map.description == "some updated description"
      assert map.image_name == "some updated image_name"
      assert map.name == "some updated name"
    end

    test "update_map/2 with invalid data returns error changeset" do
      map = map_fixture()
      assert {:error, %Ecto.Changeset{}} = Maps.update_map(map, @invalid_attrs)
      assert map == Maps.get_map!(map.id)
    end

    test "delete_map/1 deletes the map" do
      map = map_fixture()
      assert {:ok, %Map{}} = Maps.delete_map(map)
      assert_raise Ecto.NoResultsError, fn -> Maps.get_map!(map.id) end
    end

    test "change_map/1 returns a map changeset" do
      map = map_fixture()
      assert %Ecto.Changeset{} = Maps.change_map(map)
    end

    test "list_parent_maps/0 returns all parent maps" do
      map = map_fixture()
      child_map = map_fixture(%{name: "Child", parent_id: map.id})
      assert Maps.list_parent_maps() == [map]
    end

    test "list_child_maps/1 returns all the child maps from a given parent" do
      map = map_fixture()
      child_map_1 = map_fixture(%{name: "Child 1", parent_id: map.id})
      child_map_2 = map_fixture(%{name: "Child 2", parent_id: map.id})

      assert [child_map_1, child_map_2] == Maps.list_child_maps(map)
    end

    test "get_map_with_children/1 returns the map with the children" do
      %{id: parent_id} = map = map_fixture()
      child = map_fixture(%{name: "child", parent_id: parent_id})
      parent_map = Maps.get_map_with_children(parent_id)
      assert parent_id == parent_map.id
      assert [child] == parent_map.children
    end
  end
end
