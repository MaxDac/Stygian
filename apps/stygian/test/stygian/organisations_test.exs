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
      valid_attrs = %{
        name: "some name",
        description: "some description",
        image: "some image",
        base_salary: 42
      }

      assert {:ok, %Organisation{} = organisation} =
               Organisations.create_organisation(valid_attrs)

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

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        image: "some updated image",
        base_salary: 43
      }

      assert {:ok, %Organisation{} = organisation} =
               Organisations.update_organisation(organisation, update_attrs)

      assert organisation.name == "some updated name"
      assert organisation.description == "some updated description"
      assert organisation.image == "some updated image"
      assert organisation.base_salary == 43
    end

    test "update_organisation/2 with invalid data returns error changeset" do
      organisation = organisation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organisations.update_organisation(organisation, @invalid_attrs)

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

  describe "characters_rel_organisations" do
    alias Stygian.Organisations.CharctersOrganisations

    import Stygian.OrganisationsFixtures
    import Stygian.CharactersFixtures

    @invalid_attrs %{last_salary_withdraw: nil}

    test "list_characters_rel_organisations/0 returns all characters_rel_organisations" do
      charcters_organisations = charcters_organisations_fixture()
      assert Organisations.list_characters_rel_organisations() == [charcters_organisations]
    end

    test "get_charcters_organisations!/1 returns the charcters_organisations with given id" do
      charcters_organisations = charcters_organisations_fixture()

      assert Organisations.get_charcters_organisations!(charcters_organisations.id) ==
               charcters_organisations
    end

    test "get_character_organisation/2 returns the character job with the right organisation" do
      %{
        character_id: character_id,
        organisation_id: organisation_id,
        last_salary_withdraw: last_salary_withdraw
      } = charcters_organisations_fixture()

      characters_organisations = Organisations.get_character_organisation(character_id, organisation_id)

      assert characters_organisations.character_id == character_id
      assert characters_organisations.organisation_id == organisation_id
      assert characters_organisations.last_salary_withdraw == last_salary_withdraw
    end

    test "get_character_organisation/2 returns nil when the character does not have a job" do
      %{id: character_id} = character_fixture()
      %{id: organisation_id} = organisation_fixture()

      assert is_nil Organisations.get_character_organisation(character_id, organisation_id)
    end

    test "has_character_organisation?/1 returns true when the character has an organisation job." do
      %{
        character_id: character_id,
      } = charcters_organisations_fixture()

      assert Organisations.has_character_organisation?(character_id)
    end

    test "has_character_organisation?/1 returns false when the character does not have an organisation job." do
      %{id: character_id} = character_fixture()
      organisation_fixture()

      refute Organisations.has_character_organisation?(character_id)
    end

    test "create_charcters_organisations/1 with valid data creates a charcters_organisations" do
      %{id: character_id} = character_fixture()
      %{id: organisation_id} = organisation_fixture()

      valid_attrs = %{
        character_id: character_id,
        organisation_id: organisation_id,
        last_salary_withdraw: ~N[2023-10-04 20:46:00]
      }

      assert {:ok, %CharctersOrganisations{} = charcters_organisations} =
               Organisations.create_charcters_organisations(valid_attrs)

      assert charcters_organisations.last_salary_withdraw == ~N[2023-10-04 20:46:00]
    end

    test "create_charcters_organisations/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Organisations.create_charcters_organisations(@invalid_attrs)
    end

    test "update_charcters_organisations/2 with valid data updates the charcters_organisations" do
      charcters_organisations = charcters_organisations_fixture()
      update_attrs = %{last_salary_withdraw: ~N[2023-10-05 20:46:00]}

      assert {:ok, %CharctersOrganisations{} = charcters_organisations} =
               Organisations.update_charcters_organisations(charcters_organisations, update_attrs)

      assert charcters_organisations.last_salary_withdraw == ~N[2023-10-05 20:46:00]
    end

    test "update_charcters_organisations/2 with invalid data returns error changeset" do
      charcters_organisations = charcters_organisations_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organisations.update_charcters_organisations(
                 charcters_organisations,
                 @invalid_attrs
               )

      assert charcters_organisations ==
               Organisations.get_charcters_organisations!(charcters_organisations.id)
    end

    test "delete_charcters_organisations/1 deletes the charcters_organisations" do
      charcters_organisations = charcters_organisations_fixture()

      assert {:ok, %CharctersOrganisations{}} =
               Organisations.delete_charcters_organisations(charcters_organisations)

      assert_raise Ecto.NoResultsError, fn ->
        Organisations.get_charcters_organisations!(charcters_organisations.id)
      end
    end

    test "change_charcters_organisations/1 returns a charcters_organisations changeset" do
      charcters_organisations = charcters_organisations_fixture()

      assert %Ecto.Changeset{} =
               Organisations.change_charcters_organisations(charcters_organisations)
    end
  end
end
