defmodule Stygian.OrganisationsTest do
  use Stygian.DataCase

  alias Stygian.Organisations

  describe "organisations" do
    alias Stygian.Organisations.Organisation

    import Stygian.OrganisationsFixtures

    @invalid_attrs %{name: nil, description: nil, image: nil, base_salary: nil}

    test "list_organisations/0 returns all organisations" do
      organisation = organisation_fixture()
      assert Organisations.list_organisations() == [organisation]
    end

    test "get_organisation!/1 returns the organisation with given id" do
      organisation = organisation_fixture()
      assert Organisations.get_organisation!(organisation.id) == organisation
    end

    test "create_organisation/1 with valid data creates a organisation" do
      valid_attrs = %{name: "some name", description: "some description", image: "some image", base_salary: 42}

      assert {:ok, %Organisation{} = organisation} = Organisations.create_organisation(valid_attrs)
      assert organisation.name == "some name"
      assert organisation.description == "some description"
      assert organisation.image == "some image"
      assert organisation.base_salary == 42
    end

    test "create_organisation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organisations.create_organisation(@invalid_attrs)
    end

    test "update_organisation/2 with valid data updates the organisation" do
      organisation = organisation_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", image: "some updated image", base_salary: 43}

      assert {:ok, %Organisation{} = organisation} = Organisations.update_organisation(organisation, update_attrs)
      assert organisation.name == "some updated name"
      assert organisation.description == "some updated description"
      assert organisation.image == "some updated image"
      assert organisation.base_salary == 43
    end

    test "update_organisation/2 with invalid data returns error changeset" do
      organisation = organisation_fixture()
      assert {:error, %Ecto.Changeset{}} = Organisations.update_organisation(organisation, @invalid_attrs)
      assert organisation == Organisations.get_organisation!(organisation.id)
    end

    test "delete_organisation/1 deletes the organisation" do
      organisation = organisation_fixture()
      assert {:ok, %Organisation{}} = Organisations.delete_organisation(organisation)
      assert_raise Ecto.NoResultsError, fn -> Organisations.get_organisation!(organisation.id) end
    end

    test "change_organisation/1 returns a organisation changeset" do
      organisation = organisation_fixture()
      assert %Ecto.Changeset{} = Organisations.change_organisation(organisation)
    end
  end
end
